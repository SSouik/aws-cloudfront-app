output "lambda_qualified_arn" {
    value = aws_lambda_function.origin_request.qualified_arn
    description = "The qualified ARN of the Lambda@Edge origin request"
}
