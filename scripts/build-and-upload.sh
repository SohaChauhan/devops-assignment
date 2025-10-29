#!/bin/bash

# Build images locally and upload to server
# Much faster than building on the server!

set -e

SERVER_IP="${SERVER_IP:-34.199.190.209}"
SSH_KEY="${SSH_KEY:-~/.ssh/id_rsa}"
SERVER_USER="ubuntu"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║   BUILD & UPLOAD IMAGES               ║"
echo "║   Build locally, deploy to server     ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Build images locally
echo -e "${GREEN}[1/4] 🔨 Building images locally...${NC}"
echo ""

echo "Building user-service..."
docker build -t user-service:latest ./backend/user-service

echo "Building product-service..."
docker build -t product-service:latest ./backend/product-service

echo "Building order-service..."
docker build -t order-service:latest ./backend/order-service

echo "Building frontend..."
docker build -t frontend:latest ./frontend

echo -e "${GREEN}✅ All images built successfully!${NC}"

# Step 2: Save images
echo ""
echo -e "${GREEN}[2/4] 💾 Saving images to files...${NC}"
mkdir -p /tmp/docker-images

docker save user-service:latest | gzip > /tmp/docker-images/user-service.tar.gz
docker save product-service:latest | gzip > /tmp/docker-images/product-service.tar.gz
docker save order-service:latest | gzip > /tmp/docker-images/order-service.tar.gz
docker save frontend:latest | gzip > /tmp/docker-images/frontend.tar.gz

echo -e "${GREEN}✅ Images saved and compressed${NC}"

# Step 3: Upload to server
echo ""
echo -e "${GREEN}[3/4] 📤 Uploading images to server (this may take a few minutes)...${NC}"

scp -i "$SSH_KEY" /tmp/docker-images/*.tar.gz "$SERVER_USER@$SERVER_IP:/tmp/"

echo -e "${GREEN}✅ Images uploaded${NC}"

# Step 4: Load on server
echo ""
echo -e "${GREEN}[4/4] 📥 Loading images on server...${NC}"

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
    cd /tmp
    
    echo "Loading user-service..."
    docker load < user-service.tar.gz
    
    echo "Loading product-service..."
    docker load < product-service.tar.gz
    
    echo "Loading order-service..."
    docker load < order-service.tar.gz
    
    echo "Loading frontend..."
    docker load < frontend.tar.gz
    
    echo ""
    echo "Cleaning up..."
    rm -f *.tar.gz
    
    echo ""
    echo "✅ All images loaded successfully!"
    echo ""
    echo "Available images:"
    docker images | grep -E "user-service|product-service|order-service|frontend"
ENDSSH

# Cleanup local files
rm -rf /tmp/docker-images

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}🎉 IMAGES DEPLOYED! 🎉${NC}                ${BLUE}║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""
echo "Now start the services on the server:"
echo "  ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP"
echo "  cd /home/ubuntu/ecommerce-app"
echo "  docker-compose up -d"
echo ""

