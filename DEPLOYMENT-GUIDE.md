# 🚀 Deployment Guide

This guide explains how to deploy your microservices application to AWS using the published Docker images.

## 📋 Prerequisites

Before deploying, ensure you have:

1. **AWS Account** with free tier access
2. **AWS CLI** installed and configured
3. **Terraform** installed (v1.0+)
4. **Docker images published** to GitHub Container Registry (automatic on push to `main`)

## 🔑 Step 1: Configure AWS Credentials

```bash
# Configure AWS CLI with your credentials
aws configure

# You'll be prompted for:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (use us-east-1 for free tier)
# - Output format (json)
```

## 📦 Step 2: Pull Docker Images from GitHub

Your CI/CD pipeline automatically publishes images to GitHub Container Registry. To use them:

```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Pull the images
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/product-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/order-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/frontend:latest
```

**Note:** Replace `YOUR_USERNAME` with your GitHub username and `YOUR_GITHUB_TOKEN` with your personal access token.

## 🏗️ Step 3: Deploy Infrastructure with Terraform

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Review the deployment plan
terraform plan

# Apply the configuration (this creates AWS resources)
terraform apply

# Type 'yes' when prompted
```

**What this creates:**
- ✅ VPC with public subnet
- ✅ EC2 t2.micro instance (free tier)
- ✅ Security groups (ports 80, 443, 22)
- ✅ K3s Kubernetes cluster
- ✅ SSH key pair for access

**Time required:** ~5-10 minutes

## 📤 Step 4: Upload Docker Images to Server

After Terraform completes, you'll get the server IP. Upload your images:

```bash
# Get the server IP from Terraform output
SERVER_IP=$(terraform output -raw server_public_ip)

# SSH into the server
ssh -i ecommerce-key.pem ubuntu@$SERVER_IP

# On the server, login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Pull images on the server
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/product-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/order-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/frontend:latest

# Tag images for K3s
docker tag ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest user-service:latest
docker tag ghcr.io/YOUR_USERNAME/devops-assignment/product-service:latest product-service:latest
docker tag ghcr.io/YOUR_USERNAME/devops-assignment/order-service:latest order-service:latest
docker tag ghcr.io/YOUR_USERNAME/devops-assignment/frontend:latest frontend:latest

# Import images to K3s
docker save user-service:latest | sudo k3s ctr images import -
docker save product-service:latest | sudo k3s ctr images import -
docker save order-service:latest | sudo k3s ctr images import -
docker save frontend:latest | sudo k3s ctr images import -
```

## ☸️ Step 5: Deploy to Kubernetes

```bash
# Still on the server, deploy to Kubernetes
cd ~/ecommerce-app

# Apply all manifests
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/user-service-deployment.yaml
kubectl apply -f k8s/product-service-deployment.yaml
kubectl apply -f k8s/order-service-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

# Check deployment status
kubectl get pods -n ecommerce
kubectl get services -n ecommerce

# Wait for all pods to be running (may take 2-3 minutes)
kubectl wait --for=condition=ready pod --all -n ecommerce --timeout=5m
```

## 🎉 Step 6: Access Your Application

```bash
# Get the server IP
echo "Your application is available at: http://$SERVER_IP"

# Test the application
curl http://$SERVER_IP
```

Open your browser and navigate to `http://YOUR_SERVER_IP`

## 🔄 Updating Your Application

When you push code to `main`, the CI/CD pipeline automatically:
1. ✅ Builds new Docker images
2. ✅ Runs security scans
3. ✅ Publishes to GitHub Container Registry

To deploy the update:

```bash
# SSH into your server
ssh -i ecommerce-key.pem ubuntu@$SERVER_IP

# Pull latest images
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/product-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/order-service:latest
docker pull ghcr.io/YOUR_USERNAME/devops-assignment/frontend:latest

# Tag and import to K3s
docker tag ghcr.io/YOUR_USERNAME/devops-assignment/user-service:latest user-service:latest
docker save user-service:latest | sudo k3s ctr images import -

# Repeat for other services...

# Restart deployments
kubectl rollout restart deployment/user-service -n ecommerce
kubectl rollout restart deployment/product-service -n ecommerce
kubectl rollout restart deployment/order-service -n ecommerce
kubectl rollout restart deployment/frontend -n ecommerce

# Verify rollout
kubectl rollout status deployment/user-service -n ecommerce
```

## 🧹 Cleanup (Destroy Resources)

To avoid AWS charges, destroy resources when done:

```bash
cd terraform
terraform destroy

# Type 'yes' when prompted
```

This removes all AWS resources and stops any charges.

## 📊 CI/CD Pipeline Summary

Your simplified pipeline does:

| Step | What It Does | Runs On |
|------|-------------|---------|
| **Code Quality** | ESLint + npm audit | Every push |
| **Build** | Builds all Docker images | Every push |
| **Security Scan** | Trivy container scan | Every push |
| **Terraform Validate** | Validates IaC | Every push |
| **Publish** | Pushes to GitHub Registry | Push to `main` only |

**Pipeline runs automatically on every push - no manual intervention needed!**

## 🆘 Troubleshooting

### Images not found on server
```bash
# Ensure you're logged into GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

### Pods not starting
```bash
# Check pod logs
kubectl logs <pod-name> -n ecommerce

# Check events
kubectl get events -n ecommerce --sort-by='.lastTimestamp'
```

### Can't connect to server
```bash
# Verify security group rules in AWS console
# Ensure port 80 is open to 0.0.0.0/0
```

## 📚 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [K3s Documentation](https://docs.k3s.io/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

**Questions?** Check the README.md or open an issue on GitHub.

