variable "env" {
  type        = string
  description = "Environment of the Infrastructure"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

# S3 Bucket variables
variable "s3_domain_name" {
  type        = string
  description = "The region domain name of the S3 bucket"
}

variable "s3_bucket_id" {
  type        = string
  description = "The ID of the S# bucket"
}

variable "s3_bucket" {
  type        = string
  description = "The bucket name of the S3 bucket"
}

variable "domain_name" {
  type        = string
  description = "The domain name that the app will use"
}

variable "root_object" {
  type        = string
  description = "The path to the root object/file"
  default     = "index.html"
}

variable "origin_request_arn" {
  type        = string
  description = "The ARN of the Lambda@Edge origin request"
}

variable "acm_certificate_domain" {
  type        = string
  description = "The domain name that the desired ACM certificate covers (Example: *.example.com)"
}
