const Redis = require('ioredis');
const config = require('../config/cache.config');

class CacheManager {
  constructor() {
    this.client = new Redis(config.redis);
    this.setupErrorHandling();
  }

  setupErrorHandling() {
    this.client.on('error', (error) => {
      console.error('Redis Error:', error);
    });

    this.client.on('connect', () => {
      console.log('Connected to Redis');
    });
  }

  async get(key) {
    try {
      const value = await this.client.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error(`Error getting cache for key ${key}:`, error);
      return null;
    }
  }

  async set(key, value, ttl = config.ttl.default) {
    try {
      const stringValue = JSON.stringify(value);
      await this.client.setex(key, ttl, stringValue);
      return true;
    } catch (error) {
      console.error(`Error setting cache for key ${key}:`, error);
      return false;
    }
  }

  async delete(key) {
    try {
      await this.client.del(key);
      return true;
    } catch (error) {
      console.error(`Error deleting cache for key ${key}:`, error);
      return false;
    }
  }

  async clear() {
    try {
      await this.client.flushdb();
      return true;
    } catch (error) {
      console.error('Error clearing cache:', error);
      return false;
    }
  }

  getKeyWithPrefix(type, id) {
    const prefix = config.prefix[type];
    if (!prefix) {
      throw new Error(`Unknown cache prefix type: ${type}`);
    }
    return `${prefix}${id}`;
  }

  async healthCheck() {
    try {
      const ping = await this.client.ping();
      return ping === 'PONG';
    } catch (error) {
      console.error('Cache health check failed:', error);
      return false;
    }
  }
}

// Создаем единственный экземпляр для всего приложения
const cacheManager = new CacheManager();

module.exports = cacheManager; 