const express = require('express');
const { check } = require('express-validator');
const authController = require('../controllers/authController');
const auth = require('../middleware/auth');

const router = express.Router();

/**
 * @swagger
 * /auth/register:
 *   post:
 *     tags:
 *       - Auth
 *     summary: Регистрация нового пользователя
 *     description: Создает нового пользователя в системе
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *               - name
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 description: Email пользователя
 *               password:
 *                 type: string
 *                 format: password
 *                 minLength: 6
 *                 description: Пароль пользователя
 *               name:
 *                 type: string
 *                 description: Имя пользователя
 *     responses:
 *       201:
 *         description: Пользователь успешно создан
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       400:
 *         description: Неверные данные
 *       409:
 *         description: Email уже используется
 */
router.post(
  '/register',
  [
    check('email', 'Пожалуйста, введите корректный email').isEmail(),
    check('password', 'Пароль должен быть не менее 6 символов').isLength({ min: 6 }),
    check('firstName', 'Имя обязательно').not().isEmpty(),
    check('lastName', 'Фамилия обязательна').not().isEmpty(),
    check('phone', 'Телефон обязателен').not().isEmpty()
  ],
  authController.register
);

/**
 * @swagger
 * /auth/login:
 *   post:
 *     tags:
 *       - Auth
 *     summary: Вход в систему
 *     description: Аутентификация пользователя и получение токена
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *               password:
 *                 type: string
 *                 format: password
 *     responses:
 *       200:
 *         description: Успешный вход
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                 user:
 *                   $ref: '#/components/schemas/User'
 *       401:
 *         description: Неверные учетные данные
 */
router.post(
  '/login',
  [
    check('email', 'Пожалуйста, введите корректный email').isEmail(),
    check('password', 'Пароль обязателен').exists()
  ],
  authController.login
);

// @route   POST /api/auth/logout
// @desc    Logout user
// @access  Private
router.post('/logout', auth, authController.logout);

/**
 * @swagger
 * /auth/me:
 *   get:
 *     tags:
 *       - Auth
 *     summary: Получение информации о текущем пользователе
 *     description: Возвращает информацию о авторизованном пользователе
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Информация о пользователе
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       401:
 *         description: Не авторизован
 */
router.get('/me', auth, authController.getCurrentUser);

// @route   PUT /api/auth/profile
// @desc    Update user profile
// @access  Private
router.put(
  '/profile',
  [
    auth,
    [
      check('firstName', 'Имя обязательно').optional().not().isEmpty(),
      check('lastName', 'Фамилия обязательна').optional().not().isEmpty(),
      check('phone', 'Телефон обязателен').optional().not().isEmpty(),
      check('address', 'Адрес должен быть строкой').optional().isString(),
      check('birthDate', 'Дата рождения должна быть валидной датой').optional().isISO8601(),
      check('preferences', 'Предпочтения должны быть объектом').optional().isObject()
    ]
  ],
  authController.updateProfile
);

// @route   PUT /api/auth/change-password
// @desc    Change password for authenticated user
// @access  Private
router.put(
  '/change-password',
  [
    auth,
    [
      check('currentPassword', 'Текущий пароль обязателен').exists(),
      check('newPassword', 'Новый пароль должен быть не менее 6 символов').isLength({ min: 6 })
    ]
  ],
  authController.changePassword
);

/**
 * @swagger
 * /auth/reset-password-request:
 *   post:
 *     tags:
 *       - Auth
 *     summary: Запрос на сброс пароля
 *     description: Отправляет email со ссылкой для сброса пароля
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *     responses:
 *       200:
 *         description: Email отправлен
 *       404:
 *         description: Пользователь не найден
 */
router.post(
  '/reset-password-request',
  [
    check('email', 'Пожалуйста, введите корректный email').isEmail()
  ],
  authController.resetPasswordRequest
);

// @route   POST /api/auth/reset-password
// @desc    Reset password
// @access  Public
router.post(
  '/reset-password',
  [
    check('token', 'Токен обязателен').not().isEmpty(),
    check('newPassword', 'Новый пароль должен быть не менее 6 символов').isLength({ min: 6 })
  ],
  authController.resetPassword
);

// @route   DELETE /api/auth/delete-account
// @desc    Delete user account
// @access  Private
router.delete('/delete-account', auth, authController.deleteAccount);

module.exports = router; 