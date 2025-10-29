# CI/CD Pipeline & DevSecOps Implementation Guide

Complete guide for the automated CI/CD pipeline with DevSecOps practices for the E-Commerce Microservices application.

## 🎯 Overview

This project implements a complete **DevSecOps pipeline** with:
- ✅ **Automated Testing** - Unit, integration, and security tests
- ✅ **Security Scanning** - SAST, DAST, container scanning, secrets detection
- ✅ **Infrastructure as Code** - Terraform with security scanning
- ✅ **Automated Deployment** - Zero-downtime deployments to AWS
- ✅ **Compliance** - License checking, dependency auditing
- ✅ **Monitoring** - Notifications and deployment tracking

---

## 📊 Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Push/PR Event                          │
└─────────────────────┬───────────────────────────────────────────┘
                      │
        ┌─────────────┴──────────────┐
        │                            │
┌───────▼────────┐          ┌────────▼────────┐
│ Code Quality   │          │  Security Scan  │
│ - ESLint       │          │  - GitGuardian  │
│ - Prettier     │          │  - npm audit    │
│ - Unit Tests   │          │  - OWASP Check  │
└───────┬────────┘          └────────┬────────┘
        │                            │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │                            │
┌───────▼────────┐          ┌────────▼────────┐
│ Build Services │          │ Build Frontend  │
│ - Docker Build │          │ - npm build     │
│ - Save Artifacts│         │ - Docker Build  │
└───────┬────────┘          └────────┬────────┘
        │                            │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │   Container Security Scan   │
        │   - Trivy (vulnerabilities) │
        │   - Dockle (best practices) │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │  Infrastructure Security    │
        │  - tfsec                    │
        │  - Checkov                  │
        │  - Terraform validate       │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │   Deploy to AWS (main only)│
        │   - Upload images           │
        │   - Kubernetes deployment   │
        │   - Rolling update          │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │   DAST Security Scan        │
        │   - OWASP ZAP              │
        │   - Vulnerability testing   │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼──────────────┐
        │      Notifications          │
        │      - Slack alerts         │
        │      - Status badges        │
        └─────────────────────────────┘
```

---

## 🔧 Setup Instructions

### Step 1: Fork/Clone Repository

```bash
git clone https://github.com/your-username/devops-assignment.git
cd devops-assignment
```

### Step 2: Configure GitHub Secrets

Go to **Settings → Secrets and variables → Actions** and add these secrets:

#### Required Secrets:

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key | See AWS-SETUP-GUIDE.md |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key | See AWS-SETUP-GUIDE.md |
| `SSH_PRIVATE_KEY` | SSH private key for EC2 | From terraform/key.txt |
| `SERVER_IP` | EC2 instance IP | From terraform output |

#### Optional Secrets (for enhanced security):

| Secret Name | Description | Free Tier Available |
|------------|-------------|-------------------|
| `GITGUARDIAN_API_KEY` | Secret scanning | Yes - gitguardian.com |
| `SNYK_TOKEN` | Dependency scanning | Yes - snyk.io |
| `SLACK_WEBHOOK` | Notifications | Yes - slack.com/apps |

### Step 3: Add GitHub Secrets

```bash
# Required secrets
gh secret set AWS_ACCESS_KEY_ID --body "YOUR_AWS_KEY"
gh secret set AWS_SECRET_ACCESS_KEY --body "YOUR_AWS_SECRET"
gh secret set SSH_PRIVATE_KEY < terraform/key.txt
gh secret set SERVER_IP --body "34.199.190.209"

