# AWS Setup Guide - Getting Access Keys

## Step-by-Step Guide to Get AWS Access Keys (FREE)

### Prerequisites
- An AWS Account (sign up at https://aws.amazon.com/free)
- Credit/Debit card (for verification - won't be charged if you stay in free tier)

---

## Part 1: Create AWS Account (If You Don't Have One)

### 1. Go to AWS Free Tier Page
Visit: https://aws.amazon.com/free

### 2. Click "Create a Free Account"

### 3. Fill in Account Details
- **Email address**: Your email
- **Password**: Strong password
- **AWS account name**: Any name you want

### 4. Provide Contact Information
- **Account type**: Choose "Personal"
- Fill in your name, phone number, and address

### 5. Payment Information
- Add a credit/debit card (for verification only)
- AWS will charge $1 temporarily to verify, then refund it
- **Don't worry**: You won't be charged if you stay within free tier limits

### 6. Identity Verification
- AWS will call or text you with a verification code
- Enter the code to verify

### 7. Choose Support Plan
- Select **"Basic support - Free"**

### 8. Complete Sign-up
- You'll receive a confirmation email
- Your account will be ready in a few minutes

---

## Part 2: Create IAM User and Get Access Keys

### Method 1: Create IAM User (Recommended - More Secure)

#### Step 1: Sign in to AWS Console
1. Go to https://console.aws.amazon.com
2. Sign in with your root account email and password

#### Step 2: Go to IAM Service
1. In the search bar at the top, type "IAM"
2. Click on "IAM" service

#### Step 3: Create a New User
1. In the left sidebar, click **"Users"**
2. Click the **"Create user"** button (orange button at top right)

#### Step 4: User Details
1. **User name**: Enter a name like `terraform-user` or `deployment-user`
2. Click **"Next"**

#### Step 5: Set Permissions
1. Select **"Attach policies directly"**
2. Search and check these policies:
   - ✅ **AmazonEC2FullAccess** (for EC2 instances)
   - ✅ **AmazonVPCFullAccess** (for networking)
   - ✅ **IAMFullAccess** (for managing permissions)
   
   **OR** for simplicity (not recommended for production):
   - ✅ **AdministratorAccess** (gives full access)

3. Click **"Next"**

#### Step 6: Review and Create
1. Review the details
2. Click **"Create user"**

#### Step 7: Create Access Key
1. Click on the user you just created
2. Click the **"Security credentials"** tab
3. Scroll down to **"Access keys"** section
4. Click **"Create access key"**

#### Step 8: Choose Use Case
1. Select **"Command Line Interface (CLI)"**
2. Check the confirmation box at the bottom
3. Click **"Next"**

#### Step 9: Description (Optional)
1. Add a description like "Terraform deployment key"
2. Click **"Create access key"**

#### Step 10: **IMPORTANT - Save Your Credentials**
You'll see:
- **Access key ID**: `AKIAIOSFODNN7EXAMPLE` (example)
- **Secret access key**: `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` (example)

**⚠️ CRITICAL: Save these NOW! You can't see the secret key again!**

Click **"Download .csv file"** to save them securely.

---

### Method 2: Use Root Account Access Keys (NOT Recommended)

**⚠️ Warning**: Less secure, only use for testing/learning

1. Sign in to AWS Console as root user
2. Click your account name (top right)
3. Click **"Security credentials"**
4. Scroll to **"Access keys"**
5. Click **"Create access key"**
6. Save the Access Key ID and Secret Access Key

---

## Part 3: Configure AWS CLI

### Option 1: Using AWS CLI Configure Command (Easiest)

```bash
aws configure
```

When prompted, enter:
```
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### Option 2: Manual Configuration

**Windows:**
Create/edit file: `C:\Users\YourUsername\.aws\credentials`

**Mac/Linux:**
Create/edit file: `~/.aws/credentials`

Add this content:
```ini
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

And create/edit config file: `~/.aws/config` (or `C:\Users\YourUsername\.aws\config`)

```ini
[default]
region = us-east-1
output = json
```

---

## Part 4: Verify Configuration

Test if it works:

```bash
# Check AWS identity
aws sts get-caller-identity

# Should output something like:
# {
#     "UserId": "AIDACKCEVSQ6C2EXAMPLE",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/terraform-user"
# }
```

If this works, you're ready to use Terraform! 🎉

---

## Part 5: Update Terraform Configuration

Now you can use Terraform without explicitly providing credentials:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Terraform will automatically use the credentials from `~/.aws/credentials`

---

## Security Best Practices

### ✅ DO:
1. **Create IAM users** instead of using root account
2. **Enable MFA** (Multi-Factor Authentication) on your root account
3. **Use minimal permissions** - only give what's needed
4. **Rotate access keys** regularly (every 90 days)
5. **Never commit keys to Git** - add `.aws/` to `.gitignore`
6. **Delete unused access keys**

### ❌ DON'T:
1. **Don't share your access keys** with anyone
2. **Don't commit keys to GitHub** or any public repository
3. **Don't use root account keys** for daily operations
4. **Don't leave keys in code** or configuration files
5. **Don't create keys and forget about them**

---

## Alternative: Use Environment Variables (Temporary)

Instead of configuring files, you can set environment variables:

**Windows PowerShell:**
```powershell
$env:AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
$env:AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env:AWS_DEFAULT_REGION="us-east-1"
```

**Mac/Linux:**
```bash
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"
```

**Note**: These only last for the current terminal session.

---

## Troubleshooting

### Issue: "Unable to locate credentials"

**Solution:**
```bash
# Check if credentials file exists
# Windows:
dir C:\Users\YourUsername\.aws\

# Mac/Linux:
ls -la ~/.aws/

# If missing, run:
aws configure
```

### Issue: "Access Denied" when running Terraform

**Solution:**
1. Check your IAM user has correct permissions
2. Verify credentials are correct:
   ```bash
   aws sts get-caller-identity
   ```

### Issue: "InvalidClientTokenId"

**Solution:**
- Your Access Key ID is incorrect
- Re-run `aws configure` with correct keys

### Issue: "SignatureDoesNotMatch"

**Solution:**
- Your Secret Access Key is incorrect
- Re-run `aws configure` with correct keys

---

## Quick Reference

### AWS Regions (Choose Closest to You)

| Region Code | Location | Free Tier Eligible |
|------------|----------|-------------------|
| us-east-1 | N. Virginia | ✅ Yes |
| us-west-2 | Oregon | ✅ Yes |
| eu-west-1 | Ireland | ✅ Yes |
| ap-southeast-1 | Singapore | ✅ Yes |
| ap-northeast-1 | Tokyo | ✅ Yes |

**Recommendation**: Use `us-east-1` (cheapest and most services)

---

## Cost Monitoring Setup

### Set Up Billing Alerts (IMPORTANT!)

1. Go to AWS Console
2. Search for "Billing"
3. Click "Billing and Cost Management"
4. In left sidebar, click "Budgets"
5. Click "Create budget"
6. Select "Zero spend budget" (for free tier)
7. OR create custom budget:
   - Amount: $1 or $5
   - Alert when: Forecasted or Actual
8. Enter your email for alerts

### Enable Free Tier Alerts

1. In Billing dashboard, click "Billing preferences"
2. Check ✅ "Receive Free Tier Usage Alerts"
3. Enter your email
4. Save preferences

---

## What's Next?

After setting up AWS credentials:

1. **Test locally first:**
   ```bash
   docker-compose up -d
   ```

2. **When ready for AWS:**
   ```bash
   cd terraform
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your SSH key
   terraform init
   terraform apply
   ```

3. **Monitor costs:**
   - Check AWS Billing Dashboard daily
   - Review Free Tier usage weekly
   - Set up billing alerts (as shown above)

---

## Important URLs

- **AWS Console**: https://console.aws.amazon.com
- **AWS Free Tier**: https://aws.amazon.com/free
- **IAM Console**: https://console.aws.amazon.com/iam
- **Billing Dashboard**: https://console.aws.amazon.com/billing
- **Cost Explorer**: https://console.aws.amazon.com/cost-management

---

## Need Help?

If you encounter issues:
1. Check TROUBLESHOOTING.md
2. Verify credentials: `aws sts get-caller-identity`
3. Check IAM permissions in AWS Console
4. Review AWS CloudTrail logs for errors

---

**Ready to Deploy! 🚀**

Once your AWS credentials are set up, you can deploy your application to AWS for FREE using the Terraform configuration!

