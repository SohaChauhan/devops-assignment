# E-Commerce Microservices Application

A full-stack e-commerce application built with Node.js microservices architecture and React frontend.

## 🏗️ Architecture

This application consists of **3 microservices**:

1. **User Service** (Port 3001) - Authentication and user management
2. **Product Service** (Port 3002) - Product CRUD operations
3. **Order Service** (Port 3003) - Order management and history

## 🚀 Features

### User Service
- ✅ User registration with role selection (user/admin)
- ✅ Secure authentication with JWT
- ✅ Password hashing with bcrypt
- ✅ Profile management

### Product Service
- ✅ Create, Read, Update, Delete products
- ✅ Product categorization
- ✅ Stock management
- ✅ Image URL support

### Order Service
- ✅ Place orders with automatic stock updates
- ✅ Order history tracking
- ✅ Multiple order statuses (pending, processing, shipped, delivered, cancelled)
- ✅ Shipping address management
- ✅ Payment method selection

### Frontend
- ✅ Modern, responsive UI with gradient designs
- ✅ User authentication (login/register)
- ✅ Product browsing and filtering
- ✅ Shopping cart functionality
- ✅ Checkout process
- ✅ Order tracking
- ✅ Admin product management dashboard
- ✅ Role-based access control

## 📋 Prerequisites

Before running this application, make sure you have:

- **Node.js** (v14 or higher)
- **MongoDB** (v4.4 or higher)
- **npm** or **yarn**

## 🛠️ Installation

### 1. Clone the repository

```bash
cd devops-assignment
```

### 2. Install all dependencies

Run this command from the root directory:

```bash
npm run install-all
```

This will install dependencies for:
- Root package
- User Service
- Product Service
- Order Service
- Frontend

### 3. Set up environment variables

Create `.env` files for each service:

**backend/user-service/.env**
```env
PORT=3001
MONGODB_URI=mongodb://localhost:27017/user-service
JWT_SECRET=your-secret-key-change-this-in-production
JWT_EXPIRE=7d
```

**backend/product-service/.env**
```env
PORT=3002
MONGODB_URI=mongodb://localhost:27017/product-service
```

**backend/order-service/.env**
```env
PORT=3003
MONGODB_URI=mongodb://localhost:27017/order-service
PRODUCT_SERVICE_URL=http://localhost:3002
```

### 4. Start MongoDB

Make sure MongoDB is running on your system:

```bash
# Windows
net start MongoDB

# macOS/Linux
sudo systemctl start mongod
```

Or if using MongoDB Compass, just ensure it's connected to `localhost:27017`.

## 🎮 Running the Application

### Option 1: Run all services together (Recommended)

From the root directory:

```bash
npm run dev
```

This will start all 3 microservices and the frontend simultaneously.

### Option 2: Run services individually

Open 4 separate terminal windows:

**Terminal 1 - User Service:**
```bash
cd backend/user-service
npm run dev
```

**Terminal 2 - Product Service:**
```bash
cd backend/product-service
npm run dev
```

**Terminal 3 - Order Service:**
```bash
cd backend/order-service
npm run dev
```

**Terminal 4 - Frontend:**
```bash
cd frontend
npm start
```

## 🌐 Access the Application

- **Frontend:** http://localhost:3000
- **User Service API:** http://localhost:3001
- **Product Service API:** http://localhost:3002
- **Order Service API:** http://localhost:3003

## 👤 Demo Credentials

You can create your own account or use these demo credentials:

**Admin Account:**
- Email: `admin@example.com`
- Password: `admin123`

**Regular User:**
- Email: `user@example.com`
- Password: `user123`

## 📚 API Documentation

### User Service (Port 3001)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/users/register` | Register new user |
| POST | `/api/users/login` | Login user |
| GET | `/api/users/profile` | Get user profile (Protected) |
| PUT | `/api/users/profile` | Update user profile (Protected) |

### Product Service (Port 3002)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/products` | Get all products |
| GET | `/api/products/:id` | Get single product |
| POST | `/api/products` | Create product |
| PUT | `/api/products/:id` | Update product |
| DELETE | `/api/products/:id` | Delete product |
| PATCH | `/api/products/:id/stock` | Update stock |

### Order Service (Port 3003)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/orders` | Get all orders |
| GET | `/api/orders/:id` | Get single order |
| GET | `/api/orders/user/:userId` | Get user orders |
| POST | `/api/orders` | Create order |
| PUT | `/api/orders/:id/status` | Update order status |
| DELETE | `/api/orders/:id` | Delete order |

## 🗂️ Project Structure

