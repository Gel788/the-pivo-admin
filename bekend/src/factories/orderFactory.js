const { AppError } = require('../middleware/errorHandler');

class OrderFactory {
  static createOrder(data) {
    const {
      items,
      totalAmount,
      status = 'pending',
      deliveryAddress,
      paymentMethod,
      user
    } = data;

    // Валидация обязательных полей
    if (!items || !Array.isArray(items) || items.length === 0) {
      throw new AppError('Заказ должен содержать хотя бы один товар', 400);
    }

    if (!totalAmount || totalAmount <= 0) {
      throw new AppError('Некорректная сумма заказа', 400);
    }

    if (!deliveryAddress) {
      throw new AppError('Не указан адрес доставки', 400);
    }

    if (!paymentMethod) {
      throw new AppError('Не указан способ оплаты', 400);
    }

    // Валидация статуса
    const validStatuses = ['pending', 'processing', 'completed', 'cancelled'];
    if (!validStatuses.includes(status)) {
      throw new AppError('Некорректный статус заказа', 400);
    }

    // Валидация способа оплаты
    const validPaymentMethods = ['card', 'cash', 'online'];
    if (!validPaymentMethods.includes(paymentMethod)) {
      throw new AppError('Некорректный способ оплаты', 400);
    }

    // Создание заказа
    return {
      items: items.map(item => ({
        product: item.product,
        quantity: item.quantity,
        price: item.price
      })),
      totalAmount,
      status,
      deliveryAddress,
      paymentMethod,
      user,
      createdAt: new Date(),
      updatedAt: new Date()
    };
  }

  static createOrderFromRequest(req) {
    const { items, totalAmount, deliveryAddress, paymentMethod } = req.body;
    const user = req.user._id;

    return this.createOrder({
      items,
      totalAmount,
      deliveryAddress,
      paymentMethod,
      user
    });
  }

  static updateOrderStatus(order, newStatus) {
    const validStatuses = ['pending', 'processing', 'completed', 'cancelled'];
    
    if (!validStatuses.includes(newStatus)) {
      throw new AppError('Некорректный статус заказа', 400);
    }

    // Проверка возможности изменения статуса
    const statusFlow = {
      pending: ['processing', 'cancelled'],
      processing: ['completed', 'cancelled'],
      completed: [],
      cancelled: []
    };

    if (!statusFlow[order.status].includes(newStatus)) {
      throw new AppError('Невозможно изменить статус заказа', 400);
    }

    return {
      ...order,
      status: newStatus,
      updatedAt: new Date()
    };
  }
}

module.exports = OrderFactory; 