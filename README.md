# The Pivo - Административная панель

Административная панель для управления рестораном The Pivo. Разработана с использованием React, TypeScript и Material-UI.

## Функциональность

- Управление меню и категориями
- Управление заказами
- Управление ресторанами
- Управление пользователями
- Аналитика и отчеты
- Управление бронированиями
- Настройки системы

## Технологии

- React 18
- TypeScript
- Material-UI
- React Router
- Redux Toolkit
- Axios
- React Query
- Jest & React Testing Library
- ESLint & Prettier

## Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/your-username/the-pivo-admin.git
cd the-pivo-admin
```

2. Установите зависимости:
```bash
npm install
```

3. Создайте файл .env на основе .env.example:
```bash
cp .env.example .env
```

4. Запустите проект:
```bash
npm start
```

## Структура проекта

```
src/
  ├── assets/        # Статические файлы
  ├── components/    # React компоненты
  ├── config/        # Конфигурация
  ├── context/       # React контексты
  ├── hooks/         # Пользовательские хуки
  ├── layouts/       # Компоненты макетов
  ├── locales/       # Локализация
  ├── pages/         # Страницы приложения
  ├── services/      # API сервисы
  ├── store/         # Redux store
  ├── types/         # TypeScript типы
  └── utils/         # Утилиты
```

## Разработка

- `npm start` - Запуск в режиме разработки
- `npm test` - Запуск тестов
- `npm run build` - Сборка для продакшена
- `npm run lint` - Проверка кода
- `npm run format` - Форматирование кода

## Компоненты

### Общие компоненты

- `PageHeader` - Заголовок страницы с хлебными крошками
- `DataTable` - Таблица данных с сортировкой и пагинацией
- `LoadingSpinner` - Индикатор загрузки
- `ErrorBoundary` - Обработка ошибок
- `Notifications` - Система уведомлений
- `UserMenu` - Меню пользователя
- `ConfirmDialog` - Диалог подтверждения
- `StatusBadge` - Индикатор статуса
- `EmptyState` - Пустое состояние
- `SearchInput` - Поле поиска
- `FilterBar` - Панель фильтров

## Лицензия

MIT
