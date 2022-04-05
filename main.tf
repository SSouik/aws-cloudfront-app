# Terraform module for creating infrastructure to host an app using AWS Cloudfront

module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.domain_name
  env            = var.env
  app_name       = var.app_name
  index_document = var.index_document
  error_document = var.error_document
}

module "cloudfront" {
  source                            = "./modules/cloudfront"
  app_name                          = var.app_name
  env                               = var.env
  s3_domain_name                    = module.s3.app_bucket_domain_name
  s3_bucket_id                      = module.s3.app_bucket_id
  s3_bucket                         = module.s3.app_bucket
  domain_name                       = var.domain_name
  root_object                       = var.root_object
  custom_responses                  = var.cloudfront_responses
  use_default_origin_request_lambda = var.use_default_origin_request_lambda
  use_acm_certificate               = var.use_acm_certificate
  route53_zone_id                   = var.route53_zone_id
  acm_certificate_domain            = var.acm_certificate_domain
}
