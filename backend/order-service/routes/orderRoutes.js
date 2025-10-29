const express = require('express');
const router = express.Router();
const {
  createOrder,
  getUserOrders,
  getAllOrders,
  getOrder,
  updateOrderStatus,
  deleteOrder
} = require('../controllers/orderController');

router.route('/')
  .get(getAllOrders)
  .post(createOrder);

router.route('/:id')
  .get(getOrder)
  .delete(deleteOrder);

router.route('/:id/status')
  .put(updateOrderStatus);

router.get('/user/:userId', getUserOrders);

module.exports = router;

