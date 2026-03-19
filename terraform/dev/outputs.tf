output "frontend_url" {
  description = "Frontend CloudFront URL"
  value       = module.cloudfront.url
}

output "backend_url" {
  description = "Backend API URL"
  value       = module.ec2.backend_url
}

output "backend_public_ip" {
  description = "Backend EC2 public IP"
  value       = module.ec2.public_ip
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_id
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.instance_id
}
