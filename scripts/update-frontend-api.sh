#!/bin/bash

# Update frontend API URLs for production deployment

set -e

if [ -z "$1" ]; then
    echo "Error: Server IP address is required"
    echo "Usage: ./update-frontend-api.sh <server-ip>"
    exit 1
fi

SERVER_IP=$1

echo "Updating frontend API URLs to use $SERVER_IP..."

# Update API URLs in React components
find frontend/src/components -type f -name "*.js" -exec sed -i.bak \
    -e "s|http://localhost:3001|http://$SERVER_IP:3001|g" \
    -e "s|http://localhost:3002|http://$SERVER_IP:3002|g" \
    -e "s|http://localhost:3003|http://$SERVER_IP:3003|g" \
    {} \;

# Clean up backup files
find frontend/src/components -type f -name "*.bak" -delete

echo "API URLs updated successfully!"
echo "Rebuild frontend: docker build -t frontend:latest ./frontend"

