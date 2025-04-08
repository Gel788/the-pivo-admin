const Joi = require('joi');

const envVarsSchema = Joi.object({
  NODE_ENV: Joi.string()
    .valid('development', 'production', 'test')
    .required(),
  PORT: Joi.number().default(3000),
  API_VERSION: Joi.string().required(),
  API_PREFIX: Joi.string().required(),

  // MongoDB
  MONGODB_URI: Joi.string().required(),
  MONGODB_USER: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),
  MONGODB_PASS: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),
  MONGODB_REPLICA_SET: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),

  // JWT
  JWT_SECRET: Joi.string().required(),
  JWT_EXPIRES_IN: Joi.string().required(),
  JWT_REFRESH_SECRET: Joi.string().required(),
  JWT_REFRESH_EXPIRES_IN: Joi.string().required(),

  // Email
  EMAIL_HOST: Joi.string().required(),
  EMAIL_PORT: Joi.number().required(),
  EMAIL_SECURE: Joi.boolean().required(),
  EMAIL_USER: Joi.string().required(),
  EMAIL_PASS: Joi.string().required(),
  EMAIL_FROM: Joi.string().required(),

  // Stripe
  STRIPE_SECRET_KEY: Joi.string().required(),
  STRIPE_WEBHOOK_SECRET: Joi.string().required(),
  STRIPE_CURRENCY: Joi.string().required(),

  // Redis
  REDIS_HOST: Joi.string().required(),
  REDIS_PORT: Joi.number().required(),
  REDIS_PASSWORD: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),
  REDIS_TTL: Joi.number().default(3600),

  // Logging
  LOG_LEVEL: Joi.string().valid('error', 'warn', 'info', 'http', 'verbose', 'debug', 'silly').default('info'),
  LOG_FILE: Joi.string().required(),
  LOG_FORMAT: Joi.string().default('combined'),
  LOG_MAX_SIZE: Joi.string().default('10m'),
  LOG_MAX_FILES: Joi.number().default(5),

  // CORS
  CORS_ORIGIN: Joi.string().required(),
  CORS_METHODS: Joi.string().required(),
  CORS_ALLOWED_HEADERS: Joi.string().required(),
  CORS_EXPOSED_HEADERS: Joi.string().required(),
  CORS_CREDENTIALS: Joi.boolean().default(true),

  // Rate Limiting
  RATE_LIMIT_WINDOW_MS: Joi.number().default(900000),
  RATE_LIMIT_MAX_REQUESTS: Joi.number().default(100),

  // Security
  BCRYPT_SALT_ROUNDS: Joi.number().default(10),
  PASSWORD_MIN_LENGTH: Joi.number().default(8),
  SESSION_SECRET: Joi.string().required(),
  COOKIE_SECRET: Joi.string().required(),

  // Push Notifications
  FIREBASE_PROJECT_ID: Joi.string().required(),
  FIREBASE_PRIVATE_KEY: Joi.string().required(),
  FIREBASE_CLIENT_EMAIL: Joi.string().required(),
  APN_KEY_ID: Joi.string().required(),
  APN_TEAM_ID: Joi.string().required(),
  APN_BUNDLE_ID: Joi.string().required(),
  VAPID_PUBLIC_KEY: Joi.string().required(),
  VAPID_PRIVATE_KEY: Joi.string().required(),
  VAPID_SUBJECT: Joi.string().required(),

  // File Upload
  UPLOAD_MAX_SIZE: Joi.number().default(5242880),
  UPLOAD_ALLOWED_TYPES: Joi.string().required(),
  UPLOAD_PATH: Joi.string().default('uploads'),

  // Cache
  CACHE_TTL: Joi.number().default(3600),
  CACHE_CHECK_PERIOD: Joi.number().default(600),

  // Monitoring
  SENTRY_DSN: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),
  NEW_RELIC_LICENSE_KEY: Joi.string().when('NODE_ENV', {
    is: 'production',
    then: Joi.required(),
  }),

  // External Services
  GOOGLE_MAPS_API_KEY: Joi.string().required(),
  SMS_PROVIDER_API_KEY: Joi.string().required(),
}).unknown();

