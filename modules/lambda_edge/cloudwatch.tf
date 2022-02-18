locals {
  lambda_group = "/aws/lambda/us-east-1.${var.env}-${var.app_name}-origin-request"
}

# Log Group for Lambdas
resource "aws_cloudwatch_log_group" "origin_request" {
  name              = local.lambda_group
  retention_in_days = 30 # Keep logs for 30 days

  tags = {
    AppName     = var.app_name
    Name        = local.lambda_group
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
