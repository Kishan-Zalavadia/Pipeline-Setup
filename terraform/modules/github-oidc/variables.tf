variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (dev, prod, staging)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in format: owner/repo"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to allow (e.g., main)"
  type        = string
  default     = "main"
}

variable "frontend_bucket_name" {
  description = "S3 bucket name for frontend"
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
}
