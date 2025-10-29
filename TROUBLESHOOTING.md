# Troubleshooting Guide

## Common Issues and Solutions

### 1. NPM Timeout During Docker Build

**Error:**
```
npm error code EIDLETIMEOUT
npm error Idle timeout reached for host `registry.npmjs.org:443`
```

**Solution:**
The Dockerfiles have been updated with:
- Increased fetch timeout to 10 minutes
- 5 retry attempts
- Longer retry intervals

**Try these steps:**

1. **Clean up and rebuild:**
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

2. **If still failing, build services one at a time:**
   ```bash
   docker-compose build user-service
   docker-compose build product-service
   docker-compose build order-service
   docker-compose build frontend
   docker-compose up -d
   ```

3. **Use a different npm registry (if in restricted region):**
   
   Add to each Dockerfile before `npm install`:
   ```dockerfile
   RUN npm config set registry https://registry.npmmirror.com
   ```

4. **Build without cache:**
   ```bash
   docker-compose build --no-cache
   docker-compose up -d
   ```

### 2. Port Already in Use

**Error:**
```
Error starting userland proxy: listen tcp 0.0.0.0:3001: bind: address already in use
```

**Solution:**

**Windows:**
```powershell
# Find process using the port
netstat -ano | findstr :3001

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

**Mac/Linux:**
```bash
# Find and kill process
lsof -ti:3001 | xargs kill -9
```

Or change the port in `docker-compose.yml`:
```yaml
ports:
  - "3011:3001"  # Change left side to unused port
```

### 3. MongoDB Connection Failed

**Error:**
```
MongoServerError: connect ECONNREFUSED 127.0.0.1:27017
```

**Solutions:**

1. **Wait for MongoDB to be ready:**
   ```bash
   docker-compose up -d mongodb
   # Wait 10 seconds
   docker-compose up -d
   ```

2. **Check if MongoDB is running:**
   ```bash
   docker-compose ps mongodb
   docker-compose logs mongodb
   ```

3. **Restart MongoDB:**
   ```bash
   docker-compose restart mongodb
   ```

4. **Remove volumes and start fresh:**
   ```bash
   docker-compose down -v
   docker-compose up -d
   ```

### 4. Frontend Can't Connect to Backend

**Error:**
```
Failed to load resource: net::ERR_CONNECTION_REFUSED
```

**Solutions:**

1. **Check all services are running:**
   ```bash
   docker-compose ps
   ```

2. **Check service logs:**
   ```bash
   docker-compose logs user-service
   docker-compose logs product-service
   docker-compose logs order-service
   ```

3. **Verify network connectivity:**
   ```bash
   docker-compose exec frontend ping user-service
   ```

4. **Restart services:**
   ```bash
   docker-compose restart
   ```

### 5. Docker Build is Very Slow

**Solutions:**

1. **Increase Docker resources:**
   - Docker Desktop → Settings → Resources
   - Increase CPU: 4 cores
   - Increase Memory: 4 GB
   - Increase Disk: 60 GB

2. **Use BuildKit for faster builds:**
   ```bash
   # Windows PowerShell
   $env:DOCKER_BUILDKIT=1
   docker-compose build
   
   # Mac/Linux
   DOCKER_BUILDKIT=1 docker-compose build
   ```

3. **Build in parallel:**
   ```bash
   docker-compose build --parallel
   ```

### 6. Out of Disk Space

**Error:**
```
no space left on device
```

**Solutions:**

1. **Clean up Docker:**
   ```bash
   # Remove unused containers, networks, images
   docker system prune -a
   
   # Remove unused volumes
   docker volume prune
   ```

2. **Check disk usage:**
   ```bash
   docker system df
   ```

### 7. Services Keep Restarting

**Check logs:**
```bash
docker-compose logs --tail=50 -f
```

**Common causes:**

1. **Missing environment variables** - Check `.env` files
2. **MongoDB not ready** - Add `depends_on` with health check
3. **Port conflicts** - Change ports
4. **Out of memory** - Increase Docker memory

### 8. Can't Access Application on http://localhost

**Solutions:**

1. **Check if containers are running:**
   ```bash
   docker-compose ps
   ```

2. **Check frontend port:**
   ```bash
   docker-compose port frontend 80
   ```

3. **Try explicit address:**
   - http://localhost:80
   - http://127.0.0.1
   - http://0.0.0.0

4. **Check Windows hosts file:**
   ```
   C:\Windows\System32\drivers\etc\hosts
   ```
   Should have:
   ```
   127.0.0.1 localhost
   ```

### 9. Kubernetes Deployment Issues

#### Pods in CrashLoopBackOff

```bash
# Check pod logs
kubectl logs -n ecommerce <pod-name>

