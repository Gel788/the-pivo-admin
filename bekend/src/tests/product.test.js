const request = require('supertest');
const app = require('../app');
const Product = require('../models/Product');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

describe('Продукты', () => {
  let token;
  const testUser = {
    email: 'admin@example.com',
    password: 'password123',
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

  beforeEach(async () => {
    await Product.deleteMany({});
    await User.deleteMany({});
    const user = await User.create(testUser);
    token = generateToken(user);
  });

  describe('GET /api/products', () => {
    beforeEach(async () => {
      await Product.create(testProduct);
    });

    it('должен получить список всех продуктов', async () => {
      const res = await request(app)
        .get('/api/products');

      expect(res.statusCode).toBe(200);
      expect(Array.isArray(res.body)).toBeTruthy();
      expect(res.body.length).toBe(1);
      expect(res.body[0]).toHaveProperty('name', testProduct.name);
    });

    it('должен фильтровать продукты по категории', async () => {
      const res = await request(app)
        .get('/api/products')
        .query({ category: 'Test Category' });

      expect(res.statusCode).toBe(200);
      expect(res.body.length).toBe(1);
      expect(res.body[0]).toHaveProperty('category', 'Test Category');
    });
  });

  describe('POST /api/products', () => {
    it('должен создать новый продукт', async () => {
      const res = await request(app)
        .post('/api/products')
        .set('Authorization', `Bearer ${token}`)
        .send(testProduct);

      expect(res.statusCode).toBe(201);
      expect(res.body).toHaveProperty('name', testProduct.name);
      expect(res.body).toHaveProperty('price', testProduct.price);
    });

    it('не должен создавать продукт без авторизации', async () => {
      const res = await request(app)
        .post('/api/products')
        .send(testProduct);

      expect(res.statusCode).toBe(401);
    });
  });

  describe('GET /api/products/:id', () => {
    let productId;

    beforeEach(async () => {
      const product = await Product.create(testProduct);
      productId = product._id;
    });

    it('должен получить продукт по ID', async () => {
      const res = await request(app)
        .get(`/api/products/${productId}`);

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('name', testProduct.name);
    });

    it('должен вернуть 404 для несуществующего ID', async () => {
      const res = await request(app)
        .get('/api/products/5f7d3a2b1c9d440000000000');

      expect(res.statusCode).toBe(404);
    });
  });

  describe('PUT /api/products/:id', () => {
    let productId;

    beforeEach(async () => {
      const product = await Product.create(testProduct);
      productId = product._id;
    });

    it('должен обновить продукт', async () => {
      const updateData = {
        name: 'Updated Product',
        price: 200
      };

      const res = await request(app)
        .put(`/api/products/${productId}`)
        .set('Authorization', `Bearer ${token}`)
        .send(updateData);

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('name', updateData.name);
      expect(res.body).toHaveProperty('price', updateData.price);
    });

    it('не должен обновлять продукт без авторизации', async () => {
      const res = await request(app)
        .put(`/api/products/${productId}`)
        .send({ name: 'Updated Product' });

      expect(res.statusCode).toBe(401);
    });
  });

  describe('DELETE /api/products/:id', () => {
    let productId;

    beforeEach(async () => {
      const product = await Product.create(testProduct);
      productId = product._id;
    });

    it('должен удалить продукт', async () => {
      const res = await request(app)
        .delete(`/api/products/${productId}`)
        .set('Authorization', `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      
      const deletedProduct = await Product.findById(productId);
      expect(deletedProduct).toBeNull();
    });

    it('не должен удалять продукт без авторизации', async () => {
      const res = await request(app)
        .delete(`/api/products/${productId}`);

      expect(res.statusCode).toBe(401);
      
      const product = await Product.findById(productId);
      expect(product).not.toBeNull();
    });
  });
}); 