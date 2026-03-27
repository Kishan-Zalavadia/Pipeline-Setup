# CloudFront module (needs OAI from S3 module)
module "cloudfront" {
  source = "../modules/cloudfront"

  project_name           = var.project_name
  environment            = var.environment
  s3_bucket_domain_name  = module.s3.bucket_domain_name
}

# S3 module
module "s3" {
  source = "../modules/s3"

  bucket_name         = var.frontend_bucket_name
  environment         = var.environment
  cloudfront_oai_iam_arn   = module.cloudfront.cloudfront_oai_iam_arn
}

# Security module
module "security" {
  source = "../modules/security"

  project_name       = var.project_name
  environment        = var.environment
  allowed_ssh_cidr   = var.allowed_ssh_cidr
  backend_port       = var.backend_port
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
