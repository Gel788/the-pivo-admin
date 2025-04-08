require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const { logger } = require('./utils/logger');
const { metrics, metricsMiddleware } = require('./monitoring/metrics');
const scalingService = require('./utils/scaling');
const backupService = require('./utils/backup');
const lockService = require('./utils/lock');
const { redisClient } = require('./config/redis');

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/user');
const productRoutes = require('./routes/product');
const orderRoutes = require('./routes/order');
const paymentRoutes = require('./routes/payment');
const routes = require('./routes');

// Инициализация приложения
const app = express();

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN,
  credentials: true
}));
app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(metricsMiddleware);

// Rate limiting
const limiter = rateLimit({
  windowMs: process.env.RATE_LIMIT_WINDOW * 60 * 1000,
  max: process.env.RATE_LIMIT_MAX
});
app.use(limiter);

// Подключение к MongoDB
mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => logger.info('Connected to MongoDB'))
.catch(err => logger.error('MongoDB connection error:', err));

// Инициализация мониторинга
const startMonitoring = () => {
  // Запуск сбора метрик
  metrics.httpRequestDurationMicroseconds.start();
  metrics.httpRequestsTotal.start();
  metrics.dbQueryDurationSeconds.start();
  metrics.dbConnectionsTotal.start();
  metrics.redisOperationsTotal.start();
  metrics.redisMemoryUsageBytes.start();
  metrics.queueSize.start();
  metrics.queueProcessingDurationSeconds.start();
  metrics.activeUsersTotal.start();
  metrics.ordersTotal.start();
  metrics.revenueTotal.start();

  // Запуск автоматического масштабирования
  scalingService.startMonitoring();

  // Настройка периодического резервного копирования
  setInterval(async () => {
    try {
      await backupService.createFullBackup();
    } catch (error) {
      logger.error('Scheduled backup error:', error);
    }
  }, 24 * 60 * 60 * 1000); // Раз в день

  logger.info('Monitoring started');
};

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/payments', paymentRoutes);
app.use('/api', routes);

// Обработка ошибок
app.use((err, req, res, next) => {
  logger.error('Unhandled error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Graceful shutdown
const gracefulShutdown = async () => {
  logger.info('Received shutdown signal');

  // Останавливаем прием новых запросов
  app.close(() => {
    logger.info('HTTP server closed');
  });

  // Закрываем соединения с базой данных
  await mongoose.connection.close();
  logger.info('MongoDB connection closed');

  // Закрываем соединение с Redis
  await redisClient.quit();
  logger.info('Redis connection closed');

  // Останавливаем мониторинг
  metrics.httpRequestDurationMicroseconds.stop();
  metrics.httpRequestsTotal.stop();
  metrics.dbQueryDurationSeconds.stop();
  metrics.dbConnectionsTotal.stop();
  metrics.redisOperationsTotal.stop();
  metrics.redisMemoryUsageBytes.stop();
  metrics.queueSize.stop();
  metrics.queueProcessingDurationSeconds.stop();
  metrics.activeUsersTotal.stop();
  metrics.ordersTotal.stop();
  metrics.revenueTotal.stop();
  logger.info('Monitoring stopped');

  process.exit(0);
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);

// Запуск сервера
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Server is running on port ${PORT}`);
  startMonitoring();
});

module.exports = app; 