const helmet = require('helmet');
const csrf = require('csurf');
const xss = require('xss-clean');
const hpp = require('hpp');
const mongoSanitize = require('express-mongo-sanitize');

const securityMiddleware = (app) => {
  // Базовые заголовки безопасности
  app.use(helmet());

  // Защита от XSS атак
  app.use(xss());

  // Защита от NoSQL инъекций
  app.use(mongoSanitize());

  // Защита от HTTP Parameter Pollution
  app.use(hpp());

  // CSRF защита
  app.use(csrf({ cookie: true }));

  // Добавляем CSRF токен в ответ
  app.use((req, res, next) => {
    res.cookie('XSRF-TOKEN', req.csrfToken());
    next();
  });

  // Проверка блокировки аккаунта
  app.use(async (req, res, next) => {
    if (req.user && req.user.isBlocked) {
      return res.status(403).json({
        error: 'Аккаунт заблокирован. Пожалуйста, свяжитесь с администратором'
      });
    }
    next();
  });

  // Проверка попыток входа
  app.use(async (req, res, next) => {
    if (req.user && req.user.failedLoginAttempts >= 5) {
      const lastAttempt = new Date(req.user.lastLoginAttempt);
      const hoursSinceLastAttempt = (new Date() - lastAttempt) / (1000 * 60 * 60);
      
      if (hoursSinceLastAttempt < 24) {
        return res.status(403).json({
          error: 'Аккаунт временно заблокирован из-за множества неудачных попыток входа'
        });
      } else {
        // Сброс счетчика после 24 часов
        req.user.failedLoginAttempts = 0;
        await req.user.save();
      }
    }
    next();
  });
};

module.exports = securityMiddleware; 