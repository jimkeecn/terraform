terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  region = var.client_region
  profile = var.client_name
}


# Create the S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${lower(var.client_name)}-terraform-state-bucket"

  lifecycle {
    prevent_destroy = true
  }
}

# Enable bucket versioning for Terraform state recovery
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
