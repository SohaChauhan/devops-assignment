#!/bin/bash

# Build all Docker images locally

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Building Docker Images ===${NC}"

# Go to project root
cd "$(dirname "$0")/.."

# Build User Service
echo -e "${YELLOW}Building User Service...${NC}"
docker build -t user-service:latest ./backend/user-service

# Build Product Service
echo -e "${YELLOW}Building Product Service...${NC}"
docker build -t product-service:latest ./backend/product-service

# Build Order Service
echo -e "${YELLOW}Building Order Service...${NC}"
docker build -t order-service:latest ./backend/order-service

# Build Frontend
echo -e "${YELLOW}Building Frontend...${NC}"
docker build -t frontend:latest ./frontend

echo ""
echo -e "${GREEN}=== All images built successfully! ===${NC}"
echo ""
echo "Available images:"
docker images | grep -E "(user-service|product-service|order-service|frontend)"