# Describe pod
kubectl describe pod -n ecommerce <pod-name>

# Check events
kubectl get events -n ecommerce --sort-by='.lastTimestamp'
```

#### ImagePullBackOff

```bash
# Images need to be in K3s
docker save user-service:latest | sudo k3s ctr images import -
```

#### Out of Resources

```bash
# Check resources
kubectl top nodes
kubectl top pods -n ecommerce

# Reduce replicas
kubectl scale deployment --all --replicas=1 -n ecommerce
```

### 10. Terraform Issues

#### AWS Credentials Not Configured

```bash
aws configure
# Enter your credentials
```

#### SSH Key Issues

```bash
# Generate new key
ssh-keygen -t rsa -b 4096

# Get public key
cat ~/.ssh/id_rsa.pub

# Add to terraform.tfvars
```

#### Terraform State Locked

```bash
# Force unlock (use carefully)
terraform force-unlock <LOCK_ID>
```

#### Can't SSH to EC2 Instance

1. Check security group allows SSH from your IP
2. Verify you're using correct key:
   ```bash
   ssh -i ~/.ssh/id_rsa ubuntu@<IP> -v
   ```
3. Wait 2-3 minutes after instance creation

### 11. Windows-Specific Issues

#### Line Ending Issues (CRLF vs LF)

**Solution:**
```bash
# In Git Bash
find . -type f -name "*.sh" -exec dos2unix {} \;
```

Or in Git:
```bash
git config --global core.autocrlf false
```

#### PowerShell Command Issues

Use Git Bash or WSL for running shell scripts.

#### Docker Desktop Not Starting

1. Enable WSL 2 in Windows Features
2. Update Docker Desktop
3. Restart Windows
4. Check Windows Defender/Firewall

### 12. Network Issues

#### Can't Download Packages

1. **Check internet connection**
2. **Use VPN if npm registry is blocked**
3. **Use alternative registry:**
   ```bash
   npm config set registry https://registry.npmmirror.com
   ```
4. **Check firewall settings**

#### CORS Errors in Browser

This is normal in development. The backend has CORS enabled for all origins.

If still having issues, check:
```javascript
// In backend server.js
app.use(cors({
  origin: '*',
  credentials: true
}));
```

## Quick Fixes Checklist

When something goes wrong, try these in order:

1. ✅ Check logs: `docker-compose logs -f`
2. ✅ Restart services: `docker-compose restart`
3. ✅ Rebuild containers: `docker-compose up -d --build`
4. ✅ Clean start: `docker-compose down -v && docker-compose up -d`
5. ✅ Clean Docker: `docker system prune -a`
6. ✅ Check resources: Increase Docker memory/CPU
7. ✅ Check internet: Test network connectivity
8. ✅ Update Docker Desktop: Get latest version

## Getting Help

If issues persist:

1. **Check full logs:**
   ```bash
   docker-compose logs > logs.txt
   ```

2. **Check container inspect:**
   ```bash
   docker inspect <container-name>
   ```

3. **Test individual services:**
   ```bash
   curl http://localhost:3001/health
   curl http://localhost:3002/health
   curl http://localhost:3003/health
   ```

4. **Review documentation:**
   - README.md
   - DEPLOYMENT.md
   - QUICKSTART.md

## Performance Optimization

### Speed up builds:

1. **Use .dockerignore** (already included)
2. **Layer caching:**
   ```dockerfile
   # Copy package.json first (already done)
   COPY package*.json ./
   RUN npm install
   # Then copy code
   COPY . .
   ```

3. **Multi-stage builds** (already in frontend)

### Speed up containers:

1. **Use alpine images** (already using)
2. **Only install production dependencies** (already doing)
3. **Optimize Node.js:**
   ```bash
   NODE_ENV=production
   ```

## Monitoring and Debugging

### View real-time logs:
```bash
docker-compose logs -f [service-name]
```

### Execute commands in container:
```bash
docker-compose exec user-service sh
docker-compose exec mongodb mongosh
```

### Check resource usage:
```bash
docker stats
```

### Network debugging:
```bash
docker network ls
docker network inspect devops-assignment_ecommerce-network
```

---

**Still stuck? Create an issue with:**
- Error message
- Full logs
- System info (OS, Docker version)
- Steps to reproduce

