const cluster = require('cluster');
const os = require('os');
const app = require('./app');
const { logger } = require('./utils/logger');

if (cluster.isMaster) {
  const numCPUs = os.cpus().length;
  logger.info(`Master process ${process.pid} is running`);

  // Запускаем воркеры
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('exit', (worker, code, signal) => {
    logger.warn(`Worker ${worker.process.pid} died. Restarting...`, {
      code,
      signal
    });
    cluster.fork();
  });

  // Обработка сигналов завершения
  process.on('SIGTERM', () => {
    logger.info('SIGTERM received. Shutting down gracefully...');
    
    // Отправляем сигнал всем воркерам
    for (const id in cluster.workers) {
      cluster.workers[id].send('shutdown');
    }
  });

  process.on('SIGINT', () => {
    logger.info('SIGINT received. Shutting down gracefully...');
    
    // Отправляем сигнал всем воркерам
    for (const id in cluster.workers) {
      cluster.workers[id].send('shutdown');
    }
  });
} else {
  // Код для воркеров
  const server = app.listen(process.env.PORT || 3000, () => {
    logger.info(`Worker ${process.pid} started and listening on port ${process.env.PORT || 3000}`);
  });

  // Обработка сигналов завершения
  process.on('message', (msg) => {
    if (msg === 'shutdown') {
      logger.info(`Worker ${process.pid} shutting down...`);
      
      // Закрываем сервер
      server.close(() => {
        logger.info(`Worker ${process.pid} closed`);
        process.exit(0);
      });

      // Принудительное завершение через 10 секунд
      setTimeout(() => {
        logger.error(`Worker ${process.pid} forced shutdown`);
        process.exit(1);
      }, 10000);
    }
  });

  // Обработка необработанных исключений
  process.on('uncaughtException', (err) => {
    logger.error(`Worker ${process.pid} uncaught exception:`, err);
    process.exit(1);
  });

  // Обработка необработанных отклонений промисов
  process.on('unhandledRejection', (reason, promise) => {
    logger.error(`Worker ${process.pid} unhandled rejection:`, reason);
    process.exit(1);
  });
} 