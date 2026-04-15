# CloudFront module (OAC setup)
module "cloudfront" {
  source = "../modules/cloudfront"

  project_name                   = var.project_name
  environment                    = var.environment
  s3_bucket_regional_domain_name = module.s3.bucket_domain_name
  s3_bucket_id                   = module.s3.bucket_id
  s3_bucket_arn                  = module.s3.bucket_arn
  backend_domain_name            = module.ec2.public_dns
}

# S3 module
module "s3" {
  source = "../modules/s3"

  bucket_name = var.frontend_bucket_name
  environment = var.environment
}

# Security module
module "security" {
  source = "../modules/security"

  project_name     = var.project_name
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
  backend_port     = var.backend_port
}

# EC2 module
module "ec2" {
  source = "../modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
  root_volume_size  = var.root_volume_size
  key_pair_name     = var.key_pair_name
  security_group_id = module.security.security_group_id
  github_repo       = var.github_repo
  branch            = var.branch
}
