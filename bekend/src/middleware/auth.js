const jwt = require('jsonwebtoken');
const config = require('../config/config');
const logger = require('../utils/logger');

module.exports = (req, res, next) => {
  try {
    // Get token from header
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({ message: 'Нет токена авторизации' });
    }

    try {
      // Verify token
      const decoded = jwt.verify(token, config.jwt.secret);
      
      // Add user info to request
      req.user = decoded;
      
      next();
    } catch (err) {
      logger.error('Error verifying token:', err);
      return res.status(401).json({ message: 'Токен недействителен' });
    }
  } catch (err) {
    logger.error('Error in auth middleware:', err);
    res.status(500).json({ message: 'Ошибка сервера' });
  }
}; 