# Server Deployment - Step-by-Step Guide

## 🎯 Complete Deployment Process

Follow these steps to deploy your application to the AWS EC2 server.

---

## Part 1: Build Images Locally (On Your PC)

### **Option A: Using Git Bash (Recommended)**

```bash
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment

# Build all images
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# Save images with compression
mkdir -p /c/temp/docker-images
docker save user-service:latest | gzip > /c/temp/docker-images/user-service.tar.gz
docker save product-service:latest | gzip > /c/temp/docker-images/product-service.tar.gz
docker save order-service:latest | gzip > /c/temp/docker-images/order-service.tar.gz
docker save frontend:latest | gzip > /c/temp/docker-images/frontend.tar.gz
```

### **Option B: Using PowerShell**

```powershell
cd C:\Users\sohac\OneDrive\Desktop\devops-assignment

# Build all images
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# Save images without compression
mkdir C:\temp\docker-images -Force
docker save user-service:latest -o C:\temp\docker-images\user-service.tar
docker save product-service:latest -o C:\temp\docker-images\product-service.tar
docker save order-service:latest -o C:\temp\docker-images\order-service.tar
docker save frontend:latest -o C:\temp\docker-images\frontend.tar
```

---

## Part 2: Upload to Server

### **Git Bash:**
```bash
scp -i ~/.ssh/id_rsa /c/temp/docker-images/*.tar.gz ubuntu@34.199.190.209:/tmp/
```

### **PowerShell:**
```powershell
scp -i ~/.ssh/id_rsa C:/temp/docker-images/user-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/product-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/order-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/frontend.tar ubuntu@34.199.190.209:/tmp/
```

---

## Part 3: Deploy on Server

```bash
# SSH to server
ssh -i ~/.ssh/id_rsa ubuntu@34.199.190.209

# Go to temp directory
cd /tmp

# Load images (Git Bash - compressed)
docker load < user-service.tar.gz
docker load < product-service.tar.gz
docker load < order-service.tar.gz
docker load < frontend.tar.gz

# OR Load images (PowerShell - uncompressed)
docker load -i user-service.tar
docker load -i product-service.tar
docker load -i order-service.tar
docker load -i frontend.tar

# Verify images are loaded
docker images

# You should see:
# user-service        latest
# product-service     latest
# order-service       latest
# frontend            latest

# Clean up tar files
rm /tmp/*.tar*

# Navigate to app directory
cd /home/ubuntu/ecommerce-app

# Update docker-compose.yml (pull latest from git)
git pull

# Stop any running containers
docker-compose down

# Start services with pre-built images
docker-compose up -d

# Wait a few seconds for services to start
sleep 10

# Check status
docker-compose ps

# Check logs
docker-compose logs -f
```

---

## ✅ Verification Steps

```bash
# On the server, check if all services are running
docker-compose ps

# Expected output:
# NAME              STATUS
# mongodb           Up (healthy)
# user-service      Up (healthy)
# product-service   Up (healthy)
# order-service     Up (healthy)
# frontend          Up

# Test individual services
curl http://localhost:3001/health  # User service
curl http://localhost:3002/health  # Product service
curl http://localhost:3003/health  # Order service
curl http://localhost            # Frontend

# Check logs for any errors
docker-compose logs user-service
docker-compose logs product-service
docker-compose logs order-service
docker-compose logs frontend
```

---

## 🌐 Access Your Application

Once all services are running, open your browser:

```
http://34.199.190.209
```

You should see your e-commerce application! 🎉

---

## 🔧 Troubleshooting

### Issue: "docker-compose is rebuilding images"

**Solution**: Make sure you've updated the docker-compose.yml on the server:
```bash
cd /home/ubuntu/ecommerce-app
git pull
docker-compose down
docker-compose up -d
```

### Issue: Services won't start

**Check logs**:
```bash
docker-compose logs --tail=50
```

**Common issues**:
1. MongoDB not ready - wait 30 seconds and try again
2. Port conflicts - check if ports are in use: `sudo netstat -tulpn | grep LISTEN`
3. Images not loaded - verify: `docker images`

### Issue: Can't access application from browser

**Check**:
1. Security group allows port 80: AWS Console → EC2 → Security Groups
2. Services are running: `docker-compose ps`
3. Server IP is correct: `curl ifconfig.me` on server

---

## 📋 Quick Command Reference

### On Your Local Machine:
```bash
# Build all images
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# Upload to server (Git Bash)
bash scripts/build-and-upload.sh
```

### On The Server:
```bash
# Load images
cd /tmp && docker load < *.tar.gz

# Start services
cd /home/ubuntu/ecommerce-app
git pull
docker-compose up -d

# Check status
docker-compose ps
docker-compose logs -f
```

---

## 🚀 One-Command Deployment (Git Bash)

From your local machine:

```bash
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment

# This does everything:
bash scripts/build-and-upload.sh

# Then SSH and start:
ssh -i ~/.ssh/id_rsa ubuntu@34.199.190.209 'cd /home/ubuntu/ecommerce-app && git pull && docker-compose up -d'
```

---

## 📊 Deployment Checklist

- [ ] Built all 4 images locally
- [ ] Saved images to files
- [ ] Uploaded images to server
- [ ] Loaded images on server
- [ ] Updated docker-compose.yml (git pull)
- [ ] Started services (docker-compose up -d)
- [ ] Verified all services running (docker-compose ps)
- [ ] Tested application in browser
- [ ] Checked logs for errors

---

**Your application should now be live at: http://34.199.190.209** 🎉

