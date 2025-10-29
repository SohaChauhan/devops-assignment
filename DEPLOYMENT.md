# Deployment Guide

Complete guide for deploying the E-Commerce Microservices application using Docker, Kubernetes, and AWS.

## Table of Contents

1. [Local Development with Docker Compose](#local-development)
2. [AWS Deployment with Terraform + Kubernetes](#aws-deployment)
3. [Manual Kubernetes Deployment](#manual-kubernetes)
4. [CI/CD Pipeline Setup](#cicd-setup)

---

## Local Development with Docker Compose

### Quick Start

```bash
# Build and start all services
./scripts/local-deploy.sh

# Or manually
docker-compose up -d --build
```

### Access Services

- Frontend: http://localhost
- User Service: http://localhost:3001
- Product Service: http://localhost:3002
- Order Service: http://localhost:3003
- MongoDB: mongodb://localhost:27017

### Useful Commands

```bash
# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f user-service

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Rebuild specific service
docker-compose up -d --build user-service
```

---

## AWS Deployment with Terraform + Kubernetes

### Prerequisites

1. **AWS Account** (Free Tier eligible)
2. **AWS CLI** configured
3. **Terraform** installed
4. **SSH Key** generated

### Step 1: Setup AWS Credentials

```bash
aws configure
# AWS Access Key ID: YOUR_KEY
# AWS Secret Access Key: YOUR_SECRET
# Default region: us-east-1
```

### Step 2: Configure Terraform Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
ssh_public_key = "ssh-rsa AAAAB3... your@email.com"
```

Get your public key:
```bash
cat ~/.ssh/id_rsa.pub
```

### Step 3: Deploy Infrastructure

**Automated:**
```bash
./scripts/terraform-deploy.sh
```

**Manual:**
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Step 4: Wait for Initialization

The EC2 instance needs 2-3 minutes to install K3s and Docker.

Check status:
```bash
# Get the IP from terraform output
SERVER_IP=$(cd terraform && terraform output -raw instance_public_ip)

# SSH into the server
ssh -i ~/.ssh/id_rsa ubuntu@$SERVER_IP

# Check if K3s is ready
sudo systemctl status k3s

# Exit
exit
```

### Step 5: Deploy Application

```bash
./scripts/deploy-to-aws.sh <SERVER_IP>
```

### Step 6: Access Application

```
http://<SERVER_IP>
```

### Monitoring

```bash
# SSH into server
ssh -i ~/.ssh/id_rsa ubuntu@<SERVER_IP>

# Check pods
kubectl get pods -n ecommerce

# Check services
kubectl get svc -n ecommerce

# View logs
kubectl logs -n ecommerce -l app=user-service --tail=50

# Check node resources
kubectl top nodes
kubectl top pods -n ecommerce
```

### Updating the Application

1. Make changes to your code
2. Run deployment script again:
```bash
./scripts/deploy-to-aws.sh <SERVER_IP>
```

### Scaling Services

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<SERVER_IP>

# Scale user service to 3 replicas
kubectl scale deployment user-service -n ecommerce --replicas=3

# Check scaling
kubectl get pods -n ecommerce
```

### Cleanup

```bash
cd terraform
terraform destroy
```

---

## Manual Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (minikube, k3s, or cloud provider)
- kubectl configured
- Docker images built

### Step 1: Build Docker Images

```bash
./scripts/build-images.sh
```

### Step 2: Load Images (for local k8s)

For minikube:
```bash
eval $(minikube docker-env)
./scripts/build-images.sh
```

For k3s:
```bash
docker save user-service:latest | sudo k3s ctr images import -
docker save product-service:latest | sudo k3s ctr images import -
docker save order-service:latest | sudo k3s ctr images import -
docker save frontend:latest | sudo k3s ctr images import -
```

### Step 3: Deploy to Kubernetes

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy MongoDB
kubectl apply -f k8s/mongodb-deployment.yaml

# Wait for MongoDB to be ready
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n ecommerce

# Deploy services
kubectl apply -f k8s/user-service-deployment.yaml
kubectl apply -f k8s/product-service-deployment.yaml
kubectl apply -f k8s/order-service-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml

# Check status
kubectl get all -n ecommerce
```

### Step 4: Access Application

Get the frontend service URL:

```bash
# For LoadBalancer (cloud providers)
kubectl get svc -n ecommerce frontend

# For NodePort (local k8s)
kubectl get svc -n ecommerce frontend
# Access at: http://<NODE_IP>:<NODE_PORT>

# For minikube
minikube service frontend -n ecommerce
```

### Step 5: Setup Ingress (Optional)

```bash
# Install ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# Deploy ingress
kubectl apply -f k8s/ingress.yaml

# Get ingress IP
kubectl get ingress -n ecommerce
```

---

## CI/CD Pipeline Setup

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Deploy to AWS
        env:
          SERVER_IP: ${{ secrets.SERVER_IP }}
          SSH_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        run: |
          echo "$SSH_KEY" > key.pem
          chmod 600 key.pem
          ./scripts/deploy-to-aws.sh $SERVER_IP key.pem
```

---

## Troubleshooting

### Issue: Pods in CrashLoopBackOff

```bash
# Check pod logs
kubectl logs -n ecommerce <pod-name>

# Describe pod for events
kubectl describe pod -n ecommerce <pod-name>

# Check if MongoDB is ready
kubectl get pods -n ecommerce | grep mongodb
```

### Issue: Can't access application

```bash
# Check service
kubectl get svc -n ecommerce frontend

# Check if pods are running
kubectl get pods -n ecommerce

# Check ingress (if using)
kubectl get ingress -n ecommerce
kubectl describe ingress -n ecommerce ecommerce-ingress
```

### Issue: Out of memory on t2.micro

```bash
# Reduce replicas
kubectl scale deployment user-service -n ecommerce --replicas=1
kubectl scale deployment product-service -n ecommerce --replicas=1
kubectl scale deployment order-service -n ecommerce --replicas=1
kubectl scale deployment frontend -n ecommerce --replicas=1

# Or update resource limits in deployment files
```

### Issue: Can't connect to MongoDB

```bash
# Check MongoDB pod
kubectl get pods -n ecommerce | grep mongodb

# Check MongoDB logs
kubectl logs -n ecommerce <mongodb-pod-name>

# Exec into MongoDB pod
kubectl exec -it -n ecommerce <mongodb-pod-name> -- mongosh

# Test connection from service pod
kubectl exec -it -n ecommerce <user-service-pod> -- sh
nc -zv mongodb 27017
```

---

## Production Checklist

- [ ] Change JWT_SECRET to secure random value
- [ ] Update MongoDB to use authentication
- [ ] Setup HTTPS with SSL certificates
- [ ] Configure domain name
- [ ] Setup monitoring (Prometheus/Grafana)
- [ ] Configure log aggregation
- [ ] Setup automated backups
- [ ] Implement rate limiting
- [ ] Add API authentication
- [ ] Configure CORS properly
- [ ] Setup alerts
- [ ] Document runbooks
- [ ] Test disaster recovery

---

## Cost Optimization

### AWS Free Tier Limits

- **EC2**: 750 hours/month of t2.micro (12 months)
- **EBS**: 30 GB General Purpose SSD (12 months)
- **Data Transfer**: 15 GB outbound per month

### Tips to Stay Free

1. Use only one t2.micro instance
2. Don't exceed 30 GB storage
3. Delete snapshots regularly
4. Stop instance when not needed
5. Monitor billing dashboard daily
6. Set up billing alerts

### Alternative Free Options

1. **Oracle Cloud**: Always Free tier with 2 VMs
2. **Google Cloud**: $300 credit for 90 days
3. **Azure**: $200 credit for 30 days
4. **DigitalOcean**: $200 credit for 60 days

---

## Support and Resources

- **Kubernetes Docs**: https://kubernetes.io/docs/
- **Terraform AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/
- **K3s Documentation**: https://docs.k3s.io/
- **Docker Documentation**: https://docs.docker.com/

---

**Happy Deploying! 🚀**

