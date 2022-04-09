# aws-cloudfront-app

This terraform module creates resources that can host several apps using AWS Cloudfront.

<br/>

## Table of Contents
* [Module Inputs](#module-inputs)
* [How to Use](#how-to-use)

<br/>

### Module Inputs
|Name|Type|Default|Description|
:--:|:--:|:--:|:--|
|`region`|string|`us-east-1`|Qualifying AWS region (Example: us-east-2)|
|`env`|string|`dev`|Environment of the Infrastructure|
|`app_name`|string|`null`|The name of the application|
|`domain_name`|string|`null`|The domain name that the app will use|
|`root_object`|string|`index.html`|The path to the root object/file|
|`index_document`|string|`index.html`|The path to the index file|
|`error_document`|string|`index.html`|The path to the error document|
|`cloudfront_responses`|list(object([cloudfront_response](#cloudfront_response)))|[cloudfront_response_default](#cloudfront_response_default)|List of custom Cloudfront responses|
|`use_acm_certificate`|bool|`true`|Set to `true` to use ACM certificate and `false` to skip and use default cloudfront URL|
|`route53_zone_id`|string|`""`|Hosted zone ID of the desired Route53 record|
|`acm_certificate_domain`|string|`""`|The domain name that the desired ACM certificate covers (Example: *.example.com)|
|`default_app_name`|string|`""`|Name of the app that will be used as the default for cache. (Must match an app in the s3_app_config or app_configs)|
|`s3_app_configs`|[app_config](#app_config)|`{}`|List of configurations for web apps hosted in S3|
|`app_configs`|map([app_config](#app_config))|`{}`|List of configurations for the web apps not hosted in S3|

#### cloudfront_response
```go
{
    error_code         = number
    response_code      = number
    response_page_path = string
}
```

#### cloudfront_response_default
```terraform
[
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "404.html"
    },
    {
      error_code         = 403
      response_code      = 403
      response_page_path = "403.html"
    },
    {
      error_code         = 500
      response_code      = 500
      response_page_path = "500.html"
    }
]
```

#### app_config
```terraform
{
    domain_name = string
    origin_path = string
    s3_config = {
        index_document = string
        error_document = string
        force_destroy  = bool
        acl            = string
    }
    app_config = {
        http_port = number
        https_port = number
        protocol = string # "http-only", "https-only" or "match-viewer"
        ssl_protocol = list(string) # "TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"
    }
    cache_behavior = {
        path_pattern = string
        allowed_methods = list(string)
        cached_methods = list(string)
        forwarded_values = {
            query_string = bool
            cookies = string
        }
        lambdas = list({
            event_type = string # viewer-request, viewer-response, origin-request, origin-response
            lambda_arn = string
            include_body = bool
        })
        min_ttl = number
        default_ttl = number
        max_ttl = number
        viewer_protocol_policy = string
    }
}
```
<br/>

### How to Use
The Terraform module is public and free to use and with that, no GitHub token or special access is needed to use it. Below is a simple example of how it can be used.

```terraform
# main.tf
locals {
    region         = "us-east-1"
    env            = "test"
    app_name       = "test-app"
    domain_name    = "test.example.com"
    acm_domain     = "*.example.com"
    hosted_zone_id = "ABC123"
    responses = [
        {
            error_code         = 404,
            response_code      = 404,
            response_page_path = "/404"
        },
        {
            error_code         = 403,
            response_code      = 404,
            response_page_path = "/404"
        }
    ]

    s3_apps = {
        "test-app" = {
            domain_name = "test.example.bucket"
            s3_config = {
                error_document = "index.html"
                index_document = "index.html"
                force_destroy  = true
                acl            = "private
            }
            app_config  = null
            origin_path = ""
            cache_behavior = {
                path_pattern    = "*"
                allowed_methods = ["GET", "HEAD"]
                cached_methods  = ["GET", "HEAD"]
                forwarded_values = {
                    query_string = false
                    cookies      = "none"
                }
                lambdas                = []
                default_ttl            = 3600
                min_ttl                = 0
                max_ttl                = 86400
                viewer_protocol_policy = "redirect-to-https"
            }
        }
    }

    app_configs = {
        "api" = {
            domain_name = "abc123.execute-api.us-east-2.amazonaws.com"
            s3_config = null
            app_config = {
                http_port    = 80
                https_port   = 443
                protocol     = "https-only"
                ssl_protocol = ["TLSv1.2"]
            }
            origin_path = "/dev" # api stagename
            cache_behavior = {
                path_pattern    = "api/v1/*"
                allowed_methods = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
                cached_methods  = ["GET", "HEAD"]
                forwarded_values = {
                    query_string = true
                    cookies      = "none"
                }
                lambdas                = []
                min_ttl                = 0
                default_ttl            = 3600
                max_ttl                = 86400
                viewer_protocol_policy = "redirect-to-https" # allow-all, https-only, redirect-to-https
            }
        }
    }
}

module "aws_cloudfront_app" {
  source                 = "git::https://github.com/SSouik/aws-cloudfront-app.git?ref=v2.0.0"
  region                 = local.region
  env                    = local.env
  app_name               = local.app_name
  domain_name            = local.domain_name
  cloudfront_responses   = local.responses
  use_acm_certificate    = true
  route53_zone_id        = local.hosted_zone_id
  acm_certificate_domain = local.acm_domain
  default_app_name       = "samuelsouik-com"
  s3_app_configs         = local.s3_apps
  app_configs            = local.app_configs
}
```