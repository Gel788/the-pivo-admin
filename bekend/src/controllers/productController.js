const Product = require('../models/Product');
const logger = require('../utils/logger');
const { validationResult } = require('express-validator');

// Get all products with filtering and pagination
exports.getProducts = async (req, res) => {
  try {
    const { 
      category,
      subCategory,
      search,
      minPrice,
      maxPrice,
      sortBy,
      page = 1,
      limit = 10
    } = req.query;

    // Build filter object
    const filter = {};
    if (category) filter.category = category;
    if (subCategory) filter.subCategory = subCategory;
    if (search) {
      filter.$or = [
        { name: { $regex: search, $options: 'i' } },
        { description: { $regex: search, $options: 'i' } }
      ];
    }
    if (minPrice || maxPrice) {
      filter.price = {};
      if (minPrice) filter.price.$gte = Number(minPrice);
      if (maxPrice) filter.price.$lte = Number(maxPrice);
    }

    // Build sort object
    const sort = {};
    if (sortBy) {
      const [field, order] = sortBy.split(':');
      sort[field] = order === 'desc' ? -1 : 1;
    } else {
      sort.createdAt = -1;
    }

    const skip = (page - 1) * limit;

    const [products, total] = await Promise.all([
      Product.find(filter)
        .sort(sort)
        .skip(skip)
        .limit(Number(limit))
        .populate('promotions'),
      Product.countDocuments(filter)
    ]);

    res.json({
      products,
      pagination: {
        total,
        page: Number(page),
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    logger.error('Error in getProducts:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Get product by ID
exports.getProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id)
      .populate('promotions');

    if (!product) {
      return res.status(404).json({ message: 'Продукт не найден' });
    }

    res.json(product);
  } catch (error) {
    logger.error('Error in getProduct:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Create new product
exports.createProduct = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const product = new Product(req.body);
    await product.save();

    res.status(201).json(product);
  } catch (error) {
    logger.error('Error in createProduct:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Update product
exports.updateProduct = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const product = await Product.findByIdAndUpdate(
      req.params.id,
      { $set: req.body },
      { new: true, runValidators: true }
    );

    if (!product) {
      return res.status(404).json({ message: 'Продукт не найден' });
    }

    res.json(product);
  } catch (error) {
    logger.error('Error in updateProduct:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Delete product
exports.deleteProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndDelete(req.params.id);

    if (!product) {
      return res.status(404).json({ message: 'Продукт не найден' });
    }

    res.json({ message: 'Продукт успешно удален' });
  } catch (error) {
    logger.error('Error in deleteProduct:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
};

// Add product rating
exports.addRating = async (req, res) => {
  try {
    const { rating, review } = req.body;
    const userId = req.user.userId;

    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Продукт не найден' });
    }

    // Check if user already rated
    const existingRating = product.ratings.find(r => r.user.toString() === userId);
    if (existingRating) {
      return res.status(400).json({ message: 'Вы уже оценили этот продукт' });
    }

    product.ratings.push({
      user: userId,
      rating,
      review,
      date: new Date()
    });

    await product.save();

    res.json(product);
  } catch (error) {
    logger.error('Error in addRating:', error);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
}; 