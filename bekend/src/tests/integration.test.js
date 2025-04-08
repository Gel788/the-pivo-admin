const request = require('supertest');
const app = require('../app');
const User = require('../models/User');
const Product = require('../models/Product');
const Order = require('../models/Order');
const { generateToken } = require('../utils/jwt');

describe('Интеграционные тесты', () => {
  let userToken;
  let adminToken;
  let productId;
  let orderId;

  const testUser = {
    email: 'user@example.com',
    password: 'password123',
    name: 'Test User',
    role: 'user'
  };

  const testAdmin = {
    email: 'admin@example.com',
    password: 'admin123',
    name: 'Admin User',
    role: 'admin'
  };

  const testProduct = {
    name: 'Test Product',
    description: 'Test Description',
    price: 100,
    category: 'Test Category',
    image: 'test.jpg',
    isAvailable: true
  };

  beforeAll(async () => {
    await User.deleteMany({});
    await Product.deleteMany({});
    await Order.deleteMany({});

    const user = await User.create(testUser);
    const admin = await User.create(testAdmin);
    
    userToken = generateToken(user);
    adminToken = generateToken(admin);
  });

  describe('Полный цикл заказа', () => {
    it('должен создать продукт, заказ и обновить его статус', async () => {
      // Создание продукта
      const productRes = await request(app)
        .post('/api/products')
        .set('Authorization', `Bearer ${adminToken}`)
        .send(testProduct);

      expect(productRes.statusCode).toBe(201);
      productId = productRes.body._id;

      // Создание заказа
      const orderRes = await request(app)
        .post('/api/orders')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          items: [{ product: productId, quantity: 2 }],
          totalAmount: 200,
          status: 'pending',
          deliveryAddress: 'Test Address',
          paymentMethod: 'card'
        });

      expect(orderRes.statusCode).toBe(201);
      orderId = orderRes.body._id;

      // Обновление статуса заказа
      const updateRes = await request(app)
        .put(`/api/orders/${orderId}/status`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({ status: 'completed' });

      expect(updateRes.statusCode).toBe(200);
      expect(updateRes.body.status).toBe('completed');
    });
  });

  describe('Проверка прав доступа', () => {
    it('пользователь не должен иметь доступ к админским функциям', async () => {
      const res = await request(app)
        .post('/api/products')
        .set('Authorization', `Bearer ${userToken}`)
        .send(testProduct);

      expect(res.statusCode).toBe(403);
    });

    it('админ должен иметь доступ ко всем функциям', async () => {
      const res = await request(app)
        .get('/api/orders')
        .set('Authorization', `Bearer ${adminToken}`);

      expect(res.statusCode).toBe(200);
    });
  });

  describe('Проверка бизнес-логики', () => {
    it('нельзя создать заказ с недоступным продуктом', async () => {
      // Создаем недоступный продукт
      const unavailableProduct = await Product.create({
        ...testProduct,
        isAvailable: false
      });

      const res = await request(app)
        .post('/api/orders')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          items: [{ product: unavailableProduct._id, quantity: 1 }],
          totalAmount: 100,
          status: 'pending',
          deliveryAddress: 'Test Address',
          paymentMethod: 'card'
        });

      expect(res.statusCode).toBe(400);
    });

    it('нельзя обновить статус заказа на недопустимый', async () => {
      const res = await request(app)
        .put(`/api/orders/${orderId}/status`)
        .set('Authorization', `Bearer ${userToken}`)
        .send({ status: 'invalid_status' });

      expect(res.statusCode).toBe(400);
    });
  });

  describe('Проверка граничных случаев', () => {
    it('нельзя создать заказ с нулевым количеством товаров', async () => {
      const res = await request(app)
        .post('/api/orders')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          items: [{ product: productId, quantity: 0 }],
          totalAmount: 0,
          status: 'pending',
          deliveryAddress: 'Test Address',
          paymentMethod: 'card'
        });

      expect(res.statusCode).toBe(400);
    });

    it('нельзя создать заказ с отрицательной суммой', async () => {
      const res = await request(app)
        .post('/api/orders')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          items: [{ product: productId, quantity: 1 }],
          totalAmount: -100,
          status: 'pending',
          deliveryAddress: 'Test Address',
          paymentMethod: 'card'
        });

      expect(res.statusCode).toBe(400);
    });
  });
}); 