const { error, value: envVars } = envVarsSchema.prefs({ errors: { label: 'key' } }).validate(process.env);

if (error) {
  throw new Error(`Config validation error: ${error.message}`);
}

module.exports = {
  env: envVars.NODE_ENV,
  port: envVars.PORT,
  api: {
    version: envVars.API_VERSION,
    prefix: envVars.API_PREFIX,
  },
  mongodb: {
    uri: envVars.MONGODB_URI,
    user: envVars.MONGODB_USER,
    pass: envVars.MONGODB_PASS,
    replicaSet: envVars.MONGODB_REPLICA_SET,
  },
  jwt: {
    secret: envVars.JWT_SECRET,
    expiresIn: envVars.JWT_EXPIRES_IN,
    refreshSecret: envVars.JWT_REFRESH_SECRET,
    refreshExpiresIn: envVars.JWT_REFRESH_EXPIRES_IN,
  },
  email: {
    host: envVars.EMAIL_HOST,
    port: envVars.EMAIL_PORT,
    secure: envVars.EMAIL_SECURE,
    user: envVars.EMAIL_USER,
    pass: envVars.EMAIL_PASS,
    from: envVars.EMAIL_FROM,
  },
  stripe: {
    secretKey: envVars.STRIPE_SECRET_KEY,
    webhookSecret: envVars.STRIPE_WEBHOOK_SECRET,
    currency: envVars.STRIPE_CURRENCY,
  },
  redis: {
    host: envVars.REDIS_HOST,
    port: envVars.REDIS_PORT,
    password: envVars.REDIS_PASSWORD,
    ttl: envVars.REDIS_TTL,
  },
  logging: {
    level: envVars.LOG_LEVEL,
    file: envVars.LOG_FILE,
    format: envVars.LOG_FORMAT,
    maxSize: envVars.LOG_MAX_SIZE,
    maxFiles: envVars.LOG_MAX_FILES,
  },
  cors: {
    origin: envVars.CORS_ORIGIN,
    methods: envVars.CORS_METHODS.split(','),
    allowedHeaders: envVars.CORS_ALLOWED_HEADERS.split(','),
    exposedHeaders: envVars.CORS_EXPOSED_HEADERS.split(','),
    credentials: envVars.CORS_CREDENTIALS,
  },
  rateLimit: {
    windowMs: envVars.RATE_LIMIT_WINDOW_MS,
    max: envVars.RATE_LIMIT_MAX_REQUESTS,
  },
  security: {
    bcryptSaltRounds: envVars.BCRYPT_SALT_ROUNDS,
    passwordMinLength: envVars.PASSWORD_MIN_LENGTH,
    sessionSecret: envVars.SESSION_SECRET,
    cookieSecret: envVars.COOKIE_SECRET,
  },
  push: {
    firebase: {
      projectId: envVars.FIREBASE_PROJECT_ID,
      privateKey: envVars.FIREBASE_PRIVATE_KEY,
      clientEmail: envVars.FIREBASE_CLIENT_EMAIL,
    },
    apn: {
      keyId: envVars.APN_KEY_ID,
      teamId: envVars.APN_TEAM_ID,
      bundleId: envVars.APN_BUNDLE_ID,
    },
    webPush: {
      publicKey: envVars.VAPID_PUBLIC_KEY,
      privateKey: envVars.VAPID_PRIVATE_KEY,
      subject: envVars.VAPID_SUBJECT,
    },
  },
  upload: {
    maxSize: envVars.UPLOAD_MAX_SIZE,
    allowedTypes: envVars.UPLOAD_ALLOWED_TYPES.split(','),
    path: envVars.UPLOAD_PATH,
  },
  cache: {
    ttl: envVars.CACHE_TTL,
    checkPeriod: envVars.CACHE_CHECK_PERIOD,
  },
  monitoring: {
    sentryDsn: envVars.SENTRY_DSN,
    newRelicLicenseKey: envVars.NEW_RELIC_LICENSE_KEY,
  },
  external: {
    googleMapsApiKey: envVars.GOOGLE_MAPS_API_KEY,
    smsProviderApiKey: envVars.SMS_PROVIDER_API_KEY,
  },
}; 