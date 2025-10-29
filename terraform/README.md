# Terraform AWS Infrastructure for E-Commerce Microservices

This Terraform configuration deploys a K3s Kubernetes cluster on AWS EC2 (free tier eligible) for running the e-commerce microservices application.

## Architecture

- **EC2 Instance**: t2.micro (Free Tier eligible) running Ubuntu 22.04
- **K3s**: Lightweight Kubernetes distribution
- **VPC**: Custom VPC with public subnet
- **Security**: Security group with required ports
- **Storage**: 30GB EBS volume (Free Tier eligible)

## Free Tier Compliance

This setup is designed to stay within AWS Free Tier limits:
- ✅ t2.micro instance (750 hours/month free for 12 months)
- ✅ 30 GB EBS storage (30 GB free for 12 months)
- ✅ 1 Elastic IP (free when associated with running instance)
- ✅ Data transfer (15 GB outbound free per month)

**Note**: After 12 months, costs will apply. Monitor your AWS billing dashboard.

## Prerequisites

1. **AWS Account** with Free Tier eligibility
2. **AWS CLI** configured with credentials
3. **Terraform** (>= 1.0) installed
4. **SSH Key Pair** generated

### Generate SSH Key (if you don't have one)

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This creates `~/.ssh/id_rsa` (private) and `~/.ssh/id_rsa.pub` (public)

## Setup Instructions

### 1. Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
# Default output format: json
```

### 2. Prepare Terraform Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `ssh_public_key`: Paste your public key from `cat ~/.ssh/id_rsa.pub`

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Plan

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted.

**Deployment takes approximately 5-10 minutes.**

### 6. Get Connection Information

```bash
terraform output
```

This shows:
- `instance_public_ip`: The IP address of your server
- `ssh_command`: Command to SSH into the server
- `application_url`: URL to access your app

## Deploying the Application

### Option 1: Manual Deployment

1. **SSH into the server:**
```bash
ssh -i ~/.ssh/id_rsa ubuntu@<instance_public_ip>
```

2. **Upload your application code:**
```bash
# From your local machine
scp -i ~/.ssh/id_rsa -r /path/to/devops-assignment ubuntu@<instance_public_ip>:/home/ubuntu/ecommerce-app
```

3. **Run the deployment script:**
```bash
ssh -i ~/.ssh/id_rsa ubuntu@<instance_public_ip>
cd /home/ubuntu
./deploy.sh
```

4. **Check deployment status:**
```bash
./check-status.sh
```

### Option 2: Automated Deployment Script

Use the provided deployment script from your local machine:

```bash
cd ..
./scripts/deploy-to-aws.sh <instance_public_ip>
```

## Accessing the Application

Once deployed, access the application:

- **Frontend**: `http://<instance_public_ip>`
- **User Service**: `http://<instance_public_ip>:3001`
- **Product Service**: `http://<instance_public_ip>:3002`
- **Order Service**: `http://<instance_public_ip>:3003`

## Managing Kubernetes

### Access kubectl remotely

1. **Get kubeconfig:**
```bash
scp -i ~/.ssh/id_rsa ubuntu@<instance_public_ip>:/etc/rancher/k3s/k3s.yaml ~/.kube/ecommerce-config
```

2. **Update server IP in config:**
```bash
# Edit ~/.kube/ecommerce-config
# Replace 127.0.0.1 with <instance_public_ip>
sed -i 's/127.0.0.1/<instance_public_ip>/g' ~/.kube/ecommerce-config
```

3. **Use kubectl:**
```bash
export KUBECONFIG=~/.kube/ecommerce-config
kubectl get pods -n ecommerce
```

### Useful Commands

```bash
# Check all resources
kubectl get all -n ecommerce

# View pod logs
kubectl logs -n ecommerce <pod-name>

# Describe a pod
kubectl describe pod -n ecommerce <pod-name>

# Execute into a pod
kubectl exec -it -n ecommerce <pod-name> -- /bin/sh

# Delete and restart a deployment
kubectl rollout restart deployment -n ecommerce user-service
```

## Monitoring and Troubleshooting

### Check K3s status

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<instance_public_ip>
sudo systemctl status k3s
```

### View K3s logs

```bash
sudo journalctl -u k3s -f
```

### Check application logs

```bash
kubectl logs -n ecommerce -l app=user-service --tail=50
kubectl logs -n ecommerce -l app=product-service --tail=50
kubectl logs -n ecommerce -l app=order-service --tail=50
```

### Common Issues

**Pods stuck in Pending:**
```bash
kubectl describe pod -n ecommerce <pod-name>
# Check events section for issues
```

**Out of resources:**
```bash
kubectl top nodes
kubectl top pods -n ecommerce
```

## Scaling

To scale your services:

```bash
kubectl scale deployment -n ecommerce user-service --replicas=3
kubectl scale deployment -n ecommerce product-service --replicas=3
kubectl scale deployment -n ecommerce order-service --replicas=3
```

**Note**: t2.micro has limited resources (1 vCPU, 1 GB RAM). Don't over-scale.

## Updating the Application

1. **Update your code locally**
2. **Rebuild Docker images on the server:**
```bash
ssh -i ~/.ssh/id_rsa ubuntu@<instance_public_ip>
cd /home/ubuntu/ecommerce-app
./deploy.sh
```

Or use rolling updates:
```bash
kubectl set image deployment/user-service -n ecommerce user-service=user-service:v2
```

## Cost Monitoring

Monitor your AWS costs:
1. Go to AWS Billing Dashboard
2. Set up billing alerts
3. Review Free Tier usage

**To avoid charges:**
- Don't exceed 750 hours/month of t2.micro usage
- Don't create additional resources
- Destroy infrastructure when not needed

## Destroying Infrastructure

When you're done:

```bash
terraform destroy
```

Type `yes` when prompted.

This will delete all AWS resources and stop billing.

## Backup and Recovery

### Backup MongoDB data

```bash
kubectl exec -n ecommerce <mongodb-pod> -- mongodump --out=/tmp/backup
kubectl cp ecommerce/<mongodb-pod>:/tmp/backup ./mongodb-backup
```

### Restore MongoDB data

```bash
kubectl cp ./mongodb-backup ecommerce/<mongodb-pod>:/tmp/backup
kubectl exec -n ecommerce <mongodb-pod> -- mongorestore /tmp/backup
```

## Security Considerations

### Production Hardening:

1. **Change default secrets:**
   - Update JWT_SECRET in `k8s/user-service-deployment.yaml`

2. **Restrict SSH access:**
   - Update security group to allow SSH only from your IP

3. **Enable HTTPS:**
   - Install cert-manager
   - Configure Let's Encrypt certificates

4. **Update security group:**
   - Remove public access to ports 3001-3003
   - Use only Ingress for external access

5. **Enable pod security:**
   - Add network policies
   - Enable pod security standards

## Support

For issues:
1. Check application logs
2. Check Kubernetes events
3. Review AWS CloudWatch logs
4. Check GitHub issues

## License

This infrastructure code is part of the e-commerce microservices project.

