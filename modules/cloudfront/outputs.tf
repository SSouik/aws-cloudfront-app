output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.app_distribution.id
  description = "The ID of the created CloudFront Distribution"
}

output "cloudfront_distribution_arn" {
  value       = aws_cloudfront_distribution.app_distribution.arn
  description = "The ARN of the created CloudFront Distribution"
}

output "cloudfront_distribution_domain" {
  value       = aws_cloudfront_distribution.app_distribution.domain_name
  description = "The domain name of the created CloudFront Distribution"
}

output "cloudfront_distribution_hosted_zone_id" {
  value       = aws_cloudfront_distribution.app_distribution.hosted_zone_id
  description = "The Hosted Zone ID of the created CloudFront Distribution"
}
