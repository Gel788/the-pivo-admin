const Order = require('../models/Order');
const Product = require('../models/Product');
const User = require('../models/User');
const logger = require('../utils/logger');
const { validationResult } = require('express-validator');

// Create new order
exports.createOrder = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { items, deliveryAddress, deliveryType, paymentMethod } = req.body;
    const userId = req.user.userId;

    // Validate products and calculate total
    let totalAmount = 0;
    const orderItems = [];

    for (const item of items) {
      const product = await Product.findById(item.product);
      if (!product) {
        return res.status(400).json({ 
          message: `Продукт ${item.product} не найден` 
        });
      }

      if (!product.isAvailable || product.inStock < item.quantity) {
        return res.status(400).json({ 
          message: `Продукт ${product.name} недоступен или недостаточно на складе` 
        });
      }

      const itemTotal = product.price * item.quantity;
      totalAmount += itemTotal;

      orderItems.push({
        product: product._id,
        quantity: item.quantity,
        price: product.price,
        notes: item.notes
      });

      // Update product stock
      product.inStock -= item.quantity;
      await product.save();
    }

    // Create order
    const order = new Order({
      user: userId,
      items: orderItems,
      totalAmount,
      deliveryAddress,
      deliveryType,
      paymentMethod,
      estimatedDeliveryTime: new Date(Date.now() + 2 * 60 * 60 * 1000) // +2 hours
    });

    await order.save();

    // Update user's loyalty points
    const loyaltyPointsEarned = Math.floor(totalAmount * 0.1); // 10% of total
    await User.findByIdAndUpdate(userId, {
      $inc: { loyaltyPoints: loyaltyPointsEarned }
    });

    order.loyaltyPointsEarned = loyaltyPointsEarned;
    await order.save();

    res.status(201).json(order);
  } catch (error) {
    logger.error('Error in createOrder:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Get user's orders
exports.getUserOrders = async (req, res) => {
  try {
    const { 
      status,
      startDate,
      endDate,
      page = 1,
      limit = 10
    } = req.query;

    const filter = { user: req.user.userId };
    
    if (status) filter.status = status;
    if (startDate || endDate) {
      filter.createdAt = {};
      if (startDate) filter.createdAt.$gte = new Date(startDate);
      if (endDate) filter.createdAt.$lte = new Date(endDate);
    }

    const skip = (page - 1) * limit;

    const [orders, total] = await Promise.all([
      Order.find(filter)
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(Number(limit))
        .populate('items.product'),
      Order.countDocuments(filter)
    ]);

    res.json({
      orders,
      pagination: {
        total,
        page: Number(page),
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    logger.error('Error in getUserOrders:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Get order by ID
exports.getOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('items.product')
      .populate('user', 'email firstName lastName phone');

    if (!order) {
      return res.status(404).json({ message: 'Заказ не найден' });
    }

    // Check if user is authorized to view this order
    if (order.user._id.toString() !== req.user.userId && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Доступ запрещен' });
    }

    res.json(order);
  } catch (error) {
    logger.error('Error in getOrder:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Update order status
exports.updateOrderStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({ message: 'Заказ не найден' });
    }

    // Only admin can update order status
    if (req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Доступ запрещен' });
    }

    order.status = status;
    if (status === 'delivered') {
      order.actualDeliveryTime = new Date();
    }

    await order.save();

    res.json(order);
  } catch (error) {
    logger.error('Error in updateOrderStatus:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Cancel order
exports.cancelOrder = async (req, res) => {
  try {
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({ message: 'Заказ не найден' });
    }

    // Check if user is authorized to cancel this order
    if (order.user.toString() !== req.user.userId && req.user.role !== 'admin') {
      return res.status(403).json({ message: 'Доступ запрещен' });
    }

    // Can only cancel pending or confirmed orders
    if (!['pending', 'confirmed'].includes(order.status)) {
      return res.status(400).json({ 
        message: 'Нельзя отменить заказ в текущем статусе' 
      });
    }

    // Return products to stock
    for (const item of order.items) {
      await Product.findByIdAndUpdate(item.product, {
        $inc: { inStock: item.quantity }
      });
    }

    // Remove loyalty points if they were earned
    if (order.loyaltyPointsEarned) {
      await User.findByIdAndUpdate(order.user, {
        $inc: { loyaltyPoints: -order.loyaltyPointsEarned }
      });
    }

    order.status = 'cancelled';
    await order.save();

    res.json(order);
  } catch (error) {
    logger.error('Error in cancelOrder:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Add order rating
exports.addOrderRating = async (req, res) => {
  try {
    const { rating, review } = req.body;
    const order = await Order.findById(req.params.id);

    if (!order) {
      return res.status(404).json({ message: 'Заказ не найден' });
    }

    // Check if user is authorized to rate this order
    if (order.user.toString() !== req.user.userId) {
      return res.status(403).json({ message: 'Доступ запрещен' });
    }

    // Can only rate delivered orders
    if (order.status !== 'delivered') {
      return res.status(400).json({ 
        message: 'Можно оценить только доставленный заказ' 
      });
    }

    // Check if order is already rated
    if (order.rating) {
      return res.status(400).json({ 
        message: 'Заказ уже оценен' 
      });
    }

    order.rating = {
      rating,
      review,
      date: new Date()
    };

    await order.save();

    res.json(order);
  } catch (error) {
    logger.error('Error in addOrderRating:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
}; 