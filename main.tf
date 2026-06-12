provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "storage" {
  source = "./modules/storage"

  bucket_name         = var.bucket_name
  site_source_dir     = var.site_source_dir
  kms_key_arn         = var.kms_key_arn
  logs_retention_days = var.logs_retention_days
  create_log_bucket   = var.create_log_bucket
  log_bucket          = var.log_bucket
  tags                = local.common_tags
}

module "cdn" {
  source = "./modules/cdn"

  name_prefix                   = local.name_prefix
  origin_bucket_id              = module.storage.origin_bucket_id
  origin_bucket_arn             = module.storage.origin_bucket_arn
  origin_bucket_regional_domain = module.storage.origin_bucket_regional_domain_name
  logging_bucket_arn            = module.storage.logs_bucket_arn
  logging_bucket_id             = module.storage.logs_bucket_id
  acm_certificate_arn           = var.acm_certificate_arn
  aliases                       = var.aliases
  default_root_object           = var.default_root_object
  price_class                   = var.cloudfront_price_class
  is_ipv6_enabled               = var.is_ipv6_enabled
  web_acl_id                    = var.web_acl_id
  geo_restriction               = var.geo_restriction
  log_prefix                    = var.log_prefix
}

module "dns" {
  source = "./modules/dns"
  count  = var.create_route53_records ? 1 : 0

  route53_zone_id             = var.route53_zone_id
  aliases                     = var.aliases
  distribution_domain_name    = module.cdn.domain_name
  distribution_hosted_zone_id = module.cdn.hosted_zone_id
}

action "aws_cloudfront_create_invalidation" "invalidate" {
  config {
    distribution_id = module.cdn.distribution_id
    paths           = ["/*"]
  }
}

resource "terraform_data" "invalidate" {
  input = module.storage.site_files_hash

  lifecycle {
    action_trigger {
      events  = [before_create, before_update]
      actions = [action.aws_cloudfront_create_invalidation.invalidate]
    }
  }
}
