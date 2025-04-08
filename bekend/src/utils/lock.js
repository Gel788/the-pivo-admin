const { redisClient } = require('../config/redis');
const { logger } = require('./logger');

class LockService {
  constructor(client) {
    this.client = client;
  }

  /**
   * Получить блокировку
   * @param {string} key - Ключ блокировки
   * @param {number} ttl - Время жизни блокировки в секундах
   * @returns {Promise<boolean>} - Успешность получения блокировки
   */
  async acquire(key, ttl = 30) {
    try {
      const lockKey = `lock:${key}`;
      const result = await this.client.set(lockKey, '1', 'NX', 'EX', ttl);
      return result === 'OK';
    } catch (error) {
      logger.error('Lock acquisition error:', error);
      return false;
    }
  }

  /**
   * Освободить блокировку
   * @param {string} key - Ключ блокировки
   * @returns {Promise<boolean>} - Успешность освобождения блокировки
   */
  async release(key) {
    try {
      const lockKey = `lock:${key}`;
      await this.client.del(lockKey);
      return true;
    } catch (error) {
      logger.error('Lock release error:', error);
      return false;
    }
  }

  /**
   * Выполнить операцию с блокировкой
   * @param {string} key - Ключ блокировки
   * @param {Function} operation - Операция для выполнения
   * @param {number} ttl - Время жизни блокировки в секундах
   * @returns {Promise<any>} - Результат операции
   */
  async withLock(key, operation, ttl = 30) {
    const acquired = await this.acquire(key, ttl);
    if (!acquired) {
      throw new Error('Failed to acquire lock');
    }

    try {
      return await operation();
    } finally {
      await this.release(key);
    }
  }
}

module.exports = new LockService(redisClient); 