# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of our E-Commerce Microservices application seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Please do NOT:
- Open a public GitHub issue
- Disclose the vulnerability publicly before we've had a chance to address it

### Please DO:
1. **Email us**: Send details to your-security-email@example.com
2. **Use GitHub Security Advisory**: Create a private security advisory at https://github.com/YOUR_USERNAME/devops-assignment/security/advisories/new

### What to include in your report:
- Type of vulnerability
- Full paths of source file(s) related to the vulnerability
- Location of the affected source code (tag/branch/commit or direct URL)
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability

### What to expect:
- We will acknowledge receipt within 48 hours
- We will send a more detailed response within 7 days
- We will keep you informed about our progress
- We will credit you in the security advisory (unless you prefer to remain anonymous)

## Security Measures in Place

### Code Security
- ✅ Static Application Security Testing (SAST) with ESLint
- ✅ Dependency scanning with npm audit
- ✅ Secret scanning with GitGuardian/Gitleaks
- ✅ OWASP Dependency Check

### Container Security
- ✅ Minimal base images (Alpine)
- ✅ Multi-stage builds
- ✅ Vulnerability scanning with Trivy
- ✅ Best practice checks with Dockle
- ✅ SBOM generation with Syft

### Infrastructure Security
- ✅ Infrastructure as Code scanning with tfsec
- ✅ Compliance checking with Checkov
- ✅ AWS security best practices
- ✅ Encrypted storage
- ✅ Principle of least privilege

### Application Security
- ✅ JWT-based authentication
- ✅ Password hashing with bcrypt
- ✅ Input validation
- ✅ CORS configuration
- ✅ Rate limiting
- ✅ Security headers

### Runtime Security
- ✅ Dynamic Application Security Testing (DAST) with OWASP ZAP
- ✅ Kubernetes security policies
- ✅ Network policies
- ✅ Resource limits

## Security Updates

We use Dependabot to automatically check for security updates. You can view security advisories in the [Security tab](../../security).

## Security Best Practices for Contributors

### Code Contributions
1. Never commit secrets or credentials
2. Use environment variables for sensitive data
3. Validate all user inputs
4. Follow secure coding guidelines
5. Keep dependencies up to date

### Pull Requests
1. Security scans must pass
2. All tests must pass
3. Code review required
4. No high/critical vulnerabilities

### Secrets Management
- Use GitHub Secrets for CI/CD
- Never log sensitive information
- Rotate credentials regularly
- Use separate credentials for each environment

## Compliance

This project follows:
- OWASP Top 10 security best practices
- CIS Docker Benchmark
- Kubernetes security best practices
- AWS security best practices

## Contact

For security questions or concerns, contact:
- Security Team: your-security-email@example.com
- GitHub Security Advisories: Use the Security tab

---

Last updated: 2024

