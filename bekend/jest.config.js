module.exports = {
  // Корневая директория для поиска файлов
  roots: ['<rootDir>/src'],

  // Расширения файлов для тестирования
  moduleFileExtensions: ['js', 'json'],

  // Паттерны для поиска тестовых файлов
  testMatch: [
    '**/__tests__/**/*.js',
    '**/?(*.)+(spec|test).js',
  ],

  // Игнорируемые директории
  testPathIgnorePatterns: [
    '/node_modules/',
    '/dist/',
  ],

  // Сбор покрытия кода
  collectCoverage: true,
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/config/**',
    '!src/**/*.test.js',
    '!src/**/__tests__/**',
  ],

  // Порог покрытия кода
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },

  // Настройки для тестового окружения
  testEnvironment: 'node',

  // Глобальные переменные для тестов
  globals: {
    NODE_ENV: 'test',
  },

  // Настройки для асинхронных тестов
  testTimeout: 10000,

  // Настройки для отображения результатов
  verbose: true,
  silent: false,

  // Настройки для модулей
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },

  // Настройки для трансформации
  transform: {
    '^.+\\.js$': 'babel-jest',
  },

  // Настройки для setup файлов
  setupFiles: [
    '<rootDir>/src/tests/setup.js',
  ],

  // Настройки для очистки кэша
  clearMocks: true,
  resetMocks: true,
  restoreMocks: true,

  // Настройки для параллельного выполнения
  maxWorkers: '50%',

  // Настройки для отчета о тестах
  reporters: [
    'default',
    [
      'jest-junit',
      {
        outputDirectory: 'reports/junit',
        outputName: 'js-test-results.xml',
        classNameTemplate: '{classname}',
        titleTemplate: '{title}',
        ancestorSeparator: ' › ',
        usePathForSuiteName: true,
      },
    ],
  ],
}; 