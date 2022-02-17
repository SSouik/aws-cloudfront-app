# Terraform module for creating infrastructure to host an app using AWS Cloudfront

module "s3" {
  source         = "./modules/s3"
  bucket_name    = var.domain_name
  env            = var.env
  index_document = var.index_document
  error_document = var.error_document
}