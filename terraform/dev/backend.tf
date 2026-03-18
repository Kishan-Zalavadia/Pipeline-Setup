terraform {
  backend "s3" {
    bucket  = "my-demo-app-terraform-state-dev"
    key     = "dev/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
