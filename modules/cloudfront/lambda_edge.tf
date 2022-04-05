locals {
  function_name = "${var.env}-${var.app_name}-default-origin-request"
}

resource "aws_lambda_function" "origin_request" {
  provider      = aws.east_1
  function_name = local.function_name
  description   = "Cloudfront Lambda@Edge function for the ${var.env}-${var.app_name} origin request"
  role          = aws_iam_role.lambda_edge_role.arn
  filename      = "${path.module}/functions/origin-request/origin-request.zip"
  handler       = "index.handler"

  source_code_hash = filebase64sha256("${path.module}/functions/origin-request/origin-request.zip")
  runtime          = "nodejs12.x" # Edge functions do not support 14.x
  publish          = true

  depends_on = [aws_cloudwatch_log_group.origin_request]

  tags = {
    AppName     = var.app_name
    Name        = local.function_name
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
