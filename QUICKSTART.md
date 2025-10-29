# Quick Start Guide - E-Commerce Microservices

Choose your deployment method:

## 🚀 Option 1: Local Development (5 minutes)

**Perfect for testing and development**

### Prerequisites
- Docker and Docker Compose installed

### Steps

1. **Start the application:**
   ```bash
   chmod +x scripts/*.sh
   ./scripts/local-deploy.sh
   ```

2. **Access the app:**
   - Frontend: http://localhost
   - User Service: http://localhost:3001
   - Product Service: http://localhost:3002
   - Order Service: http://localhost:3003

3. **Create an admin account:**
   - Go to http://localhost/register
   - Select "Admin" role
   - Start adding products!

4. **Stop when done:**
   ```bash
   docker-compose down
   ```

---

## ☁️ Option 2: AWS Free Tier Deployment (15 minutes)

**Deploy to production on AWS for FREE**

### Prerequisites
- AWS Account (Free Tier eligible)
- AWS CLI installed and configured
- Terraform installed
- SSH key pair

### Quick Setup

1. **Generate SSH key (if you don't have one):**
   ```bash
   ssh-keygen -t rsa -b 4096
   ```

2. **Configure AWS:**
   ```bash
   aws configure
   # Enter your AWS credentials
   ```

3. **Setup Terraform variables:**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars and add your SSH public key
   nano terraform.tfvars
   ```

4. **Deploy infrastructure:**
   ```bash
   chmod +x ../scripts/*.sh
   ../scripts/terraform-deploy.sh
   ```

5. **Wait 2-3 minutes** for the server to initialize

6. **Deploy application:**
   ```bash
   # Get server IP from terraform output
   SERVER_IP=$(terraform output -raw instance_public_ip)
   cd ..
   ./scripts/deploy-to-aws.sh $SERVER_IP
   ```

7. **Access your app:**
   ```
   http://<SERVER_IP>
   ```

### Important: Cost Management

✅ **This setup is FREE for 12 months** under AWS Free Tier
- Uses t2.micro instance (750 hours/month free)
- 30 GB storage (within free tier)
- 1 Elastic IP (free when attached)

⚠️ **To avoid charges:**
- Don't exceed 750 hours/month (one instance = ~720 hours/month)
- Destroy resources when not needed:
  ```bash
  cd terraform
  terraform destroy
  ```

---

## 🎯 What's Included

### Microservices
- **User Service**: Authentication, registration, JWT tokens
- **Product Service**: CRUD operations for products
- **Order Service**: Order management with stock tracking

### Frontend
- Modern React UI with beautiful gradients
- Shopping cart functionality
- Admin dashboard for product management
- Responsive design

### Infrastructure
- **Docker**: Containerized microservices
- **Kubernetes**: Orchestration with K3s
- **MongoDB**: Database for each service
- **Nginx**: Reverse proxy for frontend

---

## 📊 Architecture

```
┌─────────────────────────────────────────────────────┐
│                     Frontend (React)                 │
│                    Nginx on Port 80                  │
└─────────────────────┬───────────────────────────────┘
                      │
        ┌─────────────┼─────────────┬─────────────┐
        │             │             │             │
┌───────▼───────┐ ┌───▼────────┐ ┌──▼──────────┐│
│ User Service  │ │  Product   │ │   Order     ││
│   Port 3001   │ │  Service   │ │  Service    ││
└───────┬───────┘ │ Port 3002  │ │ Port 3003   ││
        │         └─────┬──────┘ └──────┬───────┘│
        │               │                │        │
        └───────┬───────┴────────────────┘        │
                │                                  │
        ┌───────▼────────────────────────────┐    │
        │         MongoDB (Port 27017)       │    │
        │  ┌─────────┬──────────┬─────────┐  │    │
        │  │  User   │ Product  │  Order  │  │    │
        │  │   DB    │   DB     │   DB    │  │    │
        │  └─────────┴──────────┴─────────┘  │    │
        └────────────────────────────────────┘    │
                                                   │
           Running in Kubernetes (K3s) ◄──────────┘
```

---

## 🛠️ Common Commands

### Local Development

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Rebuild specific service
docker-compose up -d --build user-service

# Stop all
docker-compose down

# Stop and remove data
docker-compose down -v
```

### AWS/Kubernetes

```bash
# SSH into server
ssh -i ~/.ssh/id_rsa ubuntu@<SERVER_IP>

# Check pods
kubectl get pods -n ecommerce

# View logs
kubectl logs -n ecommerce -l app=user-service --tail=50

# Scale service
kubectl scale deployment user-service -n ecommerce --replicas=3

# Restart deployment
kubectl rollout restart deployment user-service -n ecommerce

# Check resources
kubectl top nodes
kubectl top pods -n ecommerce
```

---

## 🧪 Testing the Application

### 1. Register Admin User
- Navigate to `/register`
- Create account with "Admin" role

### 2. Add Products
- Go to "Manage Products"
- Add some test products

### 3. Make a Purchase
- Register a regular user account
- Browse products
- Add items to cart
- Complete checkout
- View order in "Orders" page

### 4. Admin Features
- View all orders
- Update order status
- Manage products (CRUD)

---

## 🐛 Troubleshooting

### Local Development

**Issue: Port already in use**
```bash
docker-compose down
sudo lsof -ti:3001 | xargs kill -9  # or change port in docker-compose.yml
```

**Issue: MongoDB connection failed**
```bash
docker-compose down -v  # Remove volumes
docker-compose up -d    # Start fresh
```

### AWS Deployment

**Issue: Can't SSH to server**
```bash
# Check security group allows SSH from your IP
# Verify you're using correct key: ssh -i ~/.ssh/id_rsa ubuntu@<IP>
```

**Issue: Pods not starting**
```bash
ssh -i ~/.ssh/id_rsa ubuntu@<SERVER_IP>
kubectl describe pod -n ecommerce <POD_NAME>
kubectl logs -n ecommerce <POD_NAME>
```

**Issue: Out of memory (t2.micro)**
```bash
# Reduce replicas to 1
kubectl scale deployment --all --replicas=1 -n ecommerce
```

---

## 📈 Monitoring

### Check Application Health

```bash
# Local
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health

# AWS
curl http://<SERVER_IP>:3001/health
curl http://<SERVER_IP>:3002/health
curl http://<SERVER_IP>:3003/health
```

### View Metrics

```bash
# Kubernetes
kubectl top nodes
kubectl top pods -n ecommerce

# Docker
docker stats
```

---

## 🔒 Security Notes

**Before going to production:**

1. Change JWT_SECRET in `k8s/user-service-deployment.yaml`
2. Add MongoDB authentication
3. Setup HTTPS/SSL certificates
4. Restrict security group to specific IPs
5. Enable audit logging
6. Use secrets management (AWS Secrets Manager)
7. Implement rate limiting
8. Add WAF (Web Application Firewall)

---

## 📚 Learn More

- [Full README](README.md) - Complete project documentation
- [Deployment Guide](DEPLOYMENT.md) - Detailed deployment instructions
- [API Examples](API_EXAMPLES.md) - API endpoint examples
- [Terraform README](terraform/README.md) - Infrastructure details

---

## 💡 Tips

1. **Free Alternative Clouds:**
   - Oracle Cloud (Always Free tier)
   - Google Cloud ($300 credit)
   - Azure ($200 credit)

2. **Cost Monitoring:**
   - Set up AWS billing alerts
   - Use AWS Cost Explorer
   - Check free tier usage regularly

3. **Performance:**
   - For better performance, upgrade to t2.small ($0.023/hr)
   - Use RDS for MongoDB in production
   - Add CloudFront CDN for frontend

4. **Backup:**
   - Regular MongoDB dumps
   - Snapshot EBS volumes
   - Version control your code

---

## 🤝 Need Help?

1. Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed troubleshooting
2. Review logs: `kubectl logs -n ecommerce <pod-name>`
3. Verify all pods are running: `kubectl get pods -n ecommerce`
4. Check service connectivity: `kubectl get svc -n ecommerce`

---

**Happy Building! 🎉**

Start with local deployment, test everything, then deploy to AWS when ready!

