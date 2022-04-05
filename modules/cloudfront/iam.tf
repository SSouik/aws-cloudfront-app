# S3 bucket is declared here since the cloudfront origin identity needs to be added
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.s3_bucket_id

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "1",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : aws_cloudfront_origin_access_identity.s3_app_origin_access_identity.iam_arn
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${var.s3_bucket}/*"
        }
      ]
  })
}

# Lambda Edge Role
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
