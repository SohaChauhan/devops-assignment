# Complete Docker, Kubernetes & AWS Deployment - FREE TIER

## 🎉 What's Been Created

Your E-Commerce Microservices application is now fully dockerized and ready for Kubernetes deployment on AWS - **completely FREE** using AWS Free Tier!

---

## 📦 What You Have Now

### ✅ Dockerization Complete
- **4 Dockerfiles** (one for each service)
- **docker-compose.yml** for local development
- **Multi-stage builds** for optimized images
- **.dockerignore** for faster builds

### ✅ Kubernetes Manifests
- **Namespace** configuration
- **Deployments** for all services (MongoDB, User, Product, Order, Frontend)
- **Services** (ClusterIP and LoadBalancer)
- **ConfigMaps** for environment variables
- **Secrets** for sensitive data
- **PersistentVolumeClaim** for MongoDB data
- **Ingress** for routing
- **Health checks** and **resource limits**

### ✅ Terraform Infrastructure (AWS Free Tier)
- **VPC** with public subnet
- **EC2 t2.micro** instance (Free Tier eligible)
- **Security Groups** with required ports
- **Elastic IP** for static address
- **Automated K3s installation**
- **User data script** for server setup

### ✅ Deployment Scripts
- `build-images.sh` - Build all Docker images
- `local-deploy.sh` - Deploy locally with Docker Compose
- `deploy-to-aws.sh` - Deploy to AWS server
- `terraform-deploy.sh` - Complete Terraform deployment
- `update-frontend-api.sh` - Update API URLs for production

### ✅ Documentation
- **README.md** - Main project documentation
- **QUICKSTART.md** - Get started in 5 minutes
- **DEPLOYMENT.md** - Complete deployment guide
- **API_EXAMPLES.md** - API usage examples
- **terraform/README.md** - Infrastructure details

---

## 🚀 Quick Start Options

### Option 1: Test Locally (Fastest - 5 minutes)

```bash
# Start everything with Docker Compose
docker-compose up -d --build

# Access at http://localhost
```

### Option 2: Deploy to AWS FREE (15 minutes)

```bash
# 1. Configure AWS credentials
aws configure

# 2. Setup Terraform
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars - add your SSH public key

# 3. Deploy infrastructure
terraform init
terraform apply

# 4. Wait 2-3 minutes for initialization

# 5. Get server IP
SERVER_IP=$(terraform output -raw instance_public_ip)

# 6. Deploy application
cd ..
./scripts/deploy-to-aws.sh $SERVER_IP

# 7. Access at http://<SERVER_IP>
```

---

## 💰 AWS Free Tier Details

### What's Free for 12 Months:
✅ **EC2 t2.micro**: 750 hours/month (enough for 1 instance 24/7)  
✅ **EBS Storage**: 30 GB General Purpose SSD  
✅ **Data Transfer**: 15 GB outbound per month  
✅ **Elastic IP**: Free when attached to running instance  

### Our Setup Uses:
- 1x t2.micro instance = ~720 hours/month ✅
- 30 GB EBS volume ✅
- 1 Elastic IP ✅
- Minimal data transfer ✅

**Result: $0.00/month for 12 months!** 🎉

### After 12 Months:
- t2.micro: ~$8.50/month
- 30 GB EBS: ~$3/month
- **Total: ~$12/month**

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│              AWS FREE TIER DEPLOYMENT                │
│                                                       │
│  ┌─────────────────────────────────────────────┐    │
│  │   EC2 Instance (t2.micro - FREE)            │    │
│  │                                               │    │
│  │   ┌─────────────────────────────────────┐   │    │
│  │   │   K3s Kubernetes Cluster            │   │    │
│  │   │                                       │   │    │
│  │   │  ┌─────────┐  ┌──────────────────┐  │   │    │
│  │   │  │ MongoDB │  │   Microservices  │  │   │    │
│  │   │  │  (1 Pod)│  │                  │  │   │    │
│  │   │  └─────────┘  │  • User (2 pods) │  │   │    │
│  │   │               │  • Product (2)    │  │   │    │
│  │   │  ┌─────────┐  │  • Order (2)     │  │   │    │
│  │   │  │Frontend │  │  • Frontend (2)  │  │   │    │
│  │   │  │ (Nginx) │  │                  │  │   │    │
│  │   │  └─────────┘  └──────────────────┘  │   │    │
│  │   └─────────────────────────────────────┘   │    │
│  │                                               │    │
│  └───────────────────┬───────────────────────────┘    │
│                      │                                │
│              Elastic IP (Static)                      │
└──────────────────────┼────────────────────────────────┘
                       │
                Internet Access
                       │
                  Your Browser
```

---

## 📁 Project Structure

```
devops-assignment/
├── backend/
│   ├── user-service/
│   │   ├── Dockerfile              ✨ NEW
│   │   ├── server.js
│   │   ├── models/
│   │   ├── controllers/
│   │   └── routes/
│   ├── product-service/
│   │   ├── Dockerfile              ✨ NEW
│   │   └── ...
│   └── order-service/
│       ├── Dockerfile              ✨ NEW
│       └── ...
├── frontend/
│   ├── Dockerfile                  ✨ NEW
│   ├── nginx.conf                  ✨ NEW
│   └── src/
├── k8s/                            ✨ NEW
│   ├── namespace.yaml
│   ├── mongodb-deployment.yaml
│   ├── user-service-deployment.yaml
│   ├── product-service-deployment.yaml
│   ├── order-service-deployment.yaml
│   ├── frontend-deployment.yaml
│   └── ingress.yaml
├── terraform/                      ✨ NEW
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── user-data.sh
│   ├── terraform.tfvars.example
│   └── README.md
├── scripts/                        ✨ NEW
│   ├── build-images.sh
│   ├── local-deploy.sh
│   ├── deploy-to-aws.sh
│   ├── terraform-deploy.sh
│   └── update-frontend-api.sh
├── docker-compose.yml              ✨ NEW
├── .dockerignore                   ✨ NEW
├── README.md
├── QUICKSTART.md                   ✨ NEW
├── DEPLOYMENT.md                   ✨ NEW
└── API_EXAMPLES.md
```

---

## 🎯 Step-by-Step Deployment Guide

### For Windows Users

1. **Install Prerequisites:**
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [AWS CLI](https://aws.amazon.com/cli/)
   - [Terraform](https://www.terraform.io/downloads)
   - [Git Bash](https://git-scm.com/downloads) (for running scripts)

2. **Generate SSH Key:**
   ```bash
   # In Git Bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

3. **Configure AWS:**
   ```bash
   aws configure
   ```

4. **Deploy:**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit in Notepad and add SSH key
   terraform init
   terraform apply
   
   # Get IP
   terraform output instance_public_ip
   
   # Deploy app (in Git Bash)
   cd ..
   bash scripts/deploy-to-aws.sh <IP>
   ```

### For Mac/Linux Users

1. **Install Prerequisites:**
   ```bash
   # Mac
   brew install awscli terraform
   
   # Linux
   sudo apt install awscli terraform
   ```

2. **Generate SSH Key:**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

3. **Deploy:**
   ```bash
   aws configure
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   nano terraform.tfvars  # Add SSH key
   ./scripts/terraform-deploy.sh
   ```

---

## 🔧 Useful Commands Cheat Sheet

### Docker Compose (Local)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f [service-name]

# Stop all
docker-compose down

# Rebuild
docker-compose up -d --build

# Remove everything including volumes
docker-compose down -v
```

### Kubernetes

```bash
# Get all resources
kubectl get all -n ecommerce

# Get pods
kubectl get pods -n ecommerce

# View pod logs
kubectl logs -n ecommerce <pod-name> -f

# Describe pod
kubectl describe pod -n ecommerce <pod-name>

# Execute into pod
kubectl exec -it -n ecommerce <pod-name> -- sh

# Scale deployment
kubectl scale deployment <name> -n ecommerce --replicas=3

# Restart deployment
kubectl rollout restart deployment <name> -n ecommerce

# Delete namespace (removes everything)
kubectl delete namespace ecommerce
```

### Terraform

```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy everything
terraform destroy

# Show outputs
terraform output

# Format files
terraform fmt

# Validate config
terraform validate
```

### AWS CLI

```bash
# List EC2 instances
aws ec2 describe-instances

# Get security groups
aws ec2 describe-security-groups

# Check billing
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-31 --granularity MONTHLY --metrics BlendedCost
```

---

## 🛡️ Security Checklist

Before production:

