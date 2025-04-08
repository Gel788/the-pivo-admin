const request = require('supertest');
const app = require('../app');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

describe('Аутентификация', () => {
  const testUser = {
    email: 'test@example.com',
    password: 'password123',
    name: 'Test User'
  };

  beforeEach(async () => {
    await User.deleteMany({});
  });

  describe('POST /api/auth/register', () => {
    it('должен зарегистрировать нового пользователя', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send(testUser);

      expect(res.statusCode).toBe(201);
      expect(res.body).toHaveProperty('token');
      expect(res.body.user).toHaveProperty('email', testUser.email);
      expect(res.body.user).toHaveProperty('name', testUser.name);
    });

    it('не должен регистрировать пользователя с существующим email', async () => {
      await User.create(testUser);

      const res = await request(app)
        .post('/api/auth/register')
        .send(testUser);

      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty('message', 'Пользователь уже существует');
    });
  });

  describe('POST /api/auth/login', () => {
    beforeEach(async () => {
      await User.create(testUser);
    });

    it('должен авторизовать пользователя с правильными данными', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password
        });

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('token');
      expect(res.body.user).toHaveProperty('email', testUser.email);
    });

    it('не должен авторизовать пользователя с неправильным паролем', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({
          email: testUser.email,
          password: 'wrongpassword'
        });

      expect(res.statusCode).toBe(401);
      expect(res.body).toHaveProperty('message', 'Неверный email или пароль');
    });
  });

  describe('GET /api/auth/me', () => {
    let token;

    beforeEach(async () => {
      const user = await User.create(testUser);
      token = generateToken(user);
    });

    it('должен получить данные текущего пользователя', async () => {
      const res = await request(app)
        .get('/api/auth/me')
        .set('Authorization', `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('email', testUser.email);
      expect(res.body).toHaveProperty('name', testUser.name);
    });

    it('не должен получить данные без токена', async () => {
      const res = await request(app)
        .get('/api/auth/me');

      expect(res.statusCode).toBe(401);
      expect(res.body).toHaveProperty('message', 'Нет токена авторизации');
    });
  });

  describe('POST /api/auth/reset-password', () => {
    beforeEach(async () => {
      await User.create(testUser);
    });

    it('должен отправить запрос на сброс пароля', async () => {
      const res = await request(app)
        .post('/api/auth/reset-password')
        .send({ email: testUser.email });

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveProperty('message', 'Инструкции по сбросу пароля отправлены на email');
    });

    it('не должен отправлять запрос для несуществующего email', async () => {
      const res = await request(app)
        .post('/api/auth/reset-password')
        .send({ email: 'nonexistent@example.com' });

      expect(res.statusCode).toBe(404);
      expect(res.body).toHaveProperty('message', 'Пользователь не найден');
    });
  });
}); 