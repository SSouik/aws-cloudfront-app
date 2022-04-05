# aws-cloudfront-app

This terraform module creates resources that can host an app using AWS Cloudfront. Resource created include a Cloudfront distribution, S3 bucket, Lambda function and Iam roles/policies to host a static web app.

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
|`use_default_origin_request_lambda`|bool|`false`|Use the default origin request lambda|

#### cloudfront_response
```
{
    error_code         = number
    response_code      = number
    response_page_path = string
}
```

#### cloudfront_response_default
```
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

<br/>

### How to Use
The Terraform module is public and free to use and with that, no GitHub token or special access is needed to use it. Below is a simple example of how it can be used.

```terraform
# main.tf

locals {
  region         = "us-east-1"
  env            = "beta"
  app_name       = "my-test-app" # Cannot have '.' in it. Will break the lambda function validation
  domain_name    = "www.example.com"
  hosted_zone_id = "ABCDEFGHIJK12345"
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
}

module "aws_cloudfront_app" {
  source                 = "git::https://github.com/SSouik/aws-cloudfront-app.git?ref=v2.0.0"
  region                 = local.region
  env                    = local.env
  app_name               = local.app_name
  domain_name            = local.domain_name
  cloudfront_responses   = local.responses
  route53_zone_id        = local.hosted_zone_id
  acm_certificate_domain = local.domain_name
}
```