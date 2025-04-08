# Тестирование

## Unit тесты

### Запуск
```bash
npm run test:unit
```

### Структура
```
tests/
├── unit/
│   ├── controllers/
│   ├── models/
│   ├── services/
│   └── utils/
```

### Пример теста
```javascript
describe('User Service', () => {
  it('should create a new user', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'password123'
    };
    const user = await userService.create(userData);
    expect(user.email).toBe(userData.email);
  });
});
```

## Интеграционные тесты

### Запуск
```bash
npm run test:integration
```

### Настройка
- Тестовая база данных
- Моки внешних сервисов
- Очистка данных между тестами

### Пример теста
```javascript
describe('Auth API', () => {
  it('should login user', async () => {
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'password123'
      });
    expect(response.status).toBe(200);
    expect(response.body.token).toBeDefined();
  });
});
```

## E2E тесты

### Запуск
```bash
npm run test:e2e
```

### Настройка
- Тестовое окружение
- Моки всех внешних сервисов
- Изолированная база данных

### Пример теста
```javascript
describe('Order Flow', () => {
  it('should complete order process', async () => {
    // Логин
    const loginResponse = await login();
    
    // Создание заказа
    const orderResponse = await createOrder();
    
    // Проверка статуса
    const statusResponse = await checkOrderStatus();
    
    expect(statusResponse.status).toBe('delivered');
  });
});
```

## Тестовое покрытие

### Запуск
```bash
npm run test:coverage
```

### Отчет
- HTML отчет
- Консольный вывод
- CI интеграция

## Моки и стабы

### Моки
```javascript
jest.mock('../../services/email', () => ({
  sendEmail: jest.fn()
}));
```

### Стабы
```javascript
const userStub = {
  findById: jest.fn().mockResolvedValue({
    id: 1,
    name: 'Test User'
  })
};
```

## CI интеграция

### GitHub Actions
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
      - name: Upload coverage
        uses: codecov/codecov-action@v1
```

## Best Practices

### Организация
- Группировка по функционалу
- Изолированные тесты
- Чистые тестовые данные

### Наименование
- Описательные названия
- Структура Given/When/Then
- Уникальные идентификаторы

### Поддержка
- Регулярное обновление
- Документация изменений
- Рефакторинг при необходимости 