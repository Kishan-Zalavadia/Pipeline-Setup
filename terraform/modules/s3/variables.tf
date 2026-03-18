variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cloudfront_oai_arn" {
  description = "CloudFront OAI ARN"
  type        = string
}
