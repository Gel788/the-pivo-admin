const mongoose = require('mongoose');

/**
 * @swagger
 * components:
 *   schemas:
 *     Order:
 *       type: object
 *       required:
 *         - user
 *         - items
 *         - totalAmount
 *         - status
 *       properties:
 *         user:
 *           type: string
 *           description: ID пользователя, создавшего заказ
 *         items:
 *           type: array
 *           items:
 *             type: object
 *             required:
 *               - product
 *               - quantity
 *               - price
 *             properties:
 *               product:
 *                 type: string
 *                 description: ID продукта
 *               quantity:
 *                 type: integer
 *                 minimum: 1
 *                 description: Количество
 *               price:
 *                 type: number
 *                 description: Цена за единицу
 *         totalAmount:
 *           type: number
 *           description: Общая сумма заказа
 *         status:
 *           type: string
 *           enum: [pending, processing, delivered, cancelled]
 *           description: Статус заказа
 *         deliveryAddress:
 *           type: object
 *           required:
 *             - street
 *             - city
 *             - zipCode
 *           properties:
 *             street:
 *               type: string
 *             city:
 *               type: string
 *             zipCode:
 *               type: string
 *         paymentStatus:
 *           type: string
 *           enum: [pending, paid, failed]
 *           description: Статус оплаты
 *         paymentMethod:
 *           type: string
 *           enum: [card, cash]
 *           description: Способ оплаты
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: Дата создания заказа
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: Дата последнего обновления заказа
 */
const orderSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  items: [{
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product',
      required: true
    },
    quantity: {
      type: Number,
      required: true,
      min: 1
    },
    price: {
      type: Number,
      required: true
    },
    notes: String
  }],
  totalAmount: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'processing', 'delivered', 'cancelled'],
    default: 'pending'
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'paid', 'failed'],
    default: 'pending'
  },
  paymentMethod: {
    type: String,
    enum: ['card', 'cash'],
    required: true
  },
  deliveryAddress: {
    street: {
      type: String,
      required: true
    },
    city: {
      type: String,
      required: true
    },
    zipCode: {
      type: String,
      required: true
    }
  },
  deliveryType: {
    type: String,
    enum: ['pickup', 'delivery'],
    required: true
  },
  deliveryInstructions: String,
  estimatedDeliveryTime: Date,
  actualDeliveryTime: Date,
  discount: {
    type: Number,
    default: 0
  },
  appliedPromotions: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Promotion'
  }],
  loyaltyPointsEarned: {
    type: Number,
    default: 0
  },
  rating: {
    rating: {
      type: Number,
      min: 1,
      max: 5
    },
    review: String,
    date: Date
  }
}, {
  timestamps: true
});

// Индексы для оптимизации запросов
orderSchema.index({ user: 1, createdAt: -1 });
orderSchema.index({ status: 1 });
orderSchema.index({ paymentStatus: 1 });

// Методы модели
orderSchema.methods.calculateTotal = function() {
  this.totalAmount = this.items.reduce((total, item) => {
    return total + (item.price * item.quantity);
  }, 0);
  return this.totalAmount;
};

// Статические методы
orderSchema.statics.findByUser = function(userId) {
  return this.find({ user: userId })
    .sort({ createdAt: -1 })
    .populate('items.product');
};

orderSchema.statics.findPendingOrders = function() {
  return this.find({ status: 'pending' })
    .populate('user')
    .populate('items.product');
};

orderSchema.pre('save', function(next) {
  if (this.status === 'delivered' && !this.actualDeliveryTime) {
    this.actualDeliveryTime = new Date();
  }
  next();
});

const Order = mongoose.model('Order', orderSchema);

module.exports = Order; 