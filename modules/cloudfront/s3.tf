resource "aws_s3_bucket" "app_bucket" {
  for_each = var.s3_app_configs

  bucket = each.value["domain_name"]
  acl    = "private"

  website {
    index_document = each.value["s3_config"]["index_document"]
    error_document = each.value["s3_config"]["error_document"]
  }

  force_destroy = true # Tells Terraform to destroy the bucket even if is not empty

  tags = {
    AppName     = var.app_name
    Name        = each.value["domain_name"]
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
