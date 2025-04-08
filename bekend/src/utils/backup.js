const { exec } = require('child_process');
const { promisify } = require('util');
const execAsync = promisify(exec);
const path = require('path');
const fs = require('fs').promises;
const { logger } = require('./logger');

class BackupService {
  constructor() {
    this.backupDir = process.env.BACKUP_DIR || path.join(__dirname, '../../backups');
    this.mongoUri = process.env.MONGODB_URI;
    this.redisHost = process.env.REDIS_HOST || 'localhost';
    this.redisPort = process.env.REDIS_PORT || 6379;
  }

  /**
   * Создать резервную копию MongoDB
   * @returns {Promise<string>} - Путь к файлу резервной копии
   */
  async backupMongoDB() {
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const backupPath = path.join(this.backupDir, `mongodb-backup-${timestamp}`);
      
      await fs.mkdir(backupPath, { recursive: true });
      
      const { stdout, stderr } = await execAsync(
        `mongodump --uri="${this.mongoUri}" --out="${backupPath}"`
      );

      if (stderr) {
        logger.warn('MongoDB backup warnings:', stderr);
      }

      logger.info('MongoDB backup completed successfully');
      return backupPath;
    } catch (error) {
      logger.error('MongoDB backup error:', error);
      throw error;
    }
  }

  /**
   * Создать резервную копию Redis
   * @returns {Promise<string>} - Путь к файлу резервной копии
   */
  async backupRedis() {
    try {
      const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
      const backupPath = path.join(this.backupDir, `redis-backup-${timestamp}.rdb`);
      
      const { stdout, stderr } = await execAsync(
        `redis-cli -h ${this.redisHost} -p ${this.redisPort} SAVE`
      );

      if (stderr) {
        logger.warn('Redis backup warnings:', stderr);
      }

      // Копируем файл дампа
      await execAsync(
        `cp ${process.env.REDIS_DUMP_PATH || '/var/lib/redis/dump.rdb'} ${backupPath}`
      );

      logger.info('Redis backup completed successfully');
      return backupPath;
    } catch (error) {
      logger.error('Redis backup error:', error);
      throw error;
    }
  }

  /**
   * Восстановить MongoDB из резервной копии
   * @param {string} backupPath - Путь к резервной копии
   */
  async restoreMongoDB(backupPath) {
    try {
      const { stdout, stderr } = await execAsync(
        `mongorestore --uri="${this.mongoUri}" "${backupPath}"`
      );

      if (stderr) {
        logger.warn('MongoDB restore warnings:', stderr);
      }

      logger.info('MongoDB restore completed successfully');
    } catch (error) {
      logger.error('MongoDB restore error:', error);
      throw error;
    }
  }

  /**
   * Восстановить Redis из резервной копии
   * @param {string} backupPath - Путь к резервной копии
   */
  async restoreRedis(backupPath) {
    try {
      // Останавливаем Redis
      await execAsync('redis-cli SHUTDOWN');

      // Копируем файл дампа
      await execAsync(
        `cp ${backupPath} ${process.env.REDIS_DUMP_PATH || '/var/lib/redis/dump.rdb'}`
      );

      // Запускаем Redis
      await execAsync('redis-server');

      logger.info('Redis restore completed successfully');
    } catch (error) {
      logger.error('Redis restore error:', error);
      throw error;
    }
  }

  /**
   * Создать полную резервную копию системы
   * @returns {Promise<{mongo: string, redis: string}>} - Пути к файлам резервных копий
   */
  async createFullBackup() {
    try {
      const mongoBackup = await this.backupMongoDB();
      const redisBackup = await this.backupRedis();

      logger.info('Full backup completed successfully');
      return {
        mongo: mongoBackup,
        redis: redisBackup
      };
    } catch (error) {
      logger.error('Full backup error:', error);
      throw error;
    }
  }

  /**
   * Восстановить систему из полной резервной копии
   * @param {string} mongoBackup - Путь к резервной копии MongoDB
   * @param {string} redisBackup - Путь к резервной копии Redis
   */
  async restoreFullBackup(mongoBackup, redisBackup) {
    try {
      await this.restoreMongoDB(mongoBackup);
      await this.restoreRedis(redisBackup);

      logger.info('Full restore completed successfully');
    } catch (error) {
      logger.error('Full restore error:', error);
      throw error;
    }
  }
}

module.exports = new BackupService(); 