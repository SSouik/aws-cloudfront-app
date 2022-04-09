locals {
  default_param = {
    domain_name    = null
    origin_path    = null
    s3_config      = null
    app_config     = null
    cache_behavior = null
  }

  default_app = lookup(
    var.s3_app_configs,
    var.default_app_name,
    lookup(
      var.app_configs,
      var.default_app_name,
      local.default_param
    )
  )

  apps = {
    for k, v in merge(var.s3_app_configs, var.app_configs) : k => v if k != var.default_app_name
  }
}

resource "aws_cloudfront_origin_access_identity" "s3_app_origin_access_identity" {
  for_each = var.s3_app_configs
  comment  = "Origin access ID for ${var.env}-${var.app_name}-${each.key}"
}

resource "aws_cloudfront_distribution" "app_distribution" {
  comment = "Cloudfront Distribution for ${var.env}-${var.app_name}"

  dynamic "origin" {
    for_each = var.s3_app_configs
    iterator = s3_app

    content {
      domain_name = aws_s3_bucket.app_bucket[s3_app.key].bucket_regional_domain_name
      origin_id   = "${var.env}-${var.app_name}-${s3_app.key}"
      origin_path = s3_app.value["origin_path"]

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.s3_app_origin_access_identity[s3_app.key].cloudfront_access_identity_path # prevents access to S3 Bucket directly
      }
    }
  }

  dynamic "origin" {
    for_each = var.app_configs
    iterator = app

    content {
      domain_name = app.value["domain_name"]
      origin_id   = "${var.env}-${var.app_name}-${app.key}"
      origin_path = app.value["origin_path"]

      custom_origin_config {
        http_port              = app.value["app_config"]["http_port"]
        https_port             = app.value["app_config"]["https_port"]
        origin_protocol_policy = app.value["app_config"]["protocol"]
        origin_ssl_protocols   = app.value["app_config"]["ssl_protocol"]
      }
    }
  }

  aliases             = var.use_acm_certificate ? [var.domain_name] : []
  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = var.root_object

  dynamic "custom_error_response" {
    for_each = var.custom_responses
    iterator = custom_response

    content {
      error_code         = custom_response.value.error_code
      response_code      = custom_response.value.response_code
      response_page_path = custom_response.value.response_page_path
    }
  }

  default_cache_behavior {
    allowed_methods  = local.default_app["cache_behavior"]["allowed_methods"]
    cached_methods   = local.default_app["cache_behavior"]["cached_methods"]
    target_origin_id = "${var.env}-${var.app_name}-${var.default_app_name}"

    forwarded_values {
      query_string = local.default_app["cache_behavior"]["forwarded_values"]["query_string"]

      cookies {
        forward = local.default_app["cache_behavior"]["forwarded_values"]["cookies"]
      }
    }

    dynamic "lambda_function_association" {
      for_each = local.default_app["cache_behavior"]["lambdas"]
      iterator = lambda_function

      content {
        event_type   = lambda_function.event_type
        lambda_arn   = lambda_function.arn
        include_body = lambda_function.include_body
      }
    }

    min_ttl                = local.default_app["cache_behavior"]["min_ttl"]
    default_ttl            = local.default_app["cache_behavior"]["default_ttl"]
    max_ttl                = local.default_app["cache_behavior"]["max_ttl"]
    viewer_protocol_policy = local.default_app["cache_behavior"]["viewer_protocol_policy"]
  }

  dynamic "ordered_cache_behavior" {
    for_each = local.apps
    iterator = app

    content {
      path_pattern     = app.value["cache_behavior"]["path_pattern"]
      allowed_methods  = app.value["cache_behavior"]["allowed_methods"]
      cached_methods   = app.value["cache_behavior"]["cached_methods"]
      target_origin_id = "${var.env}-${var.app_name}-${app.key}"
      forwarded_values {
        query_string = app.value["cache_behavior"]["forwarded_values"]["query_string"]

        cookies {
          forward = app.value["cache_behavior"]["forwarded_values"]["cookies"]
        }
      }

      dynamic "lambda_function_association" {
        for_each = app.value["cache_behavior"]["lambdas"]
        iterator = lambda_function

        content {
          event_type   = lambda_function.event_type
          lambda_arn   = lambda_function.arn
          include_body = lambda_function.include_body
        }
      }

      min_ttl                = app.value["cache_behavior"]["min_ttl"]
      default_ttl            = app.value["cache_behavior"]["default_ttl"]
      max_ttl                = app.value["cache_behavior"]["max_ttl"]
      viewer_protocol_policy = app.value["cache_behavior"]["viewer_protocol_policy"]
    }
  }

  price_class = "PriceClass_100" # Only allow distributions in Us, Canada, and Europe

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  tags = {
    AppName       = var.app_name
    Name          = "${var.env}-${var.app_name}-distribution"
    Environment   = var.env
    ManagedBy     = "Terraform"
    Created       = timestamp()
    CreatedBy     = data.aws_caller_identity.current.arn
    Module        = "aws-cloudfront-app"
    ModuleVersion = var.module_version
  }

  viewer_certificate {
    cloudfront_default_certificate = !var.use_acm_certificate
    acm_certificate_arn            = var.use_acm_certificate ? data.aws_acm_certificate.app_certificate[0].arn : ""
    ssl_support_method             = "sni-only"
  }

  lifecycle {
    ignore_changes = [
      tags["Created"]
    ]
  }
}
