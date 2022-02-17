output "app_bucket_domain_name" {
  value       = aws_s3_bucket.app_bucket.bucket_regional_domain_name
  description = "The regional domain name of the app bucket"
}

output "app_bucket_id" {
  value       = aws_s3_bucket.app_bucket.id
  description = "The ID of the app bucket"
}

output "app_bucket" {
  value       = aws_s3_bucket.app_bucket.bucket
  description = "The bucket name of the app bucket"
}
