# The Pivo Admin Panel

Административная панель для управления сетью ресторанов The Pivo. Разработана с использованием React, TypeScript и Material-UI.

![Admin Panel Screenshot](screenshot.png)

## Возможности

- 📊 Аналитика и статистика
- 🍽️ Управление меню и категориями
- 📦 Управление заказами
- 🏪 Управление ресторанами
- 👥 Управление пользователями
- 📅 Управление бронированиями
- ⚙️ Настройки системы

## Технологический стек

- ⚛️ React 18
- 📘 TypeScript
- 🎨 Material-UI
- 🛣️ React Router
- 🔄 Redux Toolkit
- 📡 Axios
- 🔍 React Query
- 🧪 Jest & React Testing Library
- 📝 ESLint & Prettier

## Быстрый старт

1. **Клонирование репозитория**
```bash
git clone https://github.com/your-username/the-pivo-admin.git
cd the-pivo-admin
```

2. **Установка зависимостей**
```bash
npm install
```

3. **Настройка окружения**
```bash
cp .env.example .env
```
Отредактируйте `.env` файл, установив необходимые значения.

4. **Запуск приложения**
```bash
npm start
```

## Структура проекта

```
src/
  ├── assets/        # Статические файлы
  ├── components/    # React компоненты
  │   ├── common/    # Общие компоненты
  │   ├── layout/    # Компоненты макета
  │   └── features/  # Компоненты функционала
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

## Скрипты

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

## API Документация

Подробная документация API доступна в [API.md](API.md)

## Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Отправьте изменения в ветку (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## Лицензия

MIT