# Optional secrets
gh secret set GITGUARDIAN_API_KEY --body "YOUR_GITGUARDIAN_KEY"
gh secret set SNYK_TOKEN --body "YOUR_SNYK_TOKEN"
gh secret set SLACK_WEBHOOK --body "YOUR_SLACK_WEBHOOK"
```

### Step 4: Enable GitHub Actions

1. Go to **Settings → Actions → General**
2. Select **Allow all actions and reusable workflows**
3. Enable **Read and write permissions** for workflows
4. Save changes

### Step 5: Enable Security Features

1. Go to **Settings → Code security and analysis**
2. Enable:
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates
   - ✅ Code scanning (CodeQL)
   - ✅ Secret scanning

---

## 🚀 Pipeline Workflows

### 1. Main CI/CD Pipeline

**File**: `.github/workflows/ci-cd-pipeline.yml`

**Triggers**:
- Push to `main` or `develop` branch
- Pull requests to `main`

**Jobs**:
1. **Code Quality** - Linting, SAST, secret scanning
2. **Build & Test** - Build all services, run tests
3. **Container Security** - Scan Docker images
4. **Infrastructure Security** - Scan Terraform code
5. **Deploy** - Deploy to AWS (main branch only)
6. **DAST** - Dynamic security testing
7. **Notify** - Send notifications

**Estimated time**: 15-20 minutes

### 2. Security Scanning

**File**: `.github/workflows/security-scan.yml`

**Triggers**:
- Daily at 2 AM UTC
- Manual trigger via workflow_dispatch

**Jobs**:
1. **Dependency Scan** - npm audit, Snyk
2. **Secret Scan** - Gitleaks
3. **License Compliance** - License checker
4. **Infrastructure Scan** - Terrascan, tfsec
5. **Docker Scan** - Grype, Syft (SBOM)

**Estimated time**: 10-15 minutes

### 3. Terraform Deployment

**File**: `.github/workflows/terraform-deploy.yml`

**Triggers**:
- Push to `main` affecting `terraform/**`
- Pull requests to `main` affecting `terraform/**`
- Manual trigger

**Jobs**:
1. **Terraform Plan** - Validate and plan
2. **Terraform Apply** - Deploy infrastructure (main only)

**Estimated time**: 5-10 minutes

---

## 🔒 Security Tools

### SAST (Static Application Security Testing)

#### 1. ESLint
- **Purpose**: Code quality and basic security issues
- **Configuration**: Runs on all JavaScript files
- **Cost**: FREE

#### 2. GitGuardian
- **Purpose**: Secret detection in code
- **Setup**: Sign up at gitguardian.com
- **Cost**: FREE for public repos

#### 3. npm audit
- **Purpose**: Dependency vulnerabilities
- **Configuration**: Built-in with npm
- **Cost**: FREE

#### 4. OWASP Dependency Check
- **Purpose**: Known vulnerable components
- **Configuration**: Automatic in pipeline
- **Cost**: FREE

### Container Security

#### 1. Trivy
- **Purpose**: Vulnerability scanning for containers
- **Features**: CVE detection, OS packages, app dependencies
- **Cost**: FREE

#### 2. Dockle
- **Purpose**: Docker image best practices
- **Features**: CIS Benchmark checks
- **Cost**: FREE

#### 3. Grype
- **Purpose**: Vulnerability scanner
- **Features**: Multi-distro support
- **Cost**: FREE

#### 4. Syft
- **Purpose**: SBOM (Software Bill of Materials) generation
- **Features**: Inventory all packages
- **Cost**: FREE

### Infrastructure Security

#### 1. tfsec
- **Purpose**: Terraform security scanner
- **Features**: AWS best practices
- **Cost**: FREE

#### 2. Checkov
- **Purpose**: IaC security scanning
- **Features**: Multi-cloud support
- **Cost**: FREE

#### 3. Terrascan
- **Purpose**: IaC policy scanning
- **Features**: Compliance checking
- **Cost**: FREE

### DAST (Dynamic Application Security Testing)

#### 1. OWASP ZAP
- **Purpose**: Web application security testing
- **Features**: Active scanning, spider
- **Cost**: FREE

### Secret Scanning

#### 1. Gitleaks
- **Purpose**: Find secrets in code history
- **Features**: Regex-based detection
- **Cost**: FREE

---

## 📝 Workflow Examples

### Deploying to Production

```bash
# 1. Make changes
git checkout -b feature/new-feature
# ... make changes ...

# 2. Commit and push
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature

# 3. Create pull request (triggers pipeline)
gh pr create --title "Add new feature" --body "Description"

# 4. Pipeline runs automatically:
#    - Code quality checks
#    - Security scans
#    - Build & test
#    - Container scanning

# 5. Review and merge to main
gh pr merge --squash

# 6. Automatic deployment to AWS happens
#    - Images built and scanned
#    - Deployed to Kubernetes
#    - DAST scan runs
#    - Notifications sent
```

### Manual Security Scan

```bash
# Trigger security scan manually
gh workflow run security-scan.yml
```

### Manual Terraform Deployment

```bash
# Trigger infrastructure deployment
gh workflow run terraform-deploy.yml
```

---

## 🎨 DevSecOps Best Practices Implemented

### 1. Shift Left Security
- ✅ Security checks run early in pipeline
- ✅ Fail fast on critical vulnerabilities
- ✅ Pre-commit hooks possible

### 2. Automated Testing
- ✅ Unit tests for all services
- ✅ Integration tests
- ✅ Security tests

### 3. Container Security
- ✅ Minimal base images (Alpine)
- ✅ Multi-stage builds
- ✅ No root user
- ✅ Regular scanning

### 4. Infrastructure as Code
- ✅ Version controlled
- ✅ Security scanned
- ✅ Peer reviewed

### 5. Continuous Monitoring
- ✅ Daily security scans
- ✅ Dependency updates (Dependabot)
- ✅ Audit logging

### 6. Compliance
- ✅ License checking
- ✅ SBOM generation
- ✅ Vulnerability tracking

---

## 📊 Security Reports

### View Security Dashboard

1. Go to **Security** tab in GitHub
2. View:
   - Dependabot alerts
   - Code scanning alerts
   - Secret scanning alerts

### Download Reports

Security scan artifacts are saved for 90 days:

```bash
# List workflow runs
gh run list --workflow=security-scan.yml

# Download artifacts
gh run download <run-id>
```

### SBOM (Software Bill of Materials)

Generated daily for all containers:

- Location: Workflow artifacts
- Format: SPDX JSON
- Use: Compliance, audit, security

---

## 🔔 Notifications

### Slack Integration

1. Create Slack webhook:
   - Go to https://api.slack.com/apps
   - Create new app
   - Add Incoming Webhooks
   - Copy webhook URL

2. Add to GitHub secrets:
   ```bash
   gh secret set SLACK_WEBHOOK --body "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
   ```

3. Notifications sent for:
   - ✅ Successful deployments
   - ❌ Failed deployments
   - ⚠️ Security issues found

### Email Notifications

GitHub automatically sends emails for:
- Failed workflow runs
- Security alerts
- Dependabot updates

---

## 🐛 Troubleshooting

### Pipeline Fails on Security Scan

**Issue**: Vulnerabilities found

**Solution**:
1. Check security tab for details
2. Update vulnerable dependencies
3. If false positive, add to ignore list

### Deployment Fails

**Issue**: Can't connect to AWS

**Solution**:
1. Verify AWS credentials in secrets
2. Check IAM permissions
3. Verify server IP is correct

### Container Scan Fails

**Issue**: Critical vulnerabilities in base image

**Solution**:
1. Update base image version in Dockerfile
2. Use specific version tags
3. Rebuild and rescan

---

## 📈 Monitoring Pipeline Health

### GitHub Actions Dashboard

View at: `https://github.com/YOUR_USERNAME/devops-assignment/actions`

**Metrics to monitor**:
- ✅ Success rate
- ⏱️ Average runtime
- 🔴 Failed runs
- 📊 Trend over time

### Cost Monitoring

GitHub Actions minutes (FREE tier):
- **Free**: 2,000 minutes/month
- **Our pipeline**: ~20 minutes per run
- **Capacity**: ~100 deployments/month

---

## 🔐 Security Checklist

Before going to production:

- [ ] All secrets configured in GitHub
- [ ] Security scanning enabled
- [ ] Dependabot enabled
- [ ] Branch protection rules set
- [ ] Require PR reviews
- [ ] Require status checks to pass
- [ ] No force push to main
- [ ] Signed commits enabled
- [ ] AWS IAM least privilege
- [ ] Terraform state encrypted
- [ ] Container images scanned
- [ ] HTTPS enabled
- [ ] WAF configured
- [ ] Logging enabled
- [ ] Monitoring setup
- [ ] Incident response plan

---

## 🎓 Learning Resources

### DevSecOps
- [OWASP DevSecOps Guideline](https://owasp.org/www-project-devsecops-guideline/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)

### Tools Documentation
- [GitHub Actions](https://docs.github.com/en/actions)
- [Trivy](https://aquasecurity.github.io/trivy/)
- [tfsec](https://aquasecurity.github.io/tfsec/)
- [OWASP ZAP](https://www.zaproxy.org/docs/)

### Kubernetes Security
- [Kubernetes Security](https://kubernetes.io/docs/concepts/security/)
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

---

## 🚀 Next Steps

1. **Enable All Workflows**
   - Push code to trigger pipeline
   - Verify all jobs pass

2. **Configure Optional Tools**
   - Add Snyk token for enhanced scanning
   - Setup Slack notifications
   - Add GitGuardian for secret scanning

3. **Customize Pipeline**
   - Add more tests
   - Configure code coverage
   - Add performance testing

4. **Enhance Security**
   - Add SIEM integration
   - Setup log aggregation
   - Configure WAF rules

5. **Scale Up**
   - Add staging environment
   - Implement blue-green deployment
   - Add canary releases

---

## 📞 Support

For issues or questions:
1. Check pipeline logs in GitHub Actions
2. Review security alerts in Security tab
3. Check TROUBLESHOOTING.md
4. Create an issue in the repository

---

**Your DevSecOps pipeline is ready! 🎉**

Every push to `main` will:
1. ✅ Run security scans
2. ✅ Build and test code
3. ✅ Scan containers
4. ✅ Deploy to AWS
5. ✅ Run DAST scans
6. ✅ Notify team

**Happy Secure Coding! 🔒🚀**

