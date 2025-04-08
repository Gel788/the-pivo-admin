const cacheConfig = {
  // Основные настройки Redis
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT) || 6379,
    password: process.env.REDIS_PASSWORD,
    db: parseInt(process.env.REDIS_DB) || 0,
    
    // Настройки повторных попыток подключения
    retryStrategy: function (times) {
      const delay = Math.min(times * 50, 2000);
      return delay;
    },
    
    // Обработка ошибок подключения
    maxRetriesPerRequest: 3,
    enableReadyCheck: true,
    
    // Таймауты
    connectTimeout: 10000,
    commandTimeout: 5000,
  },

  // Настройки кэширования
  ttl: {
    default: 3600, // 1 час
    short: 300,    // 5 минут
    medium: 7200,  // 2 часа
    long: 86400,   // 24 часа
  },

  // Префиксы для разных типов данных
  prefix: {
    user: 'user:',
    product: 'product:',
    order: 'order:',
    restaurant: 'restaurant:',
  },

  // Настройки для разных окружений
  environments: {
    development: {
      enableLogging: true,
      enableCompression: false,
    },
    production: {
      enableLogging: false,
      enableCompression: true,
    },
    test: {
      enableLogging: false,
      enableCompression: false,
      mock: true,
      // Специальные настройки для тестов
      redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT) || 6379,
        password: process.env.REDIS_PASSWORD,
        db: parseInt(process.env.REDIS_DB) || 0,
        // Уменьшаем таймауты для тестов
        connectTimeout: 5000,
        commandTimeout: 2000,
        // Отключаем повторные попытки в тестах
        maxRetriesPerRequest: 1,
        retryStrategy: null,
      }
    },
  },
};

// Получаем текущее окружение
const env = process.env.NODE_ENV || 'development';

// Экспортируем конфигурацию с учетом окружения
module.exports = {
  ...cacheConfig,
  redis: {
    ...cacheConfig.redis,
    ...(cacheConfig.environments[env]?.redis || {})
  }
}; 