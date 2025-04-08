# Логирование

## Winston

### Установка
```bash
npm install winston
```

### Базовая конфигурация
```javascript
const winston = require('winston');

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});
```

### Форматы
```javascript
const formats = winston.format.combine(
  winston.format.timestamp(),
  winston.format.json(),
  winston.format.prettyPrint()
);
```

## Логирование запросов

### Middleware
```javascript
app.use((req, res, next) => {
  logger.info({
    method: req.method,
    path: req.path,
    ip: req.ip,
    userAgent: req.get('user-agent')
  });
  next();
});
```

### Ответы
```javascript
app.use((req, res, next) => {
  const oldSend = res.send;
  res.send = function (data) {
    logger.info({
      statusCode: res.statusCode,
      responseTime: res.get('X-Response-Time')
    });
    oldSend.apply(res, arguments);
  };
  next();
});
```

## Ошибки

### Глобальный обработчик
```javascript
app.use((err, req, res, next) => {
  logger.error({
    error: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method
  });
  res.status(500).json({ error: 'Internal Server Error' });
});
```

### Типы ошибок
- ValidationError
- AuthenticationError
- AuthorizationError
- NotFoundError
- DatabaseError

## Ротация логов

### Daily Rotate File
```javascript
const DailyRotateFile = require('winston-daily-rotate-file');

const transport = new DailyRotateFile({
  filename: 'logs/application-%DATE%.log',
  datePattern: 'YYYY-MM-DD',
  maxSize: '20m',
  maxFiles: '14d'
});
```

### Настройки
- Максимальный размер файла
- Период хранения
- Сжатие старых логов
- Очистка

## ELK Stack

### Elasticsearch
```javascript
const { Client } = require('@elastic/elasticsearch');
const client = new Client({
  node: process.env.ELASTICSEARCH_URL
});
```

### Logstash
```conf
input {
  file {
    path => "/var/log/application.log"
    start_position => "beginning"
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

### Kibana
- Визуализация логов
- Поиск и фильтрация
- Дашборды
- Алерты

## Метрики

### Prometheus
```javascript
const promClient = require('prom-client');
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});
```

### Grafana
- Дашборды
- Алерты
- Метрики
- Визуализация

## Алерты

### Настройка
```javascript
const alertManager = {
  error: async (error) => {
    await sendSlackNotification({
      channel: '#alerts',
      text: `Error: ${error.message}`
    });
  }
};
```

### Каналы
- Slack
- Email
- Telegram
- SMS

## Аудит

### События
```javascript
const auditLogger = {
  log: async (event) => {
    await logger.info({
      type: 'audit',
      event: event.type,
      user: event.user,
      details: event.details,
      timestamp: new Date()
    });
  }
};
```

### Типы событий
- Авторизация
- Изменения данных
- Конфигурация
- Безопасность

## Best Practices

### Структура
- Уровни логирования
- Контекст
- Форматирование
- Ротация

### Производительность
- Асинхронное логирование
- Буферизация
- Сжатие
- Очистка

### Безопасность
- Чувствительные данные
- Персональные данные
- Кредитные карты
- Пароли 