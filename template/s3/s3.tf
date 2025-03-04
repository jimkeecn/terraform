variable "client_name" {
  type = string
}

variable "environment" {
  type = string
}

// Create a new S3 bucket with the For CRS Reports
resource "aws_s3_bucket" "crs" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-crs"
  
}

resource "aws_s3_bucket_ownership_controls" "crs_ownership" {
  bucket = aws_s3_bucket.crs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "crs_encryption" {
  bucket = aws_s3_bucket.crs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For fatca Reports
resource "aws_s3_bucket" "fatca" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-fatca"
  
}

resource "aws_s3_bucket_ownership_controls" "fatca_ownership" {
  bucket = aws_s3_bucket.fatca.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "fatca_encryption" {
  bucket = aws_s3_bucket.fatca.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For Unit Price
resource "aws_s3_bucket" "up" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-up"
  
}

resource "aws_s3_bucket_ownership_controls" "up_ownership" {
  bucket = aws_s3_bucket.up.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "up_encryption" {
  bucket = aws_s3_bucket.up.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For Report Central Storage
resource "aws_s3_bucket" "report_central_storage" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-report-central-storage"
  
}

resource "aws_s3_bucket_ownership_controls" "report_central_storage_ownership" {
  bucket = aws_s3_bucket.report_central_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "report_central_storage_encryption" {
  bucket = aws_s3_bucket.report_central_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For taurus-database-backup-storage
resource "aws_s3_bucket" "taurus_database_backup_storage" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-taurus-database-backup-storage"
  
}

resource "aws_s3_bucket_ownership_controls" "taurus_database_backup_storage_ownership" {
  bucket = aws_s3_bucket.taurus_database_backup_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "taurus_database_backup_storage_encryption" {
  bucket = aws_s3_bucket.taurus_database_backup_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For auth0-deployment
resource "aws_s3_bucket" "auth0_deploy" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-auth0-deploy"
  
}

resource "aws_s3_bucket_ownership_controls" "auth0_deploy_ownership" {
  bucket = aws_s3_bucket.auth0_deploy.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "auth0_deploy_encryption" {
  bucket = aws_s3_bucket.auth0_deploy.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}


// Create a new S3 bucket with the For Taurus-File_storage
resource "aws_s3_bucket" "file_storage" {
  bucket = "${lower(var.client_name)}-${lower(var.environment)}-taurus-filestorage"
  
}

resource "aws_s3_bucket_ownership_controls" "file_storage_ownership" {
  bucket = aws_s3_bucket.file_storage.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "file_storage_encryption" {
  bucket = aws_s3_bucket.file_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
    bucket_key_enabled = false
  }
}







