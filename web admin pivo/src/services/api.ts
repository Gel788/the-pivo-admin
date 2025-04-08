import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10 секунд таймаут
});

// Добавляем токен к каждому запросу
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Обрабатываем ответы
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response) {
      // Сервер вернул ошибку
      switch (error.response.status) {
        case 401:
          // Не авторизован
          localStorage.removeItem('token');
          window.location.href = '/login';
          break;
        case 403:
          // Нет доступа
          window.location.href = '/unauthorized';
          break;
        case 404:
          // Не найдено
          console.error('Resource not found:', error.config.url);
          break;
        case 500:
          // Ошибка сервера
          console.error('Server error:', error.response.data);
          break;
        default:
          console.error('API Error:', error.response.data);
      }
    } else if (error.request) {
      // Запрос был сделан, но ответ не получен
      console.error('Network error:', error.request);
    } else {
      // Что-то пошло не так при настройке запроса
      console.error('Request error:', error.message);
    }
    return Promise.reject(error);
  }
);

export default api; 