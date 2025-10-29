# Windows Deployment Steps - Quick Reference

## 🚀 Deploy from Windows to AWS EC2

Choose the method that works best for you:

---

## ✅ Method 1: PowerShell (Fixed - No gzip needed)

```powershell
# 1. Navigate to project
cd C:\Users\sohac\OneDrive\Desktop\devops-assignment

# 2. Build images locally
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# 3. Create temp directory
mkdir C:\temp\docker-images -Force

# 4. Save images (no compression needed)
docker save user-service:latest -o C:\temp\docker-images\user-service.tar
docker save product-service:latest -o C:\temp\docker-images\product-service.tar
docker save order-service:latest -o C:\temp\docker-images\order-service.tar
docker save frontend:latest -o C:\temp\docker-images\frontend.tar

# 5. Upload to server
scp -i ~/.ssh/id_rsa C:/temp/docker-images/user-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/product-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/order-service.tar ubuntu@34.199.190.209:/tmp/
scp -i ~/.ssh/id_rsa C:/temp/docker-images/frontend.tar ubuntu@34.199.190.209:/tmp/

# 6. SSH to server and load images
ssh -i ~/.ssh/id_rsa ubuntu@34.199.190.209

# On server:
cd /tmp
docker load -i user-service.tar
docker load -i product-service.tar
docker load -i order-service.tar
docker load -i frontend.tar
rm *.tar

# Start services
cd /home/ubuntu/ecommerce-app
docker-compose up -d

# Check status
docker-compose ps
```

---

## ✅ Method 2: Automated PowerShell Script

```powershell
# Just run the script!
.\scripts\build-and-upload.ps1
```

---

## ✅ Method 3: Git Bash (Recommended - Fastest!)

Open **Git Bash** (not PowerShell):

```bash
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment

# Build all images
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# Save with compression
mkdir -p /c/temp/docker-images
docker save user-service:latest | gzip > /c/temp/docker-images/user-service.tar.gz
docker save product-service:latest | gzip > /c/temp/docker-images/product-service.tar.gz
docker save order-service:latest | gzip > /c/temp/docker-images/order-service.tar.gz
docker save frontend:latest | gzip > /c/temp/docker-images/frontend.tar.gz

# Upload all at once
scp -i ~/.ssh/id_rsa /c/temp/docker-images/*.tar.gz ubuntu@34.199.190.209:/tmp/

# Load on server
ssh -i ~/.ssh/id_rsa ubuntu@34.199.190.209 << 'EOF'
cd /tmp
docker load < user-service.tar.gz
docker load < product-service.tar.gz
docker load < order-service.tar.gz
docker load < frontend.tar.gz
rm *.tar.gz
cd /home/ubuntu/ecommerce-app
docker-compose up -d
docker-compose ps
EOF
```

---

## ✅ Method 4: Use Automated Bash Script

In **Git Bash**:

```bash
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment
chmod +x scripts/build-and-upload.sh
./scripts/build-and-upload.sh
```

---

## 🎯 Quick Comparison

| Method | Tool | Compression | Speed | Best For |
|--------|------|-------------|-------|----------|
| PowerShell Manual | PowerShell | No | Medium | Step-by-step control |
| PowerShell Script | PowerShell | No | Medium | Automated (Windows native) |
| Git Bash Manual | Git Bash | Yes | Fast | Best performance |
| Git Bash Script | Git Bash | Yes | Fastest | One-command deploy |

---

## 💡 Troubleshooting

### Issue: "gzip not recognized"
**Solution**: Use PowerShell (Method 1 or 2) or Git Bash (Method 3 or 4)

### Issue: "scp not found"
**Solution**: 
- Install Git for Windows (includes scp)
- Or use Git Bash

### Issue: "docker build too slow"
**Solution**: 
- Build on your local machine (this guide)
- Don't build on the free tier EC2 instance

### Issue: "Permission denied (publickey)"
**Solution**:
```powershell
# Check SSH key exists
Test-Path ~/.ssh/id_rsa

# If not, copy from terraform folder
Copy-Item terraform\key.txt ~/.ssh\id_rsa
icacls ~/.ssh\id_rsa /inheritance:r
icacls ~/.ssh\id_rsa /grant:r "$env:USERNAME:(R)"
```

---

## ⚡ Fastest Method Right Now

**Use Git Bash with the automated script:**

```bash
# Open Git Bash
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment

# Run script
bash scripts/build-and-upload.sh

# Done! Takes ~5-10 minutes total
```

---

## 📊 Time Comparison

| Action | On Server (t2.micro) | On Your PC |
|--------|---------------------|------------|
| Build user-service | 3-5 min | 30-60 sec |
| Build product-service | 3-5 min | 30-60 sec |
| Build order-service | 3-5 min | 30-60 sec |
| Build frontend | **5-10 min or timeout** ❌ | 1-2 min ✅ |
| **Total Build Time** | **15-25 min** | **3-5 min** ⚡ |
| Upload images | N/A | 2-3 min |
| **Grand Total** | **15-25 min (often fails)** | **5-8 min (reliable)** |

---

## 🎯 My Recommendation

**For Windows users**: Use **Git Bash** with compression

```bash
# Quick commands:
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment
chmod +x scripts/build-and-upload.sh
./scripts/build-and-upload.sh
```

This is:
- ✅ Fastest (5-8 minutes total)
- ✅ Most reliable (builds locally)
- ✅ Compressed (smaller uploads)
- ✅ Automated (one command)

---

## 🚀 Complete Example Session

```bash
# 1. Open Git Bash
# 2. Navigate to project
cd /c/Users/sohac/OneDrive/Desktop/devops-assignment

# 3. Run the automated script
bash scripts/build-and-upload.sh

# Output:
# 🔨 Building images locally...
# Building user-service... ✅
# Building product-service... ✅
# Building order-service... ✅
# Building frontend... ✅
# 💾 Saving images to files... ✅
# 📤 Uploading images to server... ✅
# 📥 Loading images on server... ✅
# 🎉 IMAGES DEPLOYED! 🎉

# 4. Verify on server
ssh -i ~/.ssh/id_rsa ubuntu@34.199.190.209
cd /home/ubuntu/ecommerce-app
docker-compose ps

# All services should be running! ✅
```

---

**Choose your preferred method and start deploying! 🚀**

