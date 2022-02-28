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

variable "custom_responses" {
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))

  default = [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "404.html"
    },
    {
      error_code         = 403
      response_code      = 403
      response_page_path = "403.html"
    },
    {
      error_code         = 500
      response_code      = 500
      response_page_path = "500.html"
    }
  ]
}

# Route 53
variable "use_acm_certificate" {
  type        = bool
  description = "Set to true if you want to use an existing ACM certificate. False to skip that step and only use the default cloudfront URL"
  default     = true
}

variable "route53_zone_id" {
  type        = string
  description = "Hosted zone ID of the desired Route53 record"
  default     = ""
}

variable "acm_certificate_domain" {
  type        = string
  description = "The domain name that the desired ACM certificate covers (Example: *.example.com)"
  default     = ""
}
