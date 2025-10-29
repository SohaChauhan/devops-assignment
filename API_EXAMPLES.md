# API Examples

This document provides example API calls for all microservices.

## User Service (Port 3001)

### Register a New User

```bash
curl -X POST http://localhost:3001/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "user"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "_id": "65f1234567890abcdef12345",
    "name": "John Doe",
    "email": "john@example.com",
    "role": "user",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Login

```bash
curl -X POST http://localhost:3001/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Get User Profile (Protected)

```bash
curl -X GET http://localhost:3001/api/users/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Update Profile (Protected)

```bash
curl -X PUT http://localhost:3001/api/users/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Updated",
    "email": "john.updated@example.com"
  }'
```

## Product Service (Port 3002)

### Get All Products

```bash
curl -X GET http://localhost:3002/api/products
```

**Response:**
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "_id": "65f1234567890abcdef12345",
      "name": "Laptop",
      "description": "High-performance laptop",
      "price": 999.99,
      "stock": 10,
      "category": "Electronics",
      "imageUrl": "https://example.com/laptop.jpg"
    }
  ]
}
```

### Get Single Product

```bash
curl -X GET http://localhost:3002/api/products/PRODUCT_ID
```

### Create Product

```bash
curl -X POST http://localhost:3002/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wireless Mouse",
    "description": "Ergonomic wireless mouse with long battery life",
    "price": 29.99,
    "stock": 50,
    "category": "Electronics",
    "imageUrl": "https://via.placeholder.com/300"
  }'
```

### Update Product

```bash
curl -X PUT http://localhost:3002/api/products/PRODUCT_ID \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wireless Mouse Pro",
    "price": 34.99,
    "stock": 45
  }'
```

### Delete Product

```bash
curl -X DELETE http://localhost:3002/api/products/PRODUCT_ID
```

### Update Product Stock

```bash
curl -X PATCH http://localhost:3002/api/products/PRODUCT_ID/stock \
  -H "Content-Type: application/json" \
  -d '{
    "quantity": 100
  }'
```

## Order Service (Port 3003)

### Create Order

```bash
curl -X POST http://localhost:3003/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "65f1234567890abcdef12345",
    "userName": "John Doe",
    "userEmail": "john@example.com",
    "items": [
      {
        "productId": "65f9876543210fedcba09876",
        "quantity": 2
      },
      {
        "productId": "65f1111111111111111111111",
        "quantity": 1
      }
    ],
    "shippingAddress": {
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA"
    },
    "paymentMethod": "credit_card"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "_id": "65f2222222222222222222222",
    "userId": "65f1234567890abcdef12345",
    "userName": "John Doe",
    "userEmail": "john@example.com",
    "items": [
      {
        "productId": "65f9876543210fedcba09876",
        "productName": "Laptop",
        "quantity": 2,
        "price": 999.99
      }
    ],
    "totalAmount": 1999.98,
    "status": "pending",
    "shippingAddress": {
      "street": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "country": "USA"
    },
    "paymentMethod": "credit_card",
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
}
```

### Get All Orders

```bash
curl -X GET http://localhost:3003/api/orders
```

### Get Orders by User

```bash
curl -X GET http://localhost:3003/api/orders/user/USER_ID
```

### Get Single Order

```bash
curl -X GET http://localhost:3003/api/orders/ORDER_ID
```

### Update Order Status

```bash
curl -X PUT http://localhost:3003/api/orders/ORDER_ID/status \
  -H "Content-Type: application/json" \
  -d '{
    "status": "shipped"
  }'
```

**Valid status values:**
- `pending`
- `processing`
- `shipped`
- `delivered`
- `cancelled`

### Delete Order

```bash
curl -X DELETE http://localhost:3003/api/orders/ORDER_ID
```

## Testing Workflow

### Complete Purchase Flow

1. **Register User:**
```bash
curl -X POST http://localhost:3001/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"test123","role":"user"}'
```

2. **Create Products (use returned token from registration):**
```bash
curl -X POST http://localhost:3002/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Product 1","price":50,"stock":100,"category":"Test"}'
```

3. **Place Order:**
```bash
curl -X POST http://localhost:3003/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId":"USER_ID_FROM_STEP_1",
    "userName":"Test User",
    "userEmail":"test@example.com",
    "items":[{"productId":"PRODUCT_ID_FROM_STEP_2","quantity":1}],
    "shippingAddress":{"street":"123 St","city":"NYC","state":"NY","zipCode":"10001","country":"USA"},
    "paymentMethod":"credit_card"
  }'
```

4. **Check Orders:**
```bash
curl -X GET http://localhost:3003/api/orders/user/USER_ID
```

## Using Postman

Import these endpoints into Postman:

1. Create a new Collection named "E-Commerce API"
2. Add folders for each service
3. Add requests using the examples above
4. Set up environment variables for:
   - `base_url_user`: http://localhost:3001
   - `base_url_product`: http://localhost:3002
   - `base_url_order`: http://localhost:3003
   - `token`: (JWT token from login)

## Error Responses

All services return errors in this format:

```json
{
  "success": false,
  "message": "Error description here"
}
```

Common HTTP Status Codes:
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Server Error

