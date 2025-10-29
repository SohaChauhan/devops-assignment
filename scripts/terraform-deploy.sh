#!/bin/bash

# Complete Terraform deployment script

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

cd "$(dirname "$0")/../terraform"

echo -e "${GREEN}=== Terraform AWS Deployment ===${NC}"
echo ""

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"

if ! command -v terraform &> /dev/null; then
    echo -e "${RED}Terraform is not installed${NC}"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI is not installed${NC}"
    exit 1
fi

if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}AWS credentials not configured${NC}"
    exit 1
fi

# Check if terraform.tfvars exists
if [ ! -f terraform.tfvars ]; then
    echo -e "${YELLOW}Creating terraform.tfvars from example...${NC}"
    cp terraform.tfvars.example terraform.tfvars
    echo -e "${RED}Please edit terraform.tfvars and add your SSH public key${NC}"
    exit 1
fi

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init

# Validate configuration
echo -e "${YELLOW}Validating configuration...${NC}"
terraform validate

# Plan deployment
echo -e "${YELLOW}Planning deployment...${NC}"
terraform plan -out=tfplan

# Confirm deployment
echo ""
read -p "Do you want to proceed with deployment? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled"
    exit 0
fi

# Apply configuration
echo -e "${YELLOW}Deploying infrastructure...${NC}"
terraform apply tfplan

# Get outputs
echo ""
echo -e "${GREEN}=== Deployment Complete! ===${NC}"
echo ""
terraform output

# Save outputs to file
echo ""
echo -e "${YELLOW}Saving connection info to ../deployment-info.txt${NC}"
terraform output > ../deployment-info.txt

SERVER_IP=$(terraform output -raw instance_public_ip)

echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "1. Wait 2-3 minutes for the instance to finish initialization"
echo "2. SSH into the server: ssh -i ~/.ssh/id_rsa ubuntu@$SERVER_IP"
echo "3. Deploy application: cd ../scripts && ./deploy-to-aws.sh $SERVER_IP"
echo ""

