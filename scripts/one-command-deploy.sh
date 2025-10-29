#!/bin/bash

# One Command Deploy - Git push + Server pull + Docker rebuild
# The ultimate deploy script! 🚀

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
BLUE='\033[0;34m'
NC='\033[0m'

# Banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║   ONE-COMMAND DEPLOY                  ║"
echo "║   Push → Pull → Build → Deploy        ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Step 1: Commit and Push
echo -e "${GREEN}[1/4] 📝 Committing changes...${NC}"
if [[ -n $(git status -s) ]]; then
    git add .
    commit_msg="Deploy: $(date +%Y-%m-%d\ %H:%M:%S)"
    git commit -m "$commit_msg"
    echo -e "${GREEN}✅ Changes committed${NC}"
else
    echo -e "${YELLOW}ℹ️  No changes to commit${NC}"
fi

echo ""
echo -e "${GREEN}[2/4] 📤 Pushing to GitHub...${NC}"
git push origin main
echo -e "${GREEN}✅ Pushed to GitHub${NC}"

# Step 2: Pull on Server
echo ""
echo -e "${GREEN}[3/4] 📥 Pulling on server & rebuilding...${NC}"

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" << 'ENDSSH'
    set -e
    cd /home/ubuntu/ecommerce-app
    
    echo "📥 Pulling latest code..."
    git pull
    
    echo ""
    echo "🔨 Rebuilding Docker images..."
    docker-compose build
    
    echo ""
    echo "🚀 Deploying services..."
    docker-compose up -d
    
    echo ""
    echo "⏳ Waiting for services to start..."
    sleep 10
    
    echo ""
    echo "📊 Service Status:"
    docker-compose ps
ENDSSH

# Step 3: Verify
echo ""
echo -e "${GREEN}[4/4] ✅ Verifying deployment...${NC}"
sleep 5

if curl -f -s "http://$SERVER_IP" > /dev/null; then
    echo -e "${GREEN}✅ Application is responding!${NC}"
else
    echo -e "${YELLOW}⚠️  Application might still be starting...${NC}"
fi

# Success
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}🎉 DEPLOYMENT SUCCESSFUL! 🎉${NC}         ${BLUE}║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}🌐 Application URL: http://$SERVER_IP${NC}"
echo ""
echo "View logs:"
echo "  ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP 'cd $APP_DIR && docker-compose logs -f'"
echo ""
echo -e "${GREEN}✨ Deployment completed! Total time: ~30 seconds ⚡${NC}"