- [ ] Change JWT_SECRET to random secure value
- [ ] Enable MongoDB authentication
- [ ] Setup SSL/TLS certificates (Let's Encrypt)
- [ ] Configure firewall rules
- [ ] Restrict SSH to specific IPs
- [ ] Enable CloudWatch logging
- [ ] Setup automated backups
- [ ] Use AWS Secrets Manager
- [ ] Enable MFA on AWS account
- [ ] Setup IAM roles properly
- [ ] Review security group rules
- [ ] Enable AWS CloudTrail
- [ ] Add rate limiting
- [ ] Implement CORS properly

---

## 📊 Monitoring

### Application Health

```bash
# Check service health
curl http://<SERVER_IP>:3001/health
curl http://<SERVER_IP>:3002/health
curl http://<SERVER_IP>:3003/health
```

### Kubernetes Metrics

```bash
kubectl top nodes
kubectl top pods -n ecommerce
kubectl get events -n ecommerce
```

### AWS Monitoring

- CloudWatch Logs
- CloudWatch Metrics
- Cost Explorer
- Free Tier usage dashboard

---

## 🚨 Troubleshooting

### Common Issues

**1. Can't connect to AWS instance**
```bash
# Check security group allows your IP
# Verify SSH key
ssh -i ~/.ssh/id_rsa ubuntu@<IP> -v
```

**2. Pods not starting**
```bash
kubectl describe pod -n ecommerce <pod-name>
kubectl logs -n ecommerce <pod-name>
```

**3. Out of memory (t2.micro)**
```bash
# Reduce replicas
kubectl scale deployment --all --replicas=1 -n ecommerce
```

**4. MongoDB connection issues**
```bash
# Check if MongoDB pod is running
kubectl get pods -n ecommerce | grep mongodb
# Check MongoDB logs
kubectl logs -n ecommerce <mongodb-pod>
```

---

## 💡 Pro Tips

1. **Monitor AWS Costs Daily**
   - Set up billing alerts at $1, $5, $10
   - Check Free Tier usage weekly

2. **Backup Regularly**
   ```bash
   # Backup MongoDB
   kubectl exec -n ecommerce <mongodb-pod> -- mongodump --archive=/tmp/backup.gz --gzip
   kubectl cp ecommerce/<mongodb-pod>:/tmp/backup.gz ./backup.gz
   ```

3. **Stop Instance When Not Needed**
   ```bash
   aws ec2 stop-instances --instance-ids <instance-id>
   aws ec2 start-instances --instance-ids <instance-id>
   ```

4. **Use CloudWatch for Logs**
   - Install CloudWatch agent on EC2
   - Centralize all application logs

5. **Enable Auto-Scaling** (after free tier)
   - Use Horizontal Pod Autoscaler
   - Configure based on CPU/Memory

---

## 🎓 Next Steps

1. **Test Locally First**
   - Run `docker-compose up -d`
   - Test all features
   - Fix any issues

2. **Deploy to AWS**
   - Follow QUICKSTART.md
   - Use terraform for infrastructure
   - Deploy application

3. **Add Monitoring**
   - Setup Prometheus + Grafana
   - Configure alerts
   - Add APM tool

4. **Setup CI/CD**
   - GitHub Actions
   - Automated testing
   - Automated deployment

5. **Scale Up** (optional)
   - Upgrade to t2.small
   - Add load balancer
   - Use RDS for MongoDB
   - Add CloudFront CDN

---

## 📚 Learn More

- **Kubernetes**: https://kubernetes.io/docs/tutorials/
- **Terraform**: https://learn.hashicorp.com/terraform
- **Docker**: https://docs.docker.com/get-started/
- **AWS Free Tier**: https://aws.amazon.com/free/
- **K3s**: https://docs.k3s.io/

---

## ✅ Deployment Checklist

- [ ] AWS account created
- [ ] AWS CLI configured
- [ ] Terraform installed
- [ ] SSH key generated
- [ ] Docker installed (for local testing)
- [ ] terraform.tfvars configured
- [ ] Terraform applied successfully
- [ ] Application deployed
- [ ] Can access frontend
- [ ] Can register users
- [ ] Can create products
- [ ] Can place orders
- [ ] Billing alerts configured
- [ ] Monitoring setup

---

## 🎉 You're All Set!

Your E-Commerce Microservices application is now:
- ✅ Fully Dockerized
- ✅ Kubernetes-Ready
- ✅ AWS-Deployable
- ✅ **100% FREE** (for 12 months)

**Start with**: `docker-compose up -d` to test locally!

**Deploy to AWS**: Follow QUICKSTART.md for step-by-step guide!

---

**Happy Deploying! 🚀**