```
devops-assignment/
├── backend/
│   ├── user-service/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   └── package.json
│   ├── product-service/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   └── package.json
│   └── order-service/
│       ├── controllers/
│       ├── models/
│       ├── routes/
│       ├── server.js
│       └── package.json
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── App.js
│   │   ├── App.css
│   │   └── index.js
│   └── package.json
├── package.json
└── README.md
```

## 🎨 Features Showcase

### For Users
1. **Browse Products** - View all available products with prices and stock
2. **Add to Cart** - Build your shopping cart
3. **Checkout** - Complete orders with shipping details
4. **Track Orders** - View order history and status

### For Admins
1. **Manage Products** - Full CRUD operations on products
2. **View All Orders** - See all customer orders
3. **Update Order Status** - Change order status (pending → processing → shipped → delivered)

## 🔒 Security Features

- Password hashing with bcryptjs
- JWT-based authentication
- Protected routes with middleware
- Role-based access control (user/admin)
- Input validation with express-validator
- CORS enabled for frontend-backend communication

## 🛠️ Technologies Used

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM
- **JWT** - Authentication
- **bcryptjs** - Password hashing
- **Axios** - Inter-service communication

### Frontend
- **React** - UI library
- **React Router** - Navigation
- **Axios** - API calls
- **React Icons** - Icons
- **CSS3** - Styling with gradients and animations

## 📝 Usage Guide

### Creating Your First Admin Account

1. Navigate to http://localhost:3000
2. Click "Register"
3. Fill in your details and select "Admin" role
4. Submit the form

### Adding Products (Admin Only)

1. Login with admin credentials
2. Click "Manage Products" in the navbar
3. Click "Add Product" button
4. Fill in product details (name, price, stock, category, image URL)
5. Click "Create Product"

### Placing an Order

1. Login as a user
2. Browse products
3. Click "Add to Cart" on desired products
4. Click the cart icon in navbar
5. Review cart items
6. Click "Proceed to Checkout"
7. Fill in shipping address
8. Select payment method
9. Click "Place Order"

### Tracking Orders

1. Click "Orders" in the navbar
2. View all your orders with status
3. Admin users can see all customer orders and update statuses

## 🐛 Troubleshooting

### MongoDB Connection Issues

If you get connection errors:
1. Ensure MongoDB is running: `mongod --version`
2. Check if MongoDB service is active
3. Verify connection string in `.env` files

### Port Already in Use

If ports are already occupied:
1. Change ports in `.env` files
2. Update frontend API URLs in component files
3. Restart services

### Module Not Found Errors

Run installation again:
```bash
npm run install-all
```

## 🔄 CI/CD Pipeline

This project includes an automated CI/CD pipeline using **GitHub Actions** that:

### Automated on Every Push
- ✅ **Code Quality Check** - Runs ESLint on all services
- ✅ **Security Audit** - npm audit for vulnerable dependencies
- ✅ **Build & Test** - Builds all Docker images
- ✅ **Container Security Scan** - Trivy scans for vulnerabilities
- ✅ **Terraform Validation** - Validates infrastructure code

### Automated on Push to Main
- ✅ **Publish to GitHub Container Registry** - Publishes Docker images
- 📦 Images available at: `ghcr.io/YOUR_USERNAME/devops-assignment/SERVICE_NAME:latest`

### Pipeline Status
Check the **Actions** tab in GitHub to see pipeline runs and results.

## 🚀 AWS Deployment

Deployment to AWS is done **manually using Terraform**. See [`DEPLOYMENT-GUIDE.md`](./DEPLOYMENT-GUIDE.md) for detailed instructions.

### Quick Deployment Steps

1. **Configure AWS credentials**
```bash
aws configure
```

2. **Deploy infrastructure with Terraform**
```bash
cd terraform
terraform init
terraform apply
```

3. **Pull and deploy Docker images**
```bash
# SSH into the server (IP from Terraform output)
ssh -i ecommerce-key.pem ubuntu@SERVER_IP

# Pull images from GitHub Container Registry
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/product-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/order-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/frontend:latest

# Deploy to Kubernetes
kubectl apply -f ~/ecommerce-app/k8s/
```

**Access your app at:** `http://YOUR_SERVER_IP`

For complete deployment instructions, see **[DEPLOYMENT-GUIDE.md](./DEPLOYMENT-GUIDE.md)**

## 🐳 Docker & Kubernetes

This application is fully containerized:

- **Docker** - Each service has its own Dockerfile
- **Docker Compose** - For local development
- **Kubernetes (K3s)** - For production deployment on AWS
- **GitHub Container Registry** - For image storage

### Local Development with Docker

```bash
# Build all images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## 📄 License

This project is open source and available for educational purposes.

## 👥 Contributing

Feel free to fork this project and submit pull requests for improvements!

## 📧 Support

For issues or questions, please create an issue in the repository.

---

**Built with ❤️ using Node.js, React, and MongoDB**

