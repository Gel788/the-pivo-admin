const express = require('express');
const { check } = require('express-validator');
const orderController = require('../controllers/orderController');
const auth = require('../middleware/auth');
const admin = require('../middleware/admin');

const router = express.Router();

/**
 * @swagger
 * /orders:
 *   post:
 *     tags:
 *       - Orders
 *     summary: Создание нового заказа
 *     description: Создает новый заказ для текущего пользователя
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - items
 *               - deliveryAddress
 *             properties:
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   required:
 *                     - productId
 *                     - quantity
 *                   properties:
 *                     productId:
 *                       type: string
 *                       description: ID продукта
 *                     quantity:
 *                       type: integer
 *                       minimum: 1
 *                       description: Количество
 *               deliveryAddress:
 *                 type: object
 *                 required:
 *                   - street
 *                   - city
 *                   - zipCode
 *                 properties:
 *                   street:
 *                     type: string
 *                   city:
 *                     type: string
 *                   zipCode:
 *                     type: string
 *     responses:
 *       201:
 *         description: Заказ создан
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Order'
 *       400:
 *         description: Неверные данные
 *       401:
 *         description: Не авторизован
 */
router.post(
  '/',
  [
    auth,
    [
      check('items', 'Товары обязательны').isArray({ min: 1 }),
      check('items.*.product', 'ID продукта обязателен').not().isEmpty(),
      check('items.*.quantity', 'Количество должно быть больше 0').isInt({ min: 1 }),
      check('deliveryType', 'Тип доставки обязателен').isIn(['pickup', 'delivery']),
      check('paymentMethod', 'Способ оплаты обязателен').isIn(['card', 'cash', 'online']),
      check('deliveryAddress', 'Адрес доставки обязателен для доставки').custom((value, { req }) => {
        if (req.body.deliveryType === 'delivery' && !value) {
          throw new Error('Адрес доставки обязателен для доставки');
        }
        return true;
      }),
      check('comment', 'Комментарий должен быть строкой').optional().isString(),
      check('desiredDeliveryTime', 'Желаемое время доставки должно быть валидной датой').optional().isISO8601()
    ]
  ],
  orderController.createOrder
);

/**
 * @swagger
 * /orders:
 *   get:
 *     tags:
 *       - Orders
 *     summary: Получение списка заказов
 *     description: Возвращает список заказов текущего пользователя
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: Номер страницы
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: Количество элементов на странице
 *     responses:
 *       200:
 *         description: Список заказов
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 orders:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Order'
 *                 total:
 *                   type: integer
 *                 page:
 *                   type: integer
 *                 pages:
 *                   type: integer
 *       401:
 *         description: Не авторизован
 */
router.get('/', auth, orderController.getUserOrders);

// @route   GET /api/orders/stats
// @desc    Get orders statistics
// @access  Private/Admin
router.get('/stats', [auth, admin], orderController.getOrderStats);

/**
 * @swagger
 * /orders/{id}:
 *   get:
 *     tags:
 *       - Orders
 *     summary: Получение заказа по ID
 *     description: Возвращает информацию о конкретном заказе
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID заказа
 *     responses:
 *       200:
 *         description: Информация о заказе
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Order'
 *       401:
 *         description: Не авторизован
 *       403:
 *         description: Нет прав доступа
 *       404:
 *         description: Заказ не найден
 */
router.get('/:id', auth, orderController.getOrder);

// @route   POST /api/orders/:id/repeat
// @desc    Repeat previous order
// @access  Private
router.post('/:id/repeat', auth, orderController.repeatOrder);

/**
 * @swagger
 * /orders/{id}/status:
 *   put:
 *     tags:
 *       - Orders
 *     summary: Обновление статуса заказа
 *     description: Обновляет статус заказа (только для администраторов)
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID заказа
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - status
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [pending, processing, delivered, cancelled]
 *                 description: Новый статус заказа
 *     responses:
 *       200:
 *         description: Статус заказа обновлен
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Order'
 *       400:
 *         description: Неверные данные
 *       401:
 *         description: Не авторизован
 *       403:
 *         description: Нет прав доступа
 *       404:
 *         description: Заказ не найден
 */
router.put(
  '/:id/status',
  [
    auth,
    admin,
    [
      check('status', 'Статус обязателен').isIn([
        'pending',
        'confirmed',
        'preparing',
        'ready',
        'in_delivery',
        'delivered',
        'cancelled'
      ]),
      check('comment', 'Комментарий к статусу должен быть строкой').optional().isString()
    ]
  ],
  orderController.updateOrderStatus
);

// @route   POST /api/orders/:id/cancel
// @desc    Cancel order
// @access  Private
router.post(
  '/:id/cancel',
  [
    auth,
    [
      check('reason', 'Причина отмены обязательна').not().isEmpty()
    ]
  ],
  orderController.cancelOrder
);

// @route   POST /api/orders/:id/rating
// @desc    Add order rating
// @access  Private
router.post(
  '/:id/rating',
  [
    auth,
    [
      check('rating', 'Оценка должна быть от 1 до 5').isInt({ min: 1, max: 5 }),
      check('review', 'Отзыв обязателен').not().isEmpty(),
      check('deliveryRating', 'Оценка доставки должна быть от 1 до 5').optional().isInt({ min: 1, max: 5 }),
      check('foodRating', 'Оценка еды должна быть от 1 до 5').optional().isInt({ min: 1, max: 5 })
    ]
  ],
  orderController.addOrderRating
);

// @route   GET /api/orders/:id/tracking
// @desc    Get order tracking information
// @access  Private
router.get('/:id/tracking', auth, orderController.getOrderTracking);

module.exports = router; 