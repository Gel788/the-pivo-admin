# The Pivo Admin Panel

Административная панель для управления рестораном The Pivo.

## Установка

```bash
# Клонирование репозитория
git clone https://github.com/your-username/the-pivo-admin.git

# Переход в директорию проекта
cd the-pivo-admin

# Установка зависимостей
npm install
```

## Разработка

```bash
# Запуск в режиме разработки
npm run dev

# Сборка проекта
npm run build

# Запуск линтера
npm run lint
```

## Деплой

Проект настроен для автоматического деплоя на Vercel при пуше в ветку main.

### Ручной деплой

1. Установите Vercel CLI:
```bash
npm install -g vercel
```

2. Войдите в свой аккаунт:
```bash
vercel login
```

3. Деплой:
```bash
vercel
```

## Переменные окружения

Создайте файл `.env` в корне проекта:

```env
VITE_API_URL=your_api_url
```

## Структура проекта

```
src/
  ├── components/     # React компоненты
  ├── pages/         # Страницы приложения
  ├── services/      # API сервисы
  ├── store/         # Redux store
  ├── theme/         # Настройки темы
  ├── utils/         # Вспомогательные функции
  └── App.tsx        # Корневой компонент
```

## Технологии

- React
- TypeScript
- Vite
- Material-UI
- Redux Toolkit
- React Query
- React Router
- i18next 