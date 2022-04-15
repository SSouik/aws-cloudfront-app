output "cloudfront_distribution_id" {
  value       = module.cloudfront.cloudfront_distribution_id
  description = "The ID of the created CloudFront Distribution"
}

output "cloudfront_distribution_arn" {
  value       = module.cloudfront.cloudfront_distribution_arn
  description = "The ARN of the created CloudFront Distribution"
}

output "cloudfront_distribution_domain" {
  value       = module.cloudfront.cloudfront_distribution_domain
  description = "The domain name of the created CloudFront Distribution"
}

output "cloudfront_distribution_hosted_zone_id" {
  value       = module.cloudfront.cloudfront_distribution_hosted_zone_id
  description = "The Hosted Zone ID of the created CloudFront Distribution"
}
