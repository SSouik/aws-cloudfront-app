# Terraform module for creating infrastructure to host an app using AWS Cloudfront

module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.domain_name
  env            = var.env
  app_name =    var.app_name
  index_document = var.index_document
  error_document = var.error_document
}

module "lambda_edge" {
  source   = "./modules/lambda_edge"
  env      = var.env
  app_name = var.app_name
}
