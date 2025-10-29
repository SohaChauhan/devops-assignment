# Quick Setup Guide

## Step-by-Step Setup Instructions

### 1. Prerequisites Check

Before starting, verify you have:

```bash
# Check Node.js version (should be v14+)
node --version

# Check npm version
npm --version

# Check MongoDB installation
mongod --version
```

### 2. Install Dependencies

From the project root directory:

```bash
npm install
cd backend/user-service && npm install
cd ../product-service && npm install
cd ../order-service && npm install
cd ../../frontend && npm install
```

Or simply run:
```bash
npm run install-all
```

### 3. Create Environment Files

**For User Service** - Create `backend/user-service/.env`:
```
PORT=3001
MONGODB_URI=mongodb://localhost:27017/user-service
JWT_SECRET=my-super-secret-jwt-key-12345
JWT_EXPIRE=7d
```

**For Product Service** - Create `backend/product-service/.env`:
```
PORT=3002
MONGODB_URI=mongodb://localhost:27017/product-service
```

**For Order Service** - Create `backend/order-service/.env`:
```
PORT=3003
MONGODB_URI=mongodb://localhost:27017/order-service
PRODUCT_SERVICE_URL=http://localhost:3002
```

### 4. Start MongoDB

**Windows:**
```bash
net start MongoDB
```

**macOS:**
```bash
brew services start mongodb-community
```

**Linux:**
```bash
sudo systemctl start mongod
```

**Using Docker (Alternative):**
```bash
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### 5. Start the Application

**Option A - All services at once:**
```bash
npm run dev
```

**Option B - Individual services (open 4 terminals):**

Terminal 1:
```bash
cd backend/user-service
npm run dev
```

Terminal 2:
```bash
cd backend/product-service
npm run dev
```

Terminal 3:
```bash
cd backend/order-service
npm run dev
```

Terminal 4:
```bash
cd frontend
npm start
```

### 6. Access the Application

Open your browser and navigate to:
- Frontend: http://localhost:3000
- User Service: http://localhost:3001/health
- Product Service: http://localhost:3002/health
- Order Service: http://localhost:3003/health

### 7. Create Initial Data

**Option 1 - Register Admin Account:**
1. Go to http://localhost:3000/register
2. Fill in the form and select "Admin" role
3. Login with your credentials

**Option 2 - Use API to create admin:**
```bash
curl -X POST http://localhost:3001/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Admin User",
    "email": "admin@example.com",
    "password": "admin123",
    "role": "admin"
  }'
```

**Create Sample Products:**
1. Login as admin
2. Go to "Manage Products"
3. Add some products with details

### 8. Test the Application

1. **Test User Registration**
   - Go to Register page
   - Create a new user account

2. **Test Product Management (Admin)**
   - Login as admin
   - Add, edit, delete products

3. **Test Shopping Cart**
   - Browse products
   - Add items to cart
   - Proceed to checkout

4. **Test Order Placement**
   - Fill shipping details
   - Place an order
   - Check "Orders" page

## Common Issues and Solutions

### Issue: MongoDB Connection Failed

**Solution:**
- Ensure MongoDB is running
- Check connection string in `.env` files
- Verify MongoDB is listening on port 27017

### Issue: Port Already in Use

**Solution:**
```bash
# Windows - Find and kill process
netstat -ano | findstr :3001
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:3001 | xargs kill -9
```

### Issue: Module Not Found

**Solution:**
```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
npm run install-all
```

### Issue: CORS Errors

**Solution:**
- Ensure all services are running
- Check that frontend is accessing correct ports
- Verify CORS is enabled in backend services

## Verification Checklist

- [ ] Node.js and npm installed
- [ ] MongoDB installed and running
- [ ] All dependencies installed
- [ ] `.env` files created for all services
- [ ] User Service running on port 3001
- [ ] Product Service running on port 3002
- [ ] Order Service running on port 3003
- [ ] Frontend running on port 3000
- [ ] Can access all health endpoints
- [ ] Can register a new user
- [ ] Can login successfully
- [ ] Can create products (admin)
- [ ] Can add items to cart
- [ ] Can place an order

## Next Steps

After successful setup:
1. Create an admin account
2. Add some sample products
3. Create a regular user account
4. Test the complete shopping flow
5. Review the API documentation in README.md

Happy coding! 🚀

