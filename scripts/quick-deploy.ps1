# Quick Deploy Script (PowerShell) - Ultra Fast Deployment for Windows
# Uses Git to sync code to server in seconds!

param(
    [string]$ServerIP = "34.199.190.209",
    [string]$SSHKey = "$env:USERPROFILE\.ssh\id_rsa",
    [string]$CommitMessage = ""
)

$ServerUser = "ubuntu"
$AppDir = "/home/ubuntu/ecommerce-app"

Write-Host ""
Write-Host "🚀 Quick Deploy Starting..." -ForegroundColor Green
Write-Host ""

# Check if Git is initialized
if (-not (Test-Path .git)) {
    Write-Host "❌ Error: Not a git repository" -ForegroundColor Red
    Write-Host "Run: git init && git add . && git commit -m 'Initial commit'"
    exit 1
}

# Check for uncommitted changes
$status = git status --short
if ($status) {
    Write-Host "📝 Uncommitted changes detected" -ForegroundColor Yellow
    $commit = Read-Host "Commit all changes? (y/n)"
    
    if ($commit -eq "y") {
        Write-Host "📦 Staging changes..." -ForegroundColor Green
        git add .
        
        if (-not $CommitMessage) {
            $CommitMessage = Read-Host "Commit message (default: 'Quick deploy')"
            if (-not $CommitMessage) {
                $CommitMessage = "Quick deploy: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
            }
        }
        
        git commit -m $CommitMessage
    }
}

# Push to GitHub
Write-Host ""
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Green
try {
    git push origin main
    Write-Host "✅ Pushed to GitHub" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Push failed or no changes to push" -ForegroundColor Yellow
}

# Pull on server
Write-Host ""
Write-Host "📥 Updating code on server..." -ForegroundColor Green
Write-Host ""

$sshCommand = @"
cd /home/ubuntu/ecommerce-app
echo '📥 Pulling latest changes...'
if git pull; then
    echo '✅ Code updated successfully!'
else
    echo '⚠️  Git pull failed or no changes'
    exit 1
fi
echo ''
echo '📊 Latest commits:'
git log --oneline -5
"@

ssh -i $SSHKey "$ServerUser@$ServerIP" $sshCommand

Write-Host ""
Write-Host "🎉 Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. SSH to server: ssh -i $SSHKey $ServerUser@$ServerIP"
Write-Host "  2. Rebuild services: cd ecommerce-app && docker-compose up -d --build"
Write-Host "  3. Check status: docker-compose ps"
Write-Host ""
Write-Host "✨ Deploy completed in record time! ⚡" -ForegroundColor Green

