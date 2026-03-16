# DEV Environment Configuration

aws_region           = "us-west-2"
environment          = "dev"
project_name         = "my-demo-app"
frontend_bucket_name = "my-demo-app-frontend-dev"

# EC2 Configuration
instance_type    = "t2.micro"
root_volume_size = 30

# SSH Configuration
# IMPORTANT: Replace with your IP address (e.g., "203.0.113.0/32")
allowed_ssh_cidr = "0.0.0.0/0"

# EC2 Key Pair
# IMPORTANT: Replace with your EC2 key pair name
key_pair_name = "my-demo-app-key"

# GitHub Configuration
# IMPORTANT: Replace with your GitHub repository URL
github_repo = "https://github.com/YOUR_USERNAME/Pipeline-Setup.git"
branch      = "main"

# Backend Configuration
backend_port = 5050
