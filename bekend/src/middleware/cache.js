const Redis = require('ioredis');
const redis = new Redis({
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  password: process.env.REDIS_PASSWORD
});

const cache = (duration) => {
  return async (req, res, next) => {
    // Пропускаем кэширование для не-GET запросов
    if (req.method !== 'GET') {
      return next();
    }

    const key = `cache:${req.originalUrl || req.url}`;

    try {
      const cachedResponse = await redis.get(key);
      
      if (cachedResponse) {
        return res.json(JSON.parse(cachedResponse));
      }

      // Сохраняем оригинальный метод res.json
      const originalJson = res.json;
      
      // Переопределяем res.json для кэширования ответа
      res.json = function(body) {
        redis.setex(key, duration, JSON.stringify(body));
        return originalJson.call(this, body);
      };

      next();
    } catch (error) {
      console.error('Cache error:', error);
      next();
    }
  };
};

// Кэширование для разных типов запросов
const productCache = cache(3600); // 1 час
const orderCache = cache(300); // 5 минут
const userCache = cache(1800); // 30 минут

module.exports = {
  productCache,
  orderCache,
  userCache
}; 