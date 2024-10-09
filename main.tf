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

provider "aws" {
  region  = "us-east-1"
  profile = terraform.workspace == "dev" || terraform.workspace == "qa" ? "dev" : "prod"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "Instance type map"
  type        = map(string)

  default = {
    "dev"   = "t2.micro"
    "qa"    = "t2.micro"
    "uat"   = "t2.medium"
    "perf"  = "t2.large"
    "prod"  = "t2.xlarge"
  }
}

module "ec2_instance" {
  source        = "./modules/ec2_instance"
  ami           = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}
