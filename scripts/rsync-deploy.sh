#!/bin/bash

# rsync Deploy Script - Faster than scp, only uploads changed files
# Perfect for when you can't use Git

set -e

# Configuration
SERVER_IP="${SERVER_IP:-34.199.190.209}"
SSH_KEY="${SSH_KEY:-~/.ssh/id_rsa}"
SERVER_USER="ubuntu"
APP_DIR="/home/ubuntu/ecommerce-app"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 rsync Deployment Starting...${NC}"
echo ""

# Check if rsync is available
if ! command -v rsync &> /dev/null; then
    echo -e "${YELLOW}⚠️  rsync not found. Installing...${NC}"
    # On Windows with Git Bash, rsync might not be available
    echo "Please install rsync or use Git deployment method"
    exit 1
fi

# Test SSH connection
echo -e "${YELLOW}🔗 Testing SSH connection...${NC}"
if ssh -i "$SSH_KEY" -o ConnectTimeout=5 "$SERVER_USER@$SERVER_IP" "echo 'Connected'"; then
    echo -e "${GREEN}✅ SSH connection successful${NC}"
else
    echo -e "${RED}❌ Cannot connect to server${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}📤 Syncing files (this will be fast after first sync)...${NC}"
echo ""

# Sync files using rsync
rsync -avz --progress \
  --exclude 'node_modules' \
  --exclude '.git' \
  --exclude 'build' \
  --exclude 'dist' \
  --exclude '*.log' \
  --exclude '.env' \
  --exclude '.env.*' \
  --exclude 'terraform/.terraform' \
  --exclude 'terraform/*.tfstate' \
  --exclude 'terraform/*.tfstate.backup' \
  --exclude 'terraform/.terraform.lock.hcl' \
  --exclude '*.tar.gz' \
  --exclude 'coverage' \
  --exclude '.cache' \
  --exclude '.DS_Store' \
  --exclude 'Thumbs.db' \
  -e "ssh -i $SSH_KEY" \
  ./ "$SERVER_USER@$SERVER_IP:$APP_DIR/"

echo ""
echo -e "${GREEN}✅ Sync complete!${NC}"
echo ""
echo "Files synced to: $SERVER_USER@$SERVER_IP:$APP_DIR/"
echo ""
echo "Next steps:"
echo "  1. SSH to server: ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP"
echo "  2. Install dependencies: cd $APP_DIR && npm install"
echo "  3. Rebuild services: docker-compose up -d --build"
echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"

