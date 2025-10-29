# PowerShell script to find and kill processes using ports

Write-Host "Checking ports used by the application..." -ForegroundColor Green

$ports = @(3001, 3002, 3003, 80)

foreach ($port in $ports) {
    Write-Host "`nChecking port $port..." -ForegroundColor Yellow
    
    $connections = netstat -ano | Select-String ":$port " | Select-String "LISTENING"
    
    if ($connections) {
        Write-Host "Port $port is in use:" -ForegroundColor Red
        $connections | ForEach-Object {
            $line = $_.Line
            if ($line -match '\s+(\d+)\s*$') {
                $pid = $matches[1]
                $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
                if ($process) {
                    Write-Host "  Process: $($process.ProcessName) (PID: $pid)" -ForegroundColor Red
                    
                    $response = Read-Host "Kill this process? (y/n)"
                    if ($response -eq 'y') {
                        Stop-Process -Id $pid -Force
                        Write-Host "  Killed process $pid" -ForegroundColor Green
                    }
                }
            }
        }
    } else {
        Write-Host "Port $port is available" -ForegroundColor Green
    }
}

Write-Host "`nDone! You can now run: docker-compose up -d" -ForegroundColor Green

