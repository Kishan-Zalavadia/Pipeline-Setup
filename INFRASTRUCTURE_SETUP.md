# Infrastructure Setup Guide

## Overview

Professional infrastructure setup with modular Terraform configuration.

**Current Status:** DEV environment only (ready to scale to PROD)

## Architecture

```
GitHub (Code)
    ↓
GitHub Actions (CI/CD)
    ↓
Terraform (Infrastructure)
    ├─ DEV Environment
    │   ├─ S3 (Frontend)
    │   ├─ CloudFront (CDN)
    │   ├─ EC2 (Backend)
    │   └─ Security Groups
    └─ PROD Environment (Future)
```

## Directory Structure

```
terraform/
├── modules/              # Reusable components
│   ├── s3/              # Frontend bucket
│   ├── ec2/             # Backend server
│   ├── cloudfront/      # CDN
│   └── security/        # Security groups
├── dev/                 # DEV environment
│   ├── backend.tf       # State config
│   ├── terraform.tfvars # DEV variables
│   └── README.md
├── versions.tf          # Provider config
├── main.tf              # Root module
├── variables.tf         # Root variables
├── outputs.tf           # Root outputs
└── README.md            # Documentation
```

## Key Features

### 1. Modular Design

- **S3 Module:** Frontend hosting
- **EC2 Module:** Backend server
- **CloudFront Module:** CDN
- **Security Module:** Network security

Each module is independent and reusable.

### 2. Environment Separation

- **DEV:** Development and testing
- **PROD:** Production (future)

Each environment has:

- Separate state file
- Separate variables
- Separate resources

### 3. Easy Scaling

To add PROD:

1. Copy `dev/` to `prod/`
2. Update variables
3. Run `terraform apply`

### 4. State Management

- Remote state in S3
- DynamoDB locking
- Automatic backups
- Team collaboration ready

## Quick Start

### 1. Prerequisites

```bash
# Install Terraform
brew install terraform

# Install AWS CLI
brew install awscli

# Configure AWS
aws configure
```

### 2. Deploy DEV

```bash
cd terraform/dev
terraform init
terraform plan
terraform apply
```

### 3. Get Outputs

```bash
terraform output
```

## Deployment Flow

### Current (DEV Only)

```
Push to main
    ↓
GitHub Actions
    ↓
Lint & Format & Build
    ↓
Deploy to DEV
    ├─ Frontend to S3
    ├─ Backend to EC2
    └─ Update CloudFront
    ↓
Live on DEV
```

### Future (DEV + PROD)

```
Push to main
    ↓
GitHub Actions
    ↓
Deploy to DEV
    ↓
Run Tests
    ↓
If Pass → Deploy to PROD
If Fail → Rollback DEV
```

## Module Details

### S3 Module

**Purpose:** Frontend static hosting

**Resources:**

- S3 bucket
- Versioning
- Public access config
- Bucket policy

**Usage:**

```hcl
module "s3" {
  source = "./modules/s3"
  bucket_name = "my-app-frontend"
  environment = "dev"
  cloudfront_oai_arn = module.cloudfront.oai_arn
}
```

### EC2 Module

**Purpose:** Backend API server

**Resources:**

- EC2 instance
- IAM role
- Elastic IP
- User data script

**Usage:**

```hcl
module "ec2" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  key_pair_name = "my-key"
  security_group_id = module.security.security_group_id
  github_repo = "https://github.com/user/repo
d_ssh_cidr = "203.0.113.0/32"
  backend_port = 5050
}
```

## Environment Variables

### DEV Environment (`terraform/dev/terraform.tfvars`)

```hcl
aws_region           = "us-west-2"
environment          = "dev"
project_name         = "my-demo-app"
frontend_bucket_name = "my-demo-app-frontend-dev"
instance_type        = "t2.micro"
root_volume_size     = 30
allowed_ssh_cidr     = "0.0.0.0/0"  # Change for security
key_pair_name        = "my-demo-app-key"
github_repo          = "https://github.com/user/repo"
branch               = "main"
backend_port         = 5050
```

## Outputs

After deployment, get outputs:

```bash
terraform output
```

**Example outputs:**

```
frontend_url = "https://d123456.cloudfront.net"
backend_url = "http://203.0.113.1:5050"
backend_public_ip = "203.0.113.1"
s3_bucket_name = "my-demo-app-frontend-dev"
cloudfront_distribution_id = "E123456"
ec2_instance_id = "i-123456"
```

## Scaling to PROD

### Step 1: Create PROD Directory

```bash
cp -r terraform/dev terraform/prod
```

### Step 2: Update Backend

Edit `terraform/prod/backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-demo-app-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks-prod"
  }
}
```

### Step 3: Update Variables

Edit `terraform/prod/terraform.tfvars`:

```hcl
environment          = "prod"
frontend_bucket_name = "my-demo-app-frontend-prod"
instance_type        = "t2.small"  # Larger for prod
root_volume_size     = 50          # More storage
allowed_ssh_cidr     = "203.0.113.0/32"  # Your IP only
```

### Step 4: Deploy PROD

```bash
cd terraform/prod
terraform init
terraform plan
terraform apply
```

## Cost Estimation

### DEV (Free Tier)

- EC2 t2.micro: $0
- S3: $0
- CloudFront: $0
- **Total: $0/month**

### PROD (After Free Tier)

- EC2 t2.small: ~$15
- S3: ~$1
- CloudFront: ~$1
- **Total: ~$17/month**

## Maintenance

### Update Infrastructure

```bash
# Edit terraform.tfvars
terraform plan
terraform apply
```

### Destroy Resources

```bash
terraform destroy
```

### View State

```bash
terraform show
```

### Backup State

```bash
terraform state pull > backup.tfstate
```

## Troubleshooting

### State Lock

```bash
terraform force-unlock LOCK_ID
```

### Debug

```bash
TF_LOG=DEBUG terraform apply
```

### Refresh State

```bash
terraform refresh
```

## Security Best Practices

1. **SSH Access**
   - Change `allowed_ssh_cidr` from `0.0.0.0/0` to your IP
   - Use strong key pairs
   - Rotate keys regularly

2. **State Management**
   - Use remote state (S3)
   - Enable encryption
   - Enable versioning
   - Restrict access

3. **Secrets**
   - Never commit secrets
   - Use AWS Secrets Manager
   - Use environment variables
   - Use IAM roles

4. **Monitoring**
   - Enable CloudWatch logs
   - Set up alarms
   - Monitor costs
   - Review security groups

## Next Steps

- [ ] Deploy DEV environment
- [ ] Test application
- [ ] Create PROD environment
- [ ] Add monitoring (CloudWatch)
- [ ] Add custom domain (Route 53)
- [ ] Add SSL certificate (ACM)
- [ ] Add database (RDS)
- [ ] Add auto-scaling

## Support

For issues:

1. Check Terraform logs: `terraform show`
2. Check AWS console
3. Review GitHub Actions logs
4. Check EC2 system logs

## Resources

- [Terraform Docs](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)
