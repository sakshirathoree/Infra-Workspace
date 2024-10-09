terraform {
  backend "s3" {
    bucket = local.bucket_name
    key    = "${terraform.workspace}/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

locals {
  # Backend S3 bucket selection based on the environment
  bucket_name = terraform.workspace == "dev" || terraform.workspace == "qa" ? "dev-terraform-state-bucket" : "prod-terraform-state-bucket"
}