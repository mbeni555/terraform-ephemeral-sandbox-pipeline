# Encrypted, private S3 bucket demonstration workload
resource "aws_s3_bucket" "sandbox_storage" {
  #checkov:skip=CKV_AWS_144: Cross-region replication is unnecessary and cost-prohibitive for short-lived PR sandboxes.
  #checkov:skip=CKV_AWS_145: Default AES256 server-side encryption is sufficient; customer-managed KMS key incurs unnecessary base cost.
  #checkov:skip=CKV_AWS_18: S3 server access logging target bucket omitted to prevent circular provisioning and cost overhead in ephemeral environments.
  #checkov:skip=CKV2_AWS_62: Event notifications are not required for temporary sandbox test storage.
  bucket_prefix = "sandbox-pr-${var.pr_number}-"
  force_destroy = true

  tags = {
    Environment = var.environment
    PR_Number   = var.pr_number
    Created_At  = var.created_at
  }
}

resource "aws_s3_bucket_public_access_block" "sandbox_storage_pab" {
  bucket = aws_s3_bucket.sandbox_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sandbox_storage_crypto" {
  bucket = aws_s3_bucket.sandbox_storage.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "sandbox_storage_versioning" {
  bucket = aws_s3_bucket.sandbox_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "sandbox_storage_lifecycle" {
  bucket = aws_s3_bucket.sandbox_storage.id

  rule {
    id     = "expire-sandbox-objects"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }

  depends_on = [aws_s3_bucket_versioning.sandbox_storage_versioning]
}

# CloudWatch Log Group with explicit short-term retention
resource "aws_cloudwatch_log_group" "sandbox_logs" {
  #checkov:skip=CKV_AWS_338: Ephemeral sandbox logs do not require 1-year retention; 7-day retention controls cost.
  #checkov:skip=CKV_AWS_158: AWS managed encryption is sufficient; customer KMS key incurs unnecessary hourly costs for short-lived test sandboxes.
  name              = "/sandbox/pr-${var.pr_number}/workload"
  retention_in_days = 7

  tags = {
    Environment = var.environment
    PR_Number   = var.pr_number
    Created_At  = var.created_at
  }
}