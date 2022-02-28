data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "app_certificate" {
  count       = var.use_acm_certificate ? 1 : 0
  domain      = var.acm_certificate_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "selected" {
  count   = var.use_acm_certificate ? 1 : 0
  zone_id = var.route53_zone_id
}
