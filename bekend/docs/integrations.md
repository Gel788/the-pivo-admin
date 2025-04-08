# Интеграции

## Stripe

### Установка
```bash
npm install stripe
```

### Конфигурация
```javascript
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
```

### Операции
- Создание платежа
- Возврат средств
- Подписки
- Webhooks

## Redis

### Установка
```bash
npm install redis
```

### Конфигурация
```javascript
const Redis = require('ioredis');
const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT,
  password: process.env.REDIS_PASSWORD
});
```

### Использование
- Кэширование
- Очереди
- Pub/Sub
- Rate limiting

## Email Service

### Установка
```bash
npm install nodemailer
```

### Конфигурация
```javascript
const nodemailer = require('nodemailer');
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});
```

### Шаблоны
- Регистрация
- Сброс пароля
- Уведомления
- Маркетинг

## Push Notifications

### Установка
```bash
npm install firebase-admin
```

### Конфигурация
```javascript
const admin = require('firebase-admin');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
```

### Типы уведомлений
- Заказы
- Акции
- Системные
- Маркетинг

## SMS Gateway

### Установка
```bash
npm install twilio
```

### Конфигурация
```javascript
const twilio = require('twilio');
const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);
```

### Использование
- Подтверждение
- Уведомления
- Маркетинг
- 2FA

## Social Media

### Facebook
- Авторизация
- Шеринг
- Реклама
- Аналитика

### Google
- Авторизация
- Maps
- Analytics
- Search Console

## Payment Gateways

### PayPal
- Прямые платежи
- Подписки
- Возвраты
- Webhooks

### Apple Pay
- Интеграция
- Платежи
- Подписки
- Возвраты

## Storage

### AWS S3
- Файлы
- Изображения
- Бэкапы
- CDN

### Google Cloud Storage
- Файлы
- Медиа
- Бэкапы
- CDN

## Analytics

### Google Analytics
- Отслеживание
- Отчеты
- Цели
- Конверсии

### Mixpanel
- События
- Воронки
- Когорты
- A/B тесты

## Maps

### Google Maps
- Геокодирование
- Маршруты
- Places API
- Distance Matrix

### Yandex Maps
- Геокодирование
- Маршруты
- Places API
- Distance Matrix 