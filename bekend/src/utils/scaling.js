const os = require('os');
const { logger } = require('./logger');
const { metrics } = require('../monitoring/metrics');

class ScalingService {
  constructor() {
    this.cpuThreshold = process.env.CPU_THRESHOLD || 80;
    this.memoryThreshold = process.env.MEMORY_THRESHOLD || 80;
    this.requestThreshold = process.env.REQUEST_THRESHOLD || 1000;
    this.scaleUpThreshold = process.env.SCALE_UP_THRESHOLD || 3;
    this.scaleDownThreshold = process.env.SCALE_DOWN_THRESHOLD || 1;
    this.checkInterval = process.env.SCALING_CHECK_INTERVAL || 60000;
    this.isScaling = false;
  }

  /**
   * Запустить мониторинг и автоматическое масштабирование
   */
  startMonitoring() {
    setInterval(() => this.checkAndScale(), this.checkInterval);
    logger.info('Scaling monitoring started');
  }

  /**
   * Проверить метрики и выполнить масштабирование при необходимости
   */
  async checkAndScale() {
    if (this.isScaling) {
      logger.info('Scaling already in progress, skipping check');
      return;
    }

    try {
      this.isScaling = true;

      const cpuUsage = await this.getCPUUsage();
      const memoryUsage = await this.getMemoryUsage();
      const requestRate = await this.getRequestRate();

      logger.info('Current metrics:', {
        cpuUsage,
        memoryUsage,
        requestRate
      });

      if (this.shouldScaleUp(cpuUsage, memoryUsage, requestRate)) {
        await this.scaleUp();
      } else if (this.shouldScaleDown(cpuUsage, memoryUsage, requestRate)) {
        await this.scaleDown();
      }
    } catch (error) {
      logger.error('Scaling check error:', error);
    } finally {
      this.isScaling = false;
    }
  }

  /**
   * Получить использование CPU
   * @returns {Promise<number>} - Процент использования CPU
   */
  async getCPUUsage() {
    const cpus = os.cpus();
    const totalIdle = cpus.reduce((acc, cpu) => acc + cpu.times.idle, 0);
    const totalTick = cpus.reduce((acc, cpu) => 
      acc + Object.values(cpu.times).reduce((sum, time) => sum + time, 0), 0);
    return 100 - (totalIdle / totalTick * 100);
  }

  /**
   * Получить использование памяти
   * @returns {Promise<number>} - Процент использования памяти
   */
  async getMemoryUsage() {
    const totalMem = os.totalmem();
    const freeMem = os.freemem();
    return ((totalMem - freeMem) / totalMem) * 100;
  }

  /**
   * Получить текущую скорость запросов
   * @returns {Promise<number>} - Количество запросов в секунду
   */
  async getRequestRate() {
    return metrics.httpRequestsTotal.get();
  }

  /**
   * Проверить необходимость масштабирования вверх
   * @param {number} cpuUsage - Использование CPU
   * @param {number} memoryUsage - Использование памяти
   * @param {number} requestRate - Скорость запросов
   * @returns {boolean} - Необходимость масштабирования
   */
  shouldScaleUp(cpuUsage, memoryUsage, requestRate) {
    return (
      cpuUsage > this.cpuThreshold ||
      memoryUsage > this.memoryThreshold ||
      requestRate > this.requestThreshold
    );
  }

  /**
   * Проверить необходимость масштабирования вниз
   * @param {number} cpuUsage - Использование CPU
   * @param {number} memoryUsage - Использование памяти
   * @param {number} requestRate - Скорость запросов
   * @returns {boolean} - Необходимость масштабирования
   */
  shouldScaleDown(cpuUsage, memoryUsage, requestRate) {
    return (
      cpuUsage < this.cpuThreshold / 2 &&
      memoryUsage < this.memoryThreshold / 2 &&
      requestRate < this.requestThreshold / 2
    );
  }

  /**
   * Масштабировать вверх
   */
  async scaleUp() {
    try {
      logger.info('Scaling up...');
      // Здесь должна быть логика масштабирования
      // Например, запуск дополнительных инстансов через Docker или Kubernetes
      await this.updateServiceCount(this.scaleUpThreshold);
      logger.info('Scale up completed');
    } catch (error) {
      logger.error('Scale up error:', error);
      throw error;
    }
  }

  /**
   * Масштабировать вниз
   */
  async scaleDown() {
    try {
      logger.info('Scaling down...');
      // Здесь должна быть логика масштабирования
      // Например, остановка лишних инстансов через Docker или Kubernetes
      await this.updateServiceCount(this.scaleDownThreshold);
      logger.info('Scale down completed');
    } catch (error) {
      logger.error('Scale down error:', error);
      throw error;
    }
  }

  /**
   * Обновить количество сервисов
   * @param {number} count - Новое количество сервисов
   */
  async updateServiceCount(count) {
    // Здесь должна быть реализация обновления количества сервисов
    // Например, через Docker API или Kubernetes API
    logger.info(`Updating service count to ${count}`);
  }
}

module.exports = new ScalingService(); 