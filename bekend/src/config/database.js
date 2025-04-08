const mongoose = require('mongoose');
const config = require('./env.validation');
const logger = require('../utils/logger');

const connectDB = async () => {
  try {
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      autoIndex: config.env !== 'production',
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    };

    if (config.env === 'production') {
      options.user = config.mongodb.user;
      options.pass = config.mongodb.pass;
      options.replicaSet = config.mongodb.replicaSet;
      options.ssl = true;
      options.sslValidate = true;
    }

    await mongoose.connect(config.mongodb.uri, options);

    logger.info('MongoDB connected successfully');

    // Настройка индексов
    await setupIndexes();

    // Настройка обработчиков событий
    setupEventHandlers();

  } catch (error) {
    logger.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

const setupIndexes = async () => {
  try {
    // Индексы для коллекции пользователей
    await mongoose.model('User').createIndexes([
      { email: 1, unique: true },
      { phone: 1, unique: true },
      { 'profile.firstName': 1 },
      { 'profile.lastName': 1 },
      { createdAt: -1 },
    ]);

    // Индексы для коллекции продуктов
    await mongoose.model('Product').createIndexes([
      { name: 1 },
      { category: 1 },
      { subCategory: 1 },
      { price: 1 },
      { inStock: 1 },
      { createdAt: -1 },
      { 'ratings.average': -1 },
    ]);

    // Индексы для коллекции заказов
    await mongoose.model('Order').createIndexes([
      { user: 1 },
      { status: 1 },
      { createdAt: -1 },
      { 'items.product': 1 },
      { deliveryType: 1 },
      { paymentMethod: 1 },
    ]);

    // Индексы для коллекции отзывов
    await mongoose.model('Review').createIndexes([
      { user: 1 },
      { product: 1 },
      { order: 1 },
      { rating: 1 },
      { createdAt: -1 },
    ]);

    logger.info('Database indexes created successfully');
  } catch (error) {
    logger.error('Error creating database indexes:', error);
    throw error;
  }
};

const setupEventHandlers = () => {
  mongoose.connection.on('error', (err) => {
    logger.error('MongoDB connection error:', err);
  });

  mongoose.connection.on('disconnected', () => {
    logger.warn('MongoDB disconnected');
  });

  mongoose.connection.on('reconnected', () => {
    logger.info('MongoDB reconnected');
  });

  mongoose.connection.on('close', () => {
    logger.warn('MongoDB connection closed');
  });

  process.on('SIGINT', async () => {
    try {
      await mongoose.connection.close();
      logger.info('MongoDB connection closed through app termination');
      process.exit(0);
    } catch (err) {
      logger.error('Error during MongoDB connection closure:', err);
      process.exit(1);
    }
  });
};

module.exports = {
  connectDB,
  mongoose,
}; 