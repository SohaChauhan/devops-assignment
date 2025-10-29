#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    git

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
usermod -aG docker ubuntu

# Install K3s
curl -sfL https://get.k3s.io | sh -s - \
    --write-kubeconfig-mode 644 \
    --disable traefik

# Wait for K3s to be ready
sleep 30

# Set kubeconfig
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Create namespace
kubectl create namespace ecommerce || true

# Create Docker images directory
mkdir -p /home/ubuntu/docker-images

# Install kubectl completion
kubectl completion bash > /etc/bash_completion.d/kubectl

# Create deployment script
cat > /home/ubuntu/deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "Building Docker images..."

# Build images
cd /home/ubuntu/ecommerce-app

docker build -t user-service:latest ./backend/user-service
docker build -t product-service:latest ./backend/product-service
docker build -t order-service:latest ./backend/order-service
docker build -t frontend:latest ./frontend

# Import images to K3s
docker save user-service:latest | sudo k3s ctr images import -
docker save product-service:latest | sudo k3s ctr images import -
docker save order-service:latest | sudo k3s ctr images import -
docker save frontend:latest | sudo k3s ctr images import -

echo "Deploying to Kubernetes..."

# Apply Kubernetes manifests
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/namespace.yaml
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/mongodb-deployment.yaml
sleep 10
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/user-service-deployment.yaml
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/product-service-deployment.yaml
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/order-service-deployment.yaml
kubectl apply -f /home/ubuntu/ecommerce-app/k8s/frontend-deployment.yaml

echo "Deployment complete!"
echo "Check status with: kubectl get pods -n ecommerce"
EOF

chmod +x /home/ubuntu/deploy.sh
chown ubuntu:ubuntu /home/ubuntu/deploy.sh

# Create status check script
cat > /home/ubuntu/check-status.sh << 'EOF'
#!/bin/bash
echo "=== Kubernetes Nodes ==="
kubectl get nodes

echo -e "\n=== Kubernetes Pods ==="
kubectl get pods -n ecommerce

echo -e "\n=== Kubernetes Services ==="
kubectl get svc -n ecommerce

echo -e "\n=== Application Logs (last 20 lines) ==="
echo "User Service:"
kubectl logs -n ecommerce -l app=user-service --tail=20 2>/dev/null || echo "Not running yet"

echo -e "\nProduct Service:"
kubectl logs -n ecommerce -l app=product-service --tail=20 2>/dev/null || echo "Not running yet"

echo -e "\nOrder Service:"
kubectl logs -n ecommerce -l app=order-service --tail=20 2>/dev/null || echo "Not running yet"
EOF

chmod +x /home/ubuntu/check-status.sh
chown ubuntu:ubuntu /home/ubuntu/check-status.sh

# Setup firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 6443/tcp
ufw --force enable

# Create README for the user
cat > /home/ubuntu/README.txt << 'EOF'
==============================================
E-Commerce Microservices K3s Deployment
==============================================

QUICK START:
1. Upload your application code to /home/ubuntu/ecommerce-app
2. Run: ./deploy.sh
3. Check status: ./check-status.sh

USEFUL COMMANDS:
- View all pods: kubectl get pods -n ecommerce
- View services: kubectl get svc -n ecommerce
- View logs: kubectl logs -n ecommerce <pod-name>
- Delete deployment: kubectl delete namespace ecommerce

ACCESSING THE APPLICATION:
- Frontend: http://<SERVER_IP>
- Once deployed, check the service with: kubectl get svc -n ecommerce frontend

KUBECONFIG:
- Located at: /etc/rancher/k3s/k3s.yaml
- Copy to local: scp ubuntu@<SERVER_IP>:/etc/rancher/k3s/k3s.yaml ~/.kube/config

DOCKER IMAGES:
- Build locally and import to k3s using the deploy.sh script
- Or push to a registry and update the deployment YAMLs

==============================================
EOF

chown ubuntu:ubuntu /home/ubuntu/README.txt

echo "Setup complete! K3s is ready."

