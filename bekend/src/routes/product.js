const express = require('express');
const { check } = require('express-validator');
const productController = require('../controllers/productController');
const auth = require('../middleware/auth');
const admin = require('../middleware/admin');

const router = express.Router();

/**
 * @swagger
 * /products:
 *   get:
 *     tags:
 *       - Products
 *     summary: Получение списка продуктов
 *     description: Возвращает список продуктов с возможностью фильтрации и пагинации
 *     parameters:
 *       - in: query
 *         name: category
 *         schema:
 *           type: string
 *         description: ID категории для фильтрации
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
 *         description: Список продуктов
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 products:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Product'
 *                 total:
 *                   type: integer
 *                 page:
 *                   type: integer
 */
router.get('/', productController.getProducts);

// @route   GET /api/products/search
// @desc    Search products
// @access  Public
router.get('/search', productController.searchProducts);

// @route   GET /api/products/popular
// @desc    Get popular products
// @access  Public
router.get('/popular', productController.getPopularProducts);

// @route   GET /api/products/category/:categoryId
// @desc    Get products by category
// @access  Public
router.get('/category/:categoryId', productController.getProductsByCategory);

/**
 * @swagger
 * /products/{id}:
 *   get:
 *     tags:
 *       - Products
 *     summary: Получение продукта по ID
 *     description: Возвращает информацию о конкретном продукте
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID продукта
 *     responses:
 *       200:
 *         description: Информация о продукте
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       404:
 *         description: Продукт не найден
 */
router.get('/:id', productController.getProduct);

/**
 * @swagger
 * /products:
 *   post:
 *     tags:
 *       - Products
 *     summary: Создание нового продукта
 *     description: Создает новый продукт (только для администраторов)
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - price
 *               - category
 *             properties:
 *               name:
 *                 type: string
 *                 description: Название продукта
 *               description:
 *                 type: string
 *                 description: Описание продукта
 *               price:
 *                 type: number
 *                 description: Цена продукта
 *               category:
 *                 type: string
 *                 description: ID категории
 *               images:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: URLs изображений
 *     responses:
 *       201:
 *         description: Продукт создан
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       400:
 *         description: Неверные данные
 *       401:
 *         description: Не авторизован
 *       403:
 *         description: Нет прав доступа
 */
router.post(
  '/',
  [
    auth,
    admin,
    [
      check('name', 'Название обязательно').not().isEmpty(),
      check('description', 'Описание обязательно').not().isEmpty(),
      check('price', 'Цена должна быть больше 0').isFloat({ min: 0 }),
      check('category', 'Категория обязательна').not().isEmpty(),
      check('subCategory', 'Подкатегория обязательна').not().isEmpty(),
      check('inStock', 'Количество на складе должно быть указано').isInt({ min: 0 }),
      check('ingredients', 'Ингредиенты должны быть массивом').optional().isArray(),
      check('allergens', 'Аллергены должны быть массивом').optional().isArray(),
      check('nutritionalInfo', 'Пищевая ценность должна быть объектом').optional().isObject()
    ]
  ],
  productController.createProduct
);

/**
 * @swagger
 * /products/{id}:
 *   put:
 *     tags:
 *       - Products
 *     summary: Обновление продукта
 *     description: Обновляет информацию о продукте (только для администраторов)
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID продукта
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               description:
 *                 type: string
 *               price:
 *                 type: number
 *               category:
 *                 type: string
 *               images:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       200:
 *         description: Продукт обновлен
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       400:
 *         description: Неверные данные
 *       401:
 *         description: Не авторизован
 *       403:
 *         description: Нет прав доступа
 *       404:
 *         description: Продукт не найден
 */
router.put(
  '/:id',
  [
    auth,
    admin,
    [
      check('name', 'Название обязательно').optional().not().isEmpty(),
      check('description', 'Описание обязательно').optional().not().isEmpty(),
      check('price', 'Цена должна быть больше 0').optional().isFloat({ min: 0 }),
      check('category', 'Категория обязательна').optional().not().isEmpty(),
      check('subCategory', 'Подкатегория обязательна').optional().not().isEmpty(),
      check('inStock', 'Количество на складе должно быть указано').optional().isInt({ min: 0 }),
      check('ingredients', 'Ингредиенты должны быть массивом').optional().isArray(),
      check('allergens', 'Аллергены должны быть массивом').optional().isArray(),
      check('nutritionalInfo', 'Пищевая ценность должна быть объектом').optional().isObject()
    ]
  ],
  productController.updateProduct
);

/**
 * @swagger
 * /products/{id}:
 *   delete:
 *     tags:
 *       - Products
 *     summary: Удаление продукта
 *     description: Удаляет продукт (только для администраторов)
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID продукта
 *     responses:
 *       200:
 *         description: Продукт удален
 *       401:
 *         description: Не авторизован
 *       403:
 *         description: Нет прав доступа
 *       404:
 *         description: Продукт не найден
 */
router.delete('/:id', [auth, admin], productController.deleteProduct);

// @route   POST /api/products/:id/images
// @desc    Upload product images
// @access  Private/Admin
router.post(
  '/:id/images',
  [auth, admin],
  productController.uploadImages
);

// @route   DELETE /api/products/:id/images/:imageId
// @desc    Delete product image
// @access  Private/Admin
router.delete(
  '/:id/images/:imageId',
  [auth, admin],
  productController.deleteImage
);

// @route   POST /api/products/:id/rating
// @desc    Add product rating
// @access  Private
router.post(
  '/:id/rating',
  [
    auth,
    [
      check('rating', 'Оценка должна быть от 1 до 5').isInt({ min: 1, max: 5 }),
      check('review', 'Отзыв обязателен').not().isEmpty()
    ]
  ],
  productController.addRating
);

// @route   GET /api/products/:id/ratings
// @desc    Get product ratings
// @access  Public
router.get('/:id/ratings', productController.getProductRatings);

module.exports = router; 