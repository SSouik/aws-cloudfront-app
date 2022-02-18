resource "aws_iam_role" "lambda_edge_role" {
  provider = aws.east_1
  name     = "${var.env}-${var.app_name}-or-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        },
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    AppName     = var.app_name
    Name        = "${var.env}-${var.app_name}-origin-request-role"
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

resource "aws_iam_role_policy" "lambda_edge_role_policy" {
  provider = aws.east_1
  name     = "${var.env}-${var.app_name}-or-policy"
  role     = aws_iam_role.lambda_edge_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}
