const Queue = require('bull');
const { logger } = require('../utils/logger');
const OrderRepository = require('../repositories/orderRepository');
const NotificationService = require('../services/notificationService');

// Создаем очередь для обработки заказов
const orderQueue = new Queue('order-processing', {
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD
  }
});

// Обработчик для создания заказа
orderQueue.process('create-order', async (job) => {
  try {
    const { orderData } = job.data;
    const orderRepository = new OrderRepository();
    
    // Создаем заказ
    const order = await orderRepository.create(orderData);
    
    // Отправляем уведомление
    await NotificationService.sendOrderConfirmation(order);
    
    return { success: true, orderId: order._id };
  } catch (error) {
    logger.error('Error processing create-order job:', error);
    throw error;
  }
});

// Обработчик для обновления статуса заказа
orderQueue.process('update-order-status', async (job) => {
  try {
    const { orderId, newStatus } = job.data;
    const orderRepository = new OrderRepository();
    
    // Обновляем статус
    const order = await orderRepository.updateStatus(orderId, newStatus);
    
    // Отправляем уведомление
    await NotificationService.sendOrderStatusUpdate(order);
    
    return { success: true, orderId: order._id };
  } catch (error) {
    logger.error('Error processing update-order-status job:', error);
    throw error;
  }
});

// Обработчик для обработки платежа
orderQueue.process('process-payment', async (job) => {
  try {
    const { orderId, paymentData } = job.data;
    const orderRepository = new OrderRepository();
    
    // Обрабатываем платеж
    const paymentResult = await orderRepository.processPayment(orderId, paymentData);
    
    // Обновляем статус заказа
    if (paymentResult.success) {
      await orderRepository.updateStatus(orderId, 'processing');
    }
    
    return { success: true, orderId, paymentResult };
  } catch (error) {
    logger.error('Error processing payment job:', error);
    throw error;
  }
});

// Обработчики событий очереди
orderQueue.on('completed', (job, result) => {
  logger.info(`Job ${job.id} completed. Result:`, result);
});

orderQueue.on('failed', (job, error) => {
  logger.error(`Job ${job.id} failed. Error:`, error);
});

orderQueue.on('stalled', (job) => {
  logger.warn(`Job ${job.id} stalled`);
});

// Методы для добавления задач в очередь
const addCreateOrderJob = async (orderData) => {
  return await orderQueue.add('create-order', { orderData }, {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    },
    removeOnComplete: true
  });
};

const addUpdateOrderStatusJob = async (orderId, newStatus) => {
  return await orderQueue.add('update-order-status', { orderId, newStatus }, {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    },
    removeOnComplete: true
  });
};

const addProcessPaymentJob = async (orderId, paymentData) => {
  return await orderQueue.add('process-payment', { orderId, paymentData }, {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    },
    removeOnComplete: true
  });
};

module.exports = {
  orderQueue,
  addCreateOrderJob,
  addUpdateOrderStatusJob,
  addProcessPaymentJob
}; 