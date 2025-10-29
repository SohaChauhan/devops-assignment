#!/bin/bash

# Deploy application using docker-compose

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

cd "$(dirname "$0")/.."

echo -e "${GREEN}=== Starting E-Commerce Application (Docker Compose) ===${NC}"

# Build and start containers
echo -e "${YELLOW}Building and starting containers...${NC}"
docker-compose up -d --build

# Wait for services to be healthy
echo -e "${YELLOW}Waiting for services to be ready...${NC}"
sleep 10

# Check status
echo ""
echo -e "${GREEN}=== Container Status ===${NC}"
docker-compose ps

echo ""
echo -e "${GREEN}=== Application URLs ===${NC}"
echo "Frontend:        http://localhost"
echo "User Service:    http://localhost:3001"
echo "Product Service: http://localhost:3002"
echo "Order Service:   http://localhost:3003"
echo ""
echo "View logs: docker-compose logs -f"
echo "Stop: docker-compose down"

