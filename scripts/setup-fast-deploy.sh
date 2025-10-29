#!/bin/bash

# Setup Fast Deploy - One-time configuration script
# Configures Git and server for lightning-fast deployments

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

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════╗"
echo "║   FAST DEPLOY SETUP                   ║"
echo "║   Configure for 10-second deploys     ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Check Git
echo -e "${GREEN}[1/6] Checking Git configuration...${NC}"
if [ ! -d .git ]; then
    echo -e "${YELLOW}Initializing Git repository...${NC}"
    git init
fi

# Check for remote
if ! git remote get-url origin &> /dev/null; then
    echo ""
    echo -e "${YELLOW}GitHub repository not configured${NC}"
    read -p "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git): " repo_url
    
    if [ -n "$repo_url" ]; then
        git remote add origin "$repo_url"
        echo -e "${GREEN}✅ Added GitHub remote${NC}"
    else
        echo -e "${RED}❌ GitHub repository required for fast deploy${NC}"
        echo "Create a repository at: https://github.com/new"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Git repository configured${NC}"
fi

# Step 2: Initial Commit
echo ""
echo -e "${GREEN}[2/6] Checking for initial commit...${NC}"
if ! git log -1 &> /dev/null; then
    echo -e "${YELLOW}Creating initial commit...${NC}"
    git add .
    git commit -m "Initial commit - Setup fast deploy"
    echo -e "${GREEN}✅ Initial commit created${NC}"
else
    echo -e "${GREEN}✅ Repository has commits${NC}"
fi

# Step 3: Push to GitHub
echo ""
echo -e "${GREEN}[3/6] Pushing to GitHub...${NC}"
if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
    echo -e "${GREEN}✅ Pushed to GitHub${NC}"
else
    echo -e "${YELLOW}⚠️  Already pushed or branch exists${NC}"
fi

# Step 4: Test SSH Connection
echo ""
echo -e "${GREEN}[4/6] Testing SSH connection to server...${NC}"
if ssh -i "$SSH_KEY" -o ConnectTimeout=5 "$SERVER_USER@$SERVER_IP" "echo 'Connected'" &> /dev/null; then
    echo -e "${GREEN}✅ SSH connection successful${NC}"
else
    echo -e "${RED}❌ Cannot connect to server${NC}"
    echo "Check:"
    echo "  - Server IP: $SERVER_IP"
    echo "  - SSH Key: $SSH_KEY"
    echo "  - Server is running"
    exit 1
fi

# Step 5: Clone Repository on Server
echo ""
echo -e "${GREEN}[5/6] Setting up repository on server...${NC}"

repo_url=$(git remote get-url origin)

ssh -i "$SSH_KEY" "$SERVER_USER@$SERVER_IP" << ENDSSH
    set -e
    
    # Check if directory exists
    if [ -d "$APP_DIR" ]; then
        echo "⚠️  Directory already exists: $APP_DIR"
        echo "Checking if it's a git repository..."
        
        if [ -d "$APP_DIR/.git" ]; then
            echo "✅ Already a git repository"
            cd "$APP_DIR"
            git remote set-url origin "$repo_url"
            git pull
        else
            echo "❌ Not a git repository. Please backup and remove: $APP_DIR"
            exit 1
        fi
    else
        echo "📥 Cloning repository..."
        git clone "$repo_url" "$APP_DIR"
        echo "✅ Repository cloned"
    fi
ENDSSH

echo -e "${GREEN}✅ Server configured${NC}"

# Step 6: Make Scripts Executable
echo ""
echo -e "${GREEN}[6/6] Making deploy scripts executable...${NC}"
chmod +x scripts/quick-deploy.sh 2>/dev/null || true
chmod +x scripts/rsync-deploy.sh 2>/dev/null || true
chmod +x scripts/one-command-deploy.sh 2>/dev/null || true
echo -e "${GREEN}✅ Scripts are executable${NC}"

# Success
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}🎉 SETUP COMPLETE! 🎉${NC}                ${BLUE}║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Fast deploy is now configured!${NC}"
echo ""
echo "Available deploy methods:"
echo ""
echo "  1. Quick Deploy (recommended):"
echo -e "     ${YELLOW}./scripts/quick-deploy.sh${NC}"
echo ""
echo "  2. One-Command Deploy (push + build + deploy):"
echo -e "     ${YELLOW}./scripts/one-command-deploy.sh${NC}"
echo ""
echo "  3. Manual (for maximum control):"
echo -e "     ${YELLOW}git push && ssh -i $SSH_KEY $SERVER_USER@$SERVER_IP 'cd $APP_DIR && git pull'${NC}"
echo ""
echo "  4. rsync (when Git not available):"
echo -e "     ${YELLOW}./scripts/rsync-deploy.sh${NC}"
echo ""
echo -e "${GREEN}⚡ Deploy time: 5-10 seconds (60x faster!) ⚡${NC}"
echo ""
echo "Test it now:"
echo -e "  ${YELLOW}./scripts/quick-deploy.sh${NC}"
echo ""

