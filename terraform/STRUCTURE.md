# Terraform Structure Explanation

## File Organization

````
terraform/
├── modules/                          # Reusable modules
│   ├── s3/                          # Frontend S3 bucket
│   │   ├── main.tf                  # S3 resources
│   │   ├── variables.tf             # S3 input variables
│   │   └── outputs.tf               # S3 outputs
│   ├── ec2/                         # Backend EC2 instance
│   │   ├── main.tf                  # EC2 resources
│   │   ├── variables.tf             # EC2 input variables
│   │   ├── outputs.tf               # EC2 outputs
│   │   └── user_data.sh             # EC2 startup script
│   ├── cloudfront/                  # CDN distribution
│   │   ├── main.tf                  # CloudFront resources
│   │   ├── variables.tf             # CloudFront input variables
│   │   └── outputs.tf               # CloudFront outputs
│   └── security/                    # Security groups
│       ├── main.tf                  # Security group resources
│       ├── variables.tf             # Security input variables
│       └── outputs.tf               # Security outputs
├── dev/                             # DEV environment
│   ├── backend.tf                   # State backend config
│   ├── terraform.tfvars             # DEV environment variables
│   └── README.md
*
- Terraform version requirement
- AWS provider version
- Default tags for all resources

**Example:**
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
````

#### `main.tf`

**Purpose:** Root module that calls all sub-modules

**Contains:**

- Module declarations
- Module dependencies
- Resource composition

**Example:**

```hcl
module "s3" {
  source = "./modules/s3"
  bucket_name = var.frontend_bucket_name
  environment = var.environment
  cloudfront_oai_arn = module.cloudfront.oai_arn
}
```

#### `variables.tf`

**Purpose:** Define input variables for root module

**Contains:**

- Variable declarations
- Variable descriptions
- Default values
- Variable types

**Example:**

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}
```

#### `outputs.tf`

**Purpose:** Define outputs from root module

**Contains:**

- Output declarations
- Output descriptions
- Output values

**Example:**

```hcl
output "frontend_url" {
  description = "Frontend CloudFront URL"
  value       = module.cloudfront.url
}
```

### Module Files

Each module has the same structure:

#### `modules/*/main.tf`

**Purpose:** Define actual AWS resources

**Contains:**

- Resource definitions
- Resource configuration
- Resource dependencies

**Example (S3):**

```hcl
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  tags = {
    Name = "Frontend Bucket"
  }
}
```

#### `modules/*/variables.tf`

**Purpose:** Define input variables for module

**Contains:**

- Variable declarations
- Variable descriptions
- Variable types
- Default values

**Example (S3):**

```hcl
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}
```

#### `modules/*/outputs.tf`

**Purpose:** Define outputs from module

**Contains:**

- Output declarations
- Output descriptions
- Output values

**Example (S3):**

```hcl
output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.frontend.id
}
```

### Environment Files

#### `dev/backend.tf`

**Purpose:** Configure Terraform state backend

**Contains:**

- S3 bucket for state
- DynamoDB table for locking
- Encryption settings

**Example:**

```hcl
terraform {
  backend "s3" {
    bucket         = "my-demo-app-terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks-dev"
  }
}
```

#### `dev/terraform.tfvars`

**Purpose:** Provide values for variables

**Contains:**

- Variable values
- Environment-specific settings
- Secrets (should be in .gitignore)

**Example:**

```hcl
environment          = "dev"
frontend_bucket_name = "my-demo-app-frontend-dev"
instance_type        = "t2.micro"
```

## Data Flow

### 1. Variable Flow

```
terraform.tfvars (values)
    ↓
variables.tf (definitions)
    ↓
main.tf (usage)
    ↓
modules/*/main.tf (resources)
```

### 2. Module Flow

```
Root main.tf
    ↓
├─ module.s3
│   └─ modules/s3/main.tf
├─ module.ec2
│   └─ modules/ec2/main.tf
├─ module.cloudfront
│   └─ modules/cloudfront/main.tf
└─ module.security
    └─ modules/security/main.tf
    ↓
AWS Resources Created
```

### 3. Output Flow

```
modules/*/outputs.tf (module outputs)
    ↓
outputs.tf (root outputs)
    ↓
terraform output (display)
```

## Module Dependencies

```
CloudFront Module
    ↑
    └─ Needs S3 domain name
       └─ S3 Module

EC2 Module
    ↑
    └─ Needs Security Group ID
       └─ Security Module

All Modules
    ↑
    └─ Depend on versions.tf
       └─ Provider configuration
```

## Execution Order

When you run `terraform apply`:

1. **Initialize** - Load modules and providers
2. **Validate** - Check syntax and dependencies
3. **Plan** - Determine what to create
4. **Apply** - Create resources in order:
   - Security Module (no dependencies)
   - S3 Module (no dependencies)
   - CloudFront Module (depends on S3)
   - EC2 Module (depends on Security)

## Adding New Modules

To add a new module (e.g., RDS database):

1. Create directory: `terraform/modules/rds/`
2. Create files:
   - `main.tf` - RDS resources
   - `variables.tf` - Input variables
   - `outputs.tf` - Outputs
3. Add to root `main.tf`:
   ```hcl
   module "rds" {
     source = "./modules/rds"
     # ... variables
   }
   ```
4. Add to root `outputs.tf`:
   ```hcl
   output "rds_endpoint" {
     value = module.rds.endpoint
   }
   ```

## Scaling to PROD

To create PROD environment:

1. Copy `dev/` to `prod/`
2. Update `backend.tf`:
   - Change bucket names to prod
   - Change DynamoDB table to prod
3. Update `terraform.tfvars`:
   - Change environment to "prod"
   - Change bucket names to prod
   - Change instance type (optional)
   - Change other prod-specific values
4. Run:
   ```bash
   cd terraform/prod
   terraform init
   terraform apply
   ```

## Best Practices

### 1. Module Organization

- One responsibility per module
- Reusable across environments
- Clear inputs and outputs

### 2. Variable Naming

- Use descriptive names
- Use snake_case
- Group related variables

### 3. Output Naming

- Use descriptive names
- Include environment in name
- Document output purpose

### 4. State Management

- Use remote state (S3)
- Enable locking (DynamoDB)
- Enable encryption
- Enable versioning

### 5. Security

- Never commit secrets
- Use .gitignore for .tfvars
- Use IAM roles
- Restrict SSH access

## Troubleshooting

### Module Not Found

```bash
terraform init
```

### State Conflict

```bash
terraform force-unlock LOCK_ID
```

### Syntax Error

```bash
terraform validate
```

### View Plan

```bash
terraform plan -out=tfplan
```

### Debug

```bash
TF_LOG=DEBUG terraform apply
```

## Resources

- [Terraform Modules](https://www.terraform.io/docs/modules)
- [Module Best Practices](https://www.terraform.io/docs/modules/develop)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
