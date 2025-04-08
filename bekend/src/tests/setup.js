// Импорт необходимых модулей
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

// Создание экземпляра MongoDB Memory Server
let mongod;

// Настройка перед запуском всех тестов
beforeAll(async () => {
  // Создание экземпляра MongoDB Memory Server
  mongod = await MongoMemoryServer.create();
  const uri = mongod.getUri();

  // Подключение к тестовой базе данных
  await mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
});

// Очистка после каждого теста
afterEach(async () => {
  // Очистка всех коллекций
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    const collection = collections[key];
    await collection.deleteMany();
  }
});

// Очистка после всех тестов
afterAll(async () => {
  // Отключение от базы данных
  await mongoose.connection.close();
  // Остановка MongoDB Memory Server
  await mongod.stop();
});

// Глобальные моки
jest.mock('../config/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn(),
  debug: jest.fn(),
}));

// Глобальные переменные для тестов
global.testTimeout = 10000; 