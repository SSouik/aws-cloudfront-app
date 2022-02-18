data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "app_certificate" {
  domain      = var.acm_certificate_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
