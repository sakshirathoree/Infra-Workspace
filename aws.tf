
provider "aws" {
  region  = "us-east-1"
  profile = terraform.workspace == "dev" || terraform.workspace == "qa" ? "dev" : "prod"
}