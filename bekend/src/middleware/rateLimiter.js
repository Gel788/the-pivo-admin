const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const Redis = require('ioredis');

const redis = new Redis({
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  password: process.env.REDIS_PASSWORD
});

const createRateLimiter = (options = {}) => {
  return rateLimit({
    store: new RedisStore({
      client: redis,
      prefix: 'rate-limit:'
    }),
    windowMs: options.windowMs || 15 * 60 * 1000, // 15 минут по умолчанию
    max: options.max || 100, // максимум 100 запросов по умолчанию
    message: {
      error: 'Слишком много запросов, пожалуйста, попробуйте позже'
    },
    standardHeaders: true,
    legacyHeaders: false,
    ...options
  });
};

// Лимиты для разных типов запросов
const authLimiter = createRateLimiter({
  windowMs: 60 * 60 * 1000, // 1 час
  max: 5, // 5 попыток
  message: {
    error: 'Слишком много попыток входа, пожалуйста, попробуйте через час'
  }
});

const apiLimiter = createRateLimiter({
  windowMs: 15 * 60 * 1000, // 15 минут
  max: 100 // 100 запросов
});

const orderLimiter = createRateLimiter({
  windowMs: 60 * 60 * 1000, // 1 час
  max: 50 // 50 заказов
});

module.exports = {
  authLimiter,
  apiLimiter,
  orderLimiter
}; 