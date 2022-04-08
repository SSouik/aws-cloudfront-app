# General Variables
variable "env" {
  type        = string
  description = "Environment of the Infrastructure"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

# Cloudfront
variable "domain_name" {
  type        = string
  description = "The domain name that the app will use"
}

variable "root_object" {
  type        = string
  description = "The path to the root object/file"
  default     = "index.html"
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
      response_page_path = "/404.html"
    },
    {
      error_code         = 403
      response_code      = 403
      response_page_path = "/403.html"
    },
    {
      error_code         = 500
      response_code      = 500
      response_page_path = "/500.html"
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

# Multiple App Configuration
variable "default_app_name" {
  type        = string
  description = "Name of the app that will be used as the default for cache. (Must match an app in the s3_app_config or app_configs)"
}

variable "s3_app_configs" {
  type = map(object({
    domain_name = string
    origin_path = string
    s3_config = object({
      index_document = string
      error_document = string
    })
    app_config = object({
      http_port    = number       # Typically 80
      https_port   = number       # Typically 443
      protocol     = string       # "http-only", "https-only" or "match-viewer"
      ssl_protocol = list(string) # "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
    })
    cache_behavior = object({
      path_pattern    = string
      allowed_methods = list(string)
      cached_methods  = list(string)
      forwarded_values = object({
        query_string = bool
        cookies      = string
      })
      lambdas = list(object({
        event_type   = string # viewer-request, viewer-response, origin-request, origin-response
        lambda_arn   = string
        include_body = bool
      }))
      min_ttl                = number
      default_ttl            = number
      max_ttl                = number
      viewer_protocol_policy = string # allow-all, https-only, redirect-to-https
    })
  }))
  description = "List of configurations for web apps hosted in S3"
  default     = {}
}

variable "app_configs" {
  type = map(object({
    domain_name = string
    origin_path = string
    s3_config = object({
      index_document = string
      error_document = string
    })
    app_config = object({
      http_port    = number       # Typically 80
      https_port   = number       # Typically 443
      protocol     = string       # "http-only", "https-only" or "match-viewer"
      ssl_protocol = list(string) # "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
    })
    cache_behavior = object({
      path_pattern    = string
      allowed_methods = list(string)
      cached_methods  = list(string)
      forwarded_values = object({
        query_string = bool
        cookies      = string
      })
      lambdas = list(object({
        event_type   = string # viewer-request, viewer-response, origin-request, origin-response
        lambda_arn   = string
        include_body = bool
      }))
      min_ttl                = number
      default_ttl            = number
      max_ttl                = number
      viewer_protocol_policy = string # allow-all, https-only, redirect-to-https
    })
  }))
  description = "Configurations for the web apps not hosted in S3"
  default     = {}
}
