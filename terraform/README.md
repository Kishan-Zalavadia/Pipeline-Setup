# Terraform Infrastructure as Code

Professional infrastructure setup for My Demo App using Terraform.

## Structure

```
terraform/
├── modules/                    # Reusable modules
│   ├── s3/                    # S3 bucket module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/                   # EC2 instance module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── user_data.sh
│   ├── cloudfront/            # CloudFront CDN module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security/              # Security groups module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── dev/                       # DEV environment
│   ├── backend.tf            # State configuration
│   ├── terraform.tfvars      # DEV variables
│   └── README.md
├── versions.tf               # Provider configuration
├── main.tf                   # Root module (calls all modules)
├── variables.tf              # Root variables
├── outputs.tf                # Root outputs
└── README.md                 # This file
```

## Modules Explained

### 1. S3 Module (`modules/s3/`)

**Purpose:** Frontend static hosting

**Creates:**

- S3 bucket for React build
- Bucket versioning
- Public access configuration
- Bucket policy for CloudFront

**Inputs:**

- `bucket_name` - S3 bucket name
- `environment` - Environment name
- `cloudfront_oai_arn` - CloudFront OAI ARN

**Outputs:**

- `bucket_id` - Bucket name
- `bucket_domain_name` - S3 domain
- `bucket_arn` - Bucket ARN

### 2. EC2 Module (`modules/ec2/`)

**Purpose:** Backend API server

**Creates:**

- EC2 instance (t2.micro)
- IAM role and instance profile
- Elastic IP
- User data script for setup

**Inputs:**

- `instance_type` - EC2 instance type
- `key_pair_name` - SSH key pair
- `security_group_id` - Security group
- `github_repo` - Repository URL
- `branch` - Git branch

**Outputs:**

- `instance_id` - EC2 instance ID
- `public_ip` - Elastic IP
- `backend_url` - API endpoint

### 3. CloudFront Module (`modules/cloudfront/`)

**Purpose:** CDN for frontend

**Creates:**

- CloudFront distribution
- Origin Access Identity (OAI)
- Cache behaviors
- Custom error responses

**Inputs:**

- `s3_bucket_domain_name` - S3 domain
- `environment` - Environment name

**Outputs:**

- `distribution_id` - CloudFront ID
- `domain_name` - CloudFront domain
- `url` - CloudFront URL
- `oai_arn` - OAI ARN

### 4. Security Module (`modules/security/`)

**Purpose:** Network security

**Creates:**

- Security group
- Ingress rules (SSH, HTTP, HTTPS, API)
- Egress rules (allow all)

**Inputs:**

- `allowed_ssh_cidr` - SSH access CIDR
- `backend_port` - API port

**Outputs:**

- `security_group_id` - Security group ID
- `security_group_arn`
  init`and`terraform apply`

## How It Works

### 1. Module Composition

```
Root (main.tf)
    ↓
├─ CloudFront Module
│   └─ Creates CDN
├─ S3 Module
│   └─ Creates bucket
├─ Security Module
│   └─ Creates security groups
└─ EC2 Module
    └─ Creates instance
```

### 2. Dependency Flow

```
CloudFront needs S3 domain
    ↓
S3 needs CloudFront OAI
    ↓
EC2 needs Security Group
    ↓
All modules deployed
```

### 3. State Management

```
Local Development:
  terraform.tfstate (local file)

Production:
  S3 backend (remote state)
  DynamoDB locking (prevent conflicts)
```

## Deployment Workflow

### Step 1: Initialize

```bash
cd terraform/dev
terraform init
```

### Step 2: Plan

```bash
terraform plan -out=tfplan
```

### Step 3: Review

```bash
# Review the plan output
# Check resources to be created
```

### Step 4: Apply

```bash
terraform apply tfplan
```

### Step 5: Get Outputs

```bash
terraform output
```

## Scaling to PROD

### Step 1: Create PROD Directory

```bash
cp -r terraform/dev terraform/prod
```

### Step 2: Update Backend

```bash
# Edit terraform/prod/backend.tf
# Change bucket names to prod
```

### Step 3: Update Variables

```bash
# Edit terraform/prod/terraform.tfvars
# Update environment = "prod"
# Update instance_type = "t2.small" (or larger)
# Update other prod-specific values
```

### Step 4: Deploy PROD

```bash
cd terraform/prod
terraform init
terraform plan
terraform apply
```

## Cost Estimation

### DEV Environment (Free Tier)

- EC2 t2.micro: $0 (750 hours/month)
- S3: $0 (5GB free)
- CloudFront: $0 (50GB free transfer)
- **Total: ~$0/month**

### PROD Environment (After Free Tier)

- EC2 t2.small: ~$15/month
- S3: ~$1/month
- CloudFront: ~$1/month
- **Total: ~$17/month**

## Maintenance

### Update Infrastructure

```bash
# Edit terraform.tfvars
# Run plan to see changes
terraform plan

# Apply changes
terraform apply
```

### Destroy Resources

```bash
# WARNING: This deletes everything!
terraform destroy
```

### Backup State

```bash
# State is automatically backed up in S3
# Manual backup:
terraform state pull > backup.tfstate
```

## Troubleshooting

### State Lock

```bash
terraform force-unlock LOCK_ID
```

### View Current State

```bash
terraform show
```

### Refresh State

```bash
terraform refresh
```

### Debug Mode

```bash
TF_LOG=DEBUG terraform apply
```

## Best Practices

1. **Always plan before apply**

   ```bash
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

2. **Use remote state**
   - Enables team collaboration
   - Prevents state conflicts
   - Automatic backups

3. **Version control**
   - Commit `.tf` files
   - Ignore `.tfstate` files
   - Use `.gitignore`

4. **Naming conventions**
   - Use environment prefix
   - Use descriptive names
   - Use lowercase with hyphens

5. **Security**
   - Never commit secrets
   - Use IAM roles
   - Restrict SSH access
   - Enable encryption

## Next Steps

- [ ] Deploy DEV environment
- [ ] Test application
- [ ] Create PROD environment
- [ ] Add monitoring
- [ ] Add custom domain
- [ ] Add SSL certificate
- [ ] Add database
- [ ] Add auto-scaling

## Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices)
