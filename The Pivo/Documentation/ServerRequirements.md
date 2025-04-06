# Требования к серверной части приложения The Pivo

## 1. Общие требования

### 1.1 Технический стек
- Backend: Node.js + Express.js
- База данных: PostgreSQL
- ORM: Prisma
- Аутентификация: JWT + OAuth2
- WebSocket: Socket.IO
- Кэширование: Redis
- Хранение файлов: AWS S3
- CI/CD: GitHub Actions

### 1.2 Системные требования
- Минимум 4 ядра CPU
- 8GB RAM
- 100GB SSD
- Ubuntu 22.04 LTS

## 2. API Endpoints

### 2.1 Аутентификация
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/refresh-token
POST /api/auth/logout
```

### 2.2 Рестораны
```
GET /api/restaurants
GET /api/restaurants/:id
POST /api/restaurants
PUT /api/restaurants/:id
DELETE /api/restaurants/:id
GET /api/restaurants/search
GET /api/restaurants/filter
```

### 2.3 Меню
```
GET /api/menu
GET /api/menu/:id
POST /api/menu
PUT /api/menu/:id
DELETE /api/menu/:id
GET /api/menu/categories
```

### 2.4 Бронирования
```
GET /api/reservations
GET /api/reservations/:id
POST /api/reservations
PUT /api/reservations/:id
DELETE /api/reservations/:id
PUT /api/reservations/:id/status
GET /api/reservations/user/:userId
```

### 2.5 Новости
```
GET /api/news
GET /api/news/:id
POST /api/news
PUT /api/news/:id
DELETE /api/news/:id
```

## 3. База данных

### 3.1 Основные таблицы
```sql
-- Рестораны
CREATE TABLE restaurants (
    id UUID PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    hours VARCHAR(255),
    image_url VARCHAR(255),
    type VARCHAR(100),
    features TEXT[],
    latitude DECIMAL,
    longitude DECIMAL,
    reservation_cost_per_person DECIMAL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Меню
CREATE TABLE menu_items (
    id UUID PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id),
    name VARCHAR(255),
    description TEXT,
    price DECIMAL,
    image_url VARCHAR(255),
    category VARCHAR(50),
    abv DECIMAL,
    ibu INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Бронирования
CREATE TABLE reservations (
    id UUID PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id),
    user_id UUID REFERENCES users(id),
    date DATE,
    time TIME,
    number_of_guests INTEGER,
    status VARCHAR(50),
    special_requests TEXT,
    total_amount DECIMAL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

-- Позиции меню в бронировании
CREATE TABLE reservation_menu_items (
    id UUID PRIMARY KEY,
    reservation_id UUID REFERENCES reservations(id),
    menu_item_id UUID REFERENCES menu_items(id),
    quantity INTEGER,
    price DECIMAL
);

-- Новости
CREATE TABLE news (
    id UUID PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

## 4. WebSocket события

### 4.1 Бронирования
```javascript
// Отправка
socket.emit('reservation:create', data);
socket.emit('reservation:update', data);
socket.emit('reservation:delete', id);

// Получение
socket.on('reservation:created', data);
socket.on('reservation:updated', data);
socket.on('reservation:deleted', id);
```

### 4.2 Меню
```javascript
// Отправка
socket.emit('menu:update', data);
socket.emit('menu:delete', id);

// Получение
socket.on('menu:updated', data);
socket.on('menu:deleted', id);
```

## 5. Админ-панель

### 5.1 Функциональность
- Управление ресторанами
- Управление меню
- Управление бронированиями
- Управление новостями
- Управление пользователями
- Статистика и аналитика
- Настройки системы

### 5.2 Роли пользователей
- Super Admin
- Restaurant Manager
- Content Manager
- Support Staff

## 6. Безопасность

### 6.1 Аутентификация
- JWT токены с refresh механизмом
- OAuth2 для социальных сетей
- Двухфакторная аутентификация
- Блокировка после неудачных попыток

### 6.2 Авторизация
- RBAC (Role-Based Access Control)
- Проверка прав доступа на уровне API
- Валидация входных данных

### 6.3 Защита данных
- HTTPS
- Шифрование чувствительных данных
- Защита от SQL-инъекций
- XSS защита
- CSRF защита

## 7. Мониторинг и логирование

### 7.1 Мониторинг
- Prometheus + Grafana
- Отслеживание метрик:
  - CPU/RAM использование
  - Время ответа API
  - Количество запросов
  - Ошибки

### 7.2 Логирование
- Winston для логирования
- ELK Stack для анализа логов
- Sentry для отслеживания ошибок

## 8. Кэширование

### 8.1 Redis кэш
- Кэширование меню
- Кэширование ресторанов
- Кэширование новостей
- Сессии пользователей

## 9. CI/CD

### 9.1 GitHub Actions
- Автоматические тесты
- Линтинг кода
- Сборка Docker образов
- Автоматический деплой

## 10. Масштабирование

### 10.1 Горизонтальное масштабирование
- Load Balancer (Nginx)
- Репликация базы данных
- Кластеризация Redis
- Docker Swarm/Kubernetes

## 11. Резервное копирование

### 11.1 База данных
- Ежедневное полное резервное копирование
- Почасовое инкрементное резервное копирование
- Географически распределенное хранение

### 11.2 Файлы
- Репликация файлов в S3
- Версионирование файлов
- Географическое распределение

## 12. Тестирование

### 12.1 Автоматические тесты
- Unit тесты (Jest)
- Интеграционные тесты
- E2E тесты (Cypress)
- Нагрузочное тестирование (k6)

### 12.2 Ручное тестирование
- Тестирование на разных устройствах
- Тестирование различных сценариев
- Тестирование безопасности
- Тестирование производительности 