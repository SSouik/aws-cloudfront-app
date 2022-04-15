# Terraform module for creating infrastructure to host an app using AWS Cloudfront
locals {
  module_version = jsondecode(file("${path.module}/version.json")).version
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  module_version         = local.module_version
  app_name               = var.app_name
  env                    = var.env
  domain_name            = var.domain_name
  root_object            = var.root_object
  custom_responses       = var.cloudfront_responses
  use_acm_certificate    = var.use_acm_certificate
  route53_zone_id        = var.route53_zone_id
  acm_certificate_domain = var.acm_certificate_domain
  default_app_name       = var.default_app_name
  s3_app_configs         = var.s3_app_configs
  app_configs            = var.app_configs
}
