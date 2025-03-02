provider "aws" {
  region  = var.client_region
  profile = var.client_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
  
  backend "s3" {
    bucket         = "[bucket-client-name]-terraform-state-bucket"
    key            = "[bucket-env]/terraform.tfstate"
    region         = "[bucket-region]"
    encrypt        = true
    use_lockfile   = true
    profile        = "[bucket-client-name]"
  }
}




