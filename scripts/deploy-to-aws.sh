#!/bin/bash

# Deployment script for E-Commerce Microservices to AWS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if IP is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP address is required${NC}"
    echo "Usage: ./deploy-to-aws.sh <server-ip>"
    exit 1
fi

SERVER_IP=$1
SSH_KEY=${2:-~/.ssh/id_rsa}
SERVER_USER="ubuntu"

echo -e "${GREEN}=== E-Commerce Microservices Deployment ===${NC}"
echo "Server: $SERVER_IP"
echo "SSH Key: $SSH_KEY"
echo ""

# Test SSH connection
echo -e "${YELLOW}Testing SSH connection...${NC}"
if ! ssh -i "$SSH_KEY" -o ConnectTimeout=10 "$SERVER_USER@$SERVER_IP" "echo 'SSH connection successful'"; then
    echo -e "${RED}Failed to connect to server${NC}"
    exit 1
fi

# Upload application code
echo -e "${YELLOW}Uploading application code...${NC}"
rsync -avz --progress \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'build' \
    --exclude 'dist' \
    -e "ssh -i $SSH_KEY" \
    ../ "$SERVER_USER@$SERVER_IP:/home/ubuntu/ecommerce-app/"

# Build and deploy
echo -e "${YELLOW}Building Docker images and deploying to Kubernetes...${NC}"
ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
cd /home/ubuntu/ecommerce-app

echo "Building Docker images..."
docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

echo "Importing images to K3s..."
docker save user-service:latest | sudo k3s ctr images import -
docker save product-service:latest | sudo k3s ctr images import -
docker save order-service:latest | sudo k3s ctr images import -
docker save frontend:latest | sudo k3s ctr images import -

echo "Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
sleep 15
kubectl apply -f k8s/user-service-deployment.yaml
kubectl apply -f k8s/product-service-deployment.yaml
kubectl apply -f k8s/order-service-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n ecommerce || true
kubectl wait --for=condition=available --timeout=300s deployment/user-service -n ecommerce || true
kubectl wait --for=condition=available --timeout=300s deployment/product-service -n ecommerce || true
kubectl wait --for=condition=available --timeout=300s deployment/order-service -n ecommerce || true
kubectl wait --for=condition=available --timeout=300s deployment/frontend -n ecommerce || true

echo ""
echo "Deployment Status:"
kubectl get pods -n ecommerce
echo ""
kubectl get svc -n ecommerce
ENDSSH

# Get the LoadBalancer IP or NodePort
echo ""
echo -e "${GREEN}=== Deployment Complete! ===${NC}"
echo ""
echo "Access your application at:"
echo "  Frontend: http://$SERVER_IP"
echo ""
echo "Check deployment status:"
echo "  ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP 'kubectl get pods -n ecommerce'"
echo ""
echo "View logs:"
echo "  ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP 'kubectl logs -n ecommerce -l app=user-service'"
echo ""

