# DEV Environment

This directory contains the Terraform configuration for the DEV environment.

## Structure

```
dev/
├── backend.tf          # State backend configuration
├── terraform.tfvars    # DEV environment variables
└── README.md          # This file
```

## How to Deploy

### 1. Prerequisites

```bash
# Install Terraform
brew install terraform

# Install AWS CLI
brew install awscli

# Configure AWS credentials
aws configure
```

### 2. Initialize Terraform

```bash
cd terraform/dev
terraform init
```

### 3. Review Plan

```bash
terraform plan
```

### 4. Apply Configuration

```bash
terraform apply
```

### 5. Get Outputs

```bash
terraform output
```

## Configuration

Edit `terraform.tfvars` to customize:

- `frontend_bucket_name` - S3 bucket name
- `instance_type` - EC2 instance type (default: t2.micro)
- `key_pair_name` - EC2 key pair name
- `allowed_ssh_cidr` - SSH access CIDR (change from 0.0.0.0/0 for security)
- `github_repo` - GitHub repository URL
- `branch` - Git branch to deploy

## State Management

State is stored in S3:

- Bucket: `my-demo-app-terraform-state-dev`
- Key: `dev/terraform.tfstate`
- Locking: DynamoDB table `terraform-locks-dev`

## Scaling to PROD

To create a PROD environment:

1. Copy this directory to `prod/`
2. Update `backend.tf` with prod bucket names
3. Update `terraform.tfvars` with prod values
4. Run `terraform init` and `terraform apply`

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning:** This cannot be undone!

## Troubleshooting

### State Lock

```bash
terraform force-unlock LOCK_ID
```

### View State

```bash
terraform show
```

### Refresh State

```bash
terraform refresh
```

## Next Steps

- [ ] Create PROD environment (copy dev/ to prod/)
- [ ] Add monitoring (CloudWatch)
- [ ] Add custom domain (Route 53)
- [ ] Add SSL certificate (ACM)
- [ ] Add database (RDS)
