resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  website {
    index_document = var.index_document
    error_document = var.error_document
  }

  force_destroy = true # Tells Terraform to destroy the bucket even if is not empty

  tags = {
    Name        = var.bucket_name
    Environment = var.env
    ManagedBy   = "Terraform"
    Created     = timestamp()
    CreatedBy   = data.aws_caller_identity.current.arn
    Module      = "aws-cloudfront-app"
  }

  lifecycle {
    ignore_changes = [
      tags["Created"]
    ]
  }
}
