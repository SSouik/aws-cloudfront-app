locals {
  origin_id = "${var.env}-${var.app_name}-origin-identity"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "The origin access identity for ${var.env}-${var.app_name} cloudfront distribution"
}

resource "aws_cloudfront_distribution" "app_distribution" {
  origin {
    domain_name = var.s3_domain_name
    origin_id   = local.origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path # prevents access to S3 Bucket directly
    }
  }

  aliases             = [var.domain_name]
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
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.origin_request_arn
      include_body = false
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100" # Only allow distributions in Us, Canada, and Europe

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA"]
    }
  }

  tags = {
    AppName     = var.app_name
    Name        = "${var.env}-${var.app_name}-distribution"
    Environment = var.env
    ManagedBy   = "Terraform"
    Created     = timestamp()
    CreatedBy   = data.aws_caller_identity.current.arn
    Module      = "aws-cloudfront-app"
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.app_certificate.arn
    ssl_support_method  = "sni-only"
  }

  lifecycle {
    ignore_changes = [
      tags["Created"]
    ]
  }
}
