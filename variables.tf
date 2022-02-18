# General Variables
variable "region" {
  type        = string
  description = "Qualifying AWS region (Example: us-east-2)"
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Environment of the Infrastructure"
  default     = "dev"
}

variable "app_name" {
  type        = string
  description = "The name of the application"
}

# App Variables
variable "domain_name" {
  type        = string
  description = "The domain name that the app will use"
}

variable "root_object" {
  type        = string
  description = "The path to the root object/file"
  default     = "index.html"
}

variable "index_document" {
  type        = string
  description = "The path to the index file"
  default     = "index.html"
}

variable "error_document" {
  type        = string
  description = "The path to the error document"
  default     = "index.html"
}

# Route 53
variable "route53_zone_id" {
  type        = string
  description = "Hosted zone ID of the desired Route53 record"
}

variable "acm_certificate_domain" {
  type        = string
  description = "The domain name that the desired ACM certificate covers (Example: *.example.com)"
}
