provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "cf" {
  provider = aws.us_east_1

  name        = "example-waf-cf"
  description = "Rate-limit Web ACL for the static-site CloudFront distribution."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "rate-limit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "example-waf-cf"
    sampled_requests_enabled   = true
  }
}

module "storage" {
  source = "../../modules/storage"

  bucket_name     = var.bucket_name
  site_source_dir = var.site_source_dir
  tags            = { Project = "example-waf" }
}

module "cdn" {
  source = "../../modules/cdn"

  name_prefix                   = "example-waf"
  origin_bucket_id              = module.storage.origin_bucket_id
  origin_bucket_arn             = module.storage.origin_bucket_arn
  origin_bucket_regional_domain = module.storage.origin_bucket_regional_domain_name
  logging_bucket_id             = module.storage.logs_bucket_id
  logging_bucket_arn            = module.storage.logs_bucket_arn
  web_acl_id                    = aws_wafv2_web_acl.cf.arn
  tags                          = { Project = "example-waf" }
}
