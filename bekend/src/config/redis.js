const Redis = require('ioredis');
const { logger } = require('../utils/logger');

const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  password: process.env.REDIS_PASSWORD,
  retryStrategy: (times) => {
    const delay = Math.min(times * 50, 2000);
    return delay;
  },
  maxRetriesPerRequest: 3
};

const redisClient = new Redis(redisConfig);

redisClient.on('connect', () => {
  logger.info('Redis connected successfully');
});

redisClient.on('error', (err) => {
  logger.error('Redis connection error:', err);
});

// Класс для работы с кэшем
class CacheService {
  constructor(client) {
    this.client = client;
  }

  async set(key, value, expireTime = 3600) {
    try {
      const serializedValue = JSON.stringify(value);
      await this.client.set(key, serializedValue, 'EX', expireTime);
      return true;
    } catch (error) {
      logger.error('Cache set error:', error);
      return false;
    }
  }

  async get(key) {
    try {
      const value = await this.client.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      logger.error('Cache get error:', error);
      return null;
    }
  }

  async delete(key) {
    try {
      await this.client.del(key);
      return true;
    } catch (error) {
      logger.error('Cache delete error:', error);
      return false;
    }
  }

  async clear() {
    try {
      await this.client.flushall();
      return true;
    } catch (error) {
      logger.error('Cache clear error:', error);
      return false;
    }
  }
}

// Класс для управления сессиями
class SessionService {
  constructor(client) {
    this.client = client;
  }

  async createSession(userId, sessionData, expireTime = 86400) {
    try {
      const sessionId = `session:${userId}`;
      await this.client.set(sessionId, JSON.stringify(sessionData), 'EX', expireTime);
      return sessionId;
    } catch (error) {
      logger.error('Session creation error:', error);
      return null;
    }
  }

  async getSession(sessionId) {
    try {
      const session = await this.client.get(sessionId);
      return session ? JSON.parse(session) : null;
    } catch (error) {
      logger.error('Session get error:', error);
      return null;
    }
  }

  async updateSession(sessionId, sessionData, expireTime = 86400) {
    try {
      await this.client.set(sessionId, JSON.stringify(sessionData), 'EX', expireTime);
      return true;
    } catch (error) {
      logger.error('Session update error:', error);
      return false;
    }
  }

  async deleteSession(sessionId) {
    try {
      await this.client.del(sessionId);
      return true;
    } catch (error) {
      logger.error('Session delete error:', error);
      return false;
    }
  }
}

module.exports = {
  redisClient,
  cacheService: new CacheService(redisClient),
  sessionService: new SessionService(redisClient)
}; 