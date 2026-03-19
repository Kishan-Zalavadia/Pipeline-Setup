# Deployment Guide

## Overview

This guide explains how to deploy the application to AWS using Terraform and GitHub Actions.

## Architecture

```
GitHub Repository
    ↓
GitHub Actions (CI/CD)
    ↓
├─ Lint & Format Checks
├─ Build Application
├─ Deploy Frontend to S3 + CloudFront
└─ Deploy Backend to EC2
    ↓
Live Application
```

## Prerequisites

1. **AWS Account** (with free tier eligibility)
2. **GitHub Account** (with repository access)
3. **Terraform** installed locally
4. **AWS CLI** installed locally
5. **SSH Key Pair** created in AWS

## Step 1: AWS Setup

### 1.1 Create AWS Account

- Go to https://aws.amazon.com
- Sign up for free tier account
- Verify email and payment method

### 1.2 Create IAM User for Terraform

```bash
# In AWS Console:
1. Go to IAM → Users
2. Create new user: "terraform-user"
3. Attach policies:
   - AmazonS3FullAccess
   - AmazonEC2FullAccess
   - CloudFrontFullAccess
   - IAMFullAccess
4. Create access keys
5. Save Access Key ID and Secret Access Key
```

### 1.3 Create EC2 Key Pair

```bash
# In AWS Console:
1. Go to EC2 → Key Pairs
2. Create new key pair: "my-demo-app-key"
3. Download and save the .pem file
4. chmod 400 my-demo-app-key.pem
```

## Step 2: Terraform Setup

### 2.1 Initialize Terraform State Backend

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://my-demo-app-terraform-state --region us-west-2

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket my-demo-app-terraform-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-west-2
```

### 2.2 Configure Terraform Variables

```bash
# Copy example file
cp terraform/terraform.tfvars.example terraform/terraform.tfvars

# Edit terraform.tfvars with your values
nano terraform/terraform.tfvars
```

**Required values:**

- `key_pair_name`: Name of yo
  the outputs:\*\*

```bash
terraform output
```

## Step 3: GitHub Secrets Setup

### 3.1 Add AWS Credentials

```bash
# In GitHub Repository:
1. Go to Settings → Secrets and variables → Actions
2. Add new secrets:
   - AWS_ACCESS_KEY_ID: (from IAM user)
   - AWS_SECRET_ACCESS_KEY: (from IAM user)
   - EC2_SSH_KEY: (content of .pem file)
   - CLOUDFRONT_DISTRIBUTION_ID: (from terraform output)
```

### 3.2 Verify Secrets

```bash
# In GitHub:
1. Go to Settings → Secrets and variables → Actions
2. Verify all secrets are added
3. Do NOT display secret values
```

## Step 4: Update Frontend Configuration

### 4.1 Update API Endpoint

```bash
# In frontend/src/context/AuthContext.jsx
# Change the API URL to your backend:

const response = await fetch('http://YOUR_BACKEND_IP:5050/auth/login', {
  // ...
})
```

Replace `YOUR_BACKEND_IP` with the Elastic IP from Terraform output.

### 4.2 Commit Changes

```bash
git add .
git commit -m "chore: update backend API endpoint for production"
git push origin feature/authentication
```

## Step 5: Create Pull Request

### 5.1 Create PR on GitHub

1. Go to your GitHub repository
2. Click "Compare & pull request"
3. Set base branch to `main`
4. Set compare branch to `feature/authentication`
5. Add description
6. Create pull request

### 5.2 Review and Merge

1. Wait for GitHub Actions to complete
2. Review the CI/CD results
3. If all checks pass, merge the PR
4. GitHub Actions will automatically deploy

## Step 6: Verify Deployment

### 6.1 Check Frontend

```bash
# Get CloudFront URL from Terraform output
# Open in browser: https://YOUR_CLOUDFRONT_DOMAIN
```

### 6.2 Check Backend

```bash
# Get EC2 IP from Terraform output
curl http://YOUR_EC2_IP:5050/health
```

Expected response:

```json
{
  "status": "OK",
  "message": "Server is running"
}
```

### 6.3 Test Login

1. Open frontend URL
2. Login with credentials: admin / 1234
3. Verify welcome page appears
4. Test logout

## Monitoring and Logs

### 6.1 View EC2 Logs

```bash
# SSH into EC2
ssh -i my-demo-app-key.pem ubuntu@YOUR_EC2_IP

# View PM2 logs
pm2 logs backend

# View Nginx logs
tail -f /var/log/nginx/access.log
```

### 6.2 View CloudWatch Logs

```bash
# In AWS Console:
1. Go to CloudWatch → Log Groups
2. Find logs for your application
3. View real-time logs
```

## Cleanup (if needed)

### 7.1 Destroy Infrastructure

```bash
cd terraform
terraform destroy
```

This will delete:

- S3 bucket
- CloudFront distribution
- EC2 instance
- Security groups
- Elastic IP

**Warning:** This cannot be undone. Make sure you have backups.

## Troubleshooting

### Issue: Terraform state lock

```bash
# Release lock
terraform force-unlock LOCK_ID
```

### Issue: EC2 instance not starting

```bash
# Check instance status
aws ec2 describe-instances --instance-ids i-xxxxx

# View system logs
aws ec2 get-console-output --instance-id i-xxxxx
```

### Issue: Frontend not loading

```bash
# Check S3 bucket
aws s3 ls s3://my-demo-app-frontend-prod/

# Check CloudFront cache
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/*"
```

### Issue: Backend API not responding

```bash
# SSH into EC2 and check PM2
pm2 status
pm2 logs backend

# Check Nginx
systemctl status nginx
```

## Cost Estimation

**Monthly costs (within free tier):**

- EC2 t2.micro: $0 (750 hours/month free)
- S3: $0 (5GB free)
- CloudFront: $0 (50GB free data transfer)
- **Total: ~$0/month**

**After free tier expires:**

- EC2 t2.micro: ~$8/month
- S3: ~$0.50/month
- CloudFront: ~$0.50/month
- **Total: ~$9/month**

## Next Steps

1. ✅ Deploy to AWS
2. ✅ Test application
3. ✅ Monitor logs
4. ⬜ Add custom domain (Route 53)
5. ⬜ Add SSL certificate (ACM)
6. ⬜ Add database (RDS)
7. ⬜ Add monitoring (CloudWatch)
8. ⬜ Add auto-scaling

## Support

For issues or questions:

1. Check AWS documentation
2. Review Terraform logs: `terraform show`
3. Check GitHub Actions logs
4. Review EC2 system logs
