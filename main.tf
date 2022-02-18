# Terraform module for creating infrastructure to host an app using AWS Cloudfront

module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.domain_name
  env            = var.env
  app_name       = var.app_name
  index_document = var.index_document
  error_document = var.error_document
}

module "lambda_edge" {
  source   = "./modules/lambda_edge"
  env      = var.env
  app_name = var.app_name
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  app_name               = var.app_name
  env                    = var.env
  s3_domain_name         = module.s3.app_bucket_domain_name
  s3_bucket_id           = module.s3.app_bucket_id
  s3_bucket              = module.s3.app_bucket
  domain_name            = var.domain_name
  root_object            = var.root_object
  origin_request_arn     = module.lambda_edge.origin_request_arn
  route53_zone_id        = var.route53_zone_id
  acm_certificate_domain = var.acm_certificate_domain
}
