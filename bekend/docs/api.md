# API Документация

## Общая информация

Базовый URL: `http://localhost:3000/api`

## Аутентификация

### Регистрация
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

### Вход
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

### Получение информации о пользователе
```http
GET /auth/me
Authorization: Bearer {token}
```

### Сброс пароля
```http
POST /auth/reset-password-request
Content-Type: application/json

{
  "email": "user@example.com"
}
```

## Продукты

### Получение списка продуктов
```http
GET /products
```

### Получение продукта по ID
```http
GET /products/:id
```

### Создание продукта (Admin)
```http
POST /products
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Product Name",
  "description": "Product Description",
  "price": 99.99,
  "category": "category_id"
}
```

### Обновление продукта (Admin)
```http
PUT /products/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "Updated Name",
  "price": 89.99
}
```

### Удаление продукта (Admin)
```http
DELETE /products/:id
Authorization: Bearer {token}
```

## Заказы

### Создание заказа
```http
POST /orders
Authorization: Bearer {token}
Content-Type: application/json

{
  "items": [
    {
      "productId": "product_id",
      "quantity": 2
    }
  ],
  "deliveryAddress": {
    "street": "123 Main St",
    "city": "City",
    "zipCode": "12345"
  }
}
```

### Получение списка заказов
```http
GET /orders
Authorization: Bearer {token}
```

### Получение заказа по ID
```http
GET /orders/:id
Authorization: Bearer {token}
```

### Обновление статуса заказа (Admin)
```http
PUT /orders/:id/status
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "delivered"
}
```

## Коды ответов

- 200: Успешный запрос
- 201: Ресурс создан
- 400: Неверный запрос
- 401: Не авторизован
- 403: Доступ запрещен
- 404: Ресурс не найден
- 500: Внутренняя ошибка сервера

## Обработка ошибок

Все ошибки возвращаются в формате:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Описание ошибки"
  }
}
``` 