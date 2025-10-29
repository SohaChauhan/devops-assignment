# Build images locally and upload to server (PowerShell)
# Much faster than building on the server!

param(
    [string]$ServerIP = "34.199.190.209",
    [string]$SSHKey = "$env:USERPROFILE\.ssh\id_rsa"
)

$ServerUser = "ubuntu"

Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║   BUILD & UPLOAD IMAGES               ║" -ForegroundColor Blue
Write-Host "║   Build locally, deploy to server     ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""

# Step 1: Build images locally
Write-Host "[1/4] 🔨 Building images locally..." -ForegroundColor Green
Write-Host ""

Write-Host "Building user-service..." -ForegroundColor Yellow
docker build -t user-service:latest ./backend/user-service

Write-Host "Building product-service..." -ForegroundColor Yellow
docker build -t product-service:latest ./backend/product-service

Write-Host "Building order-service..." -ForegroundColor Yellow
docker build -t order-service:latest ./backend/order-service

Write-Host "Building frontend..." -ForegroundColor Yellow
docker build -t frontend:latest ./frontend

Write-Host "✅ All images built successfully!" -ForegroundColor Green

# Step 2: Save images
Write-Host ""
Write-Host "[2/4] 💾 Saving images to files..." -ForegroundColor Green

$tempDir = "$env:TEMP\docker-images"
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

# Save without compression (gzip not available in PowerShell)
docker save user-service:latest -o "$tempDir\user-service.tar"
docker save product-service:latest -o "$tempDir\product-service.tar"
docker save order-service:latest -o "$tempDir\order-service.tar"
docker save frontend:latest -o "$tempDir\frontend.tar"

Write-Host "✅ Images saved and compressed" -ForegroundColor Green

# Step 3: Upload to server
Write-Host ""
Write-Host "[3/4] 📤 Uploading images to server..." -ForegroundColor Green

# Upload each file separately
scp -i $SSHKey "$tempDir\user-service.tar" "${ServerUser}@${ServerIP}:/tmp/"
scp -i $SSHKey "$tempDir\product-service.tar" "${ServerUser}@${ServerIP}:/tmp/"
scp -i $SSHKey "$tempDir\order-service.tar" "${ServerUser}@${ServerIP}:/tmp/"
scp -i $SSHKey "$tempDir\frontend.tar" "${ServerUser}@${ServerIP}:/tmp/"

Write-Host "✅ Images uploaded" -ForegroundColor Green

# Step 4: Load on server
Write-Host ""
Write-Host "[4/4] 📥 Loading images on server..." -ForegroundColor Green

$sshCommands = @"
cd /tmp
echo 'Loading user-service...'
docker load -i user-service.tar
echo 'Loading product-service...'
docker load -i product-service.tar
echo 'Loading order-service...'
docker load -i order-service.tar
echo 'Loading frontend...'
docker load -i frontend.tar
echo 'Cleaning up...'
rm -f *.tar
echo '✅ All images loaded successfully!'
echo ''
echo 'Available images:'
docker images | grep -E 'user-service|product-service|order-service|frontend'
"@

ssh -i $SSHKey "$ServerUser@$ServerIP" $sshCommands

# Cleanup
Remove-Item -Recurse -Force $tempDir

Write-Host ""
Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "║  🎉 IMAGES DEPLOYED! 🎉               ║" -ForegroundColor Blue
Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "Now start the services on the server:"
Write-Host "  ssh -i $SSHKey $ServerUser@$ServerIP"
Write-Host "  cd /home/ubuntu/ecommerce-app"
Write-Host "  docker-compose up -d"
Write-Host ""

