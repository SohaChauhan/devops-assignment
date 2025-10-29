#!/bin/bash

# Quick Deploy Script - Ultra Fast Deployment
# Uses Git to sync code to server in seconds!

set -e

# Configuration
SERVER_IP="${SERVER_IP:-34.199.190.209}"
SSH_KEY="${SSH_KEY:-~/.ssh/id_rsa}"
SERVER_USER="ubuntu"
APP_DIR="/home/ubuntu/ecommerce-app"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Quick Deploy Starting...${NC}"
echo ""

# Check if Git is initialized
if [ ! -d .git ]; then
    echo -e "${RED}❌ Error: Not a git repository${NC}"
    echo "Run: git init && git add . && git commit -m 'Initial commit'"
    exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}📝 Uncommitted changes detected${NC}"
    read -p "Commit all changes? (y/n): " commit_choice
    
    if [ "$commit_choice" = "y" ]; then
        echo -e "${GREEN}📦 Staging changes...${NC}"
        git add .
        
        read -p "Commit message (default: 'Quick deploy'): " commit_msg
        commit_msg=${commit_msg:-"Quick deploy: $(date +%Y-%m-%d\ %H:%M:%S)"}
        
        git commit -m "$commit_msg"
    fi
fi

# Push to GitHub
echo -e "${GREEN}📤 Pushing to GitHub...${NC}"
if git push origin main; then
    echo -e "${GREEN}✅ Pushed to GitHub${NC}"
else
    echo -e "${YELLOW}⚠️  Push failed or no changes to push${NC}"
fi

# Pull on server
echo -e "${GREEN}📥 Updating code on server...${NC}"
echo ""

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
    cd /home/ubuntu/ecommerce-app
    
    echo "📥 Pulling latest changes..."
    if git pull; then
        echo "✅ Code updated successfully!"
    else
        echo "⚠️  Git pull failed or no changes"
        exit 1
    fi
    
    echo ""
    echo "📊 Latest commits:"
    git log --oneline -5
ENDSSH

echo ""
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. SSH to server: ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP"
echo "  2. Rebuild services: cd ecommerce-app && docker-compose up -d --build"
echo "  3. Check status: docker-compose ps"
echo ""
echo -e "${GREEN}✨ Deploy completed in record time! ⚡${NC}"

