provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "storage" {
  source = "./modules/storage"

  bucket_name     = var.bucket_name
  site_source_dir = var.site_source_dir
  kms_key_arn     = var.kms_key_arn
  tags            = local.common_tags
}

module "cdn" {
  source = "./modules/cdn"

  name_prefix                   = local.name_prefix
  origin_bucket_id              = module.storage.site_bucket_id
  origin_bucket_arn             = module.storage.site_bucket_arn
  origin_bucket_regional_domain = module.storage.site_bucket_regional_domain_name
  logging_bucket_arn            = module.storage.logs_bucket_arn
  logging_bucket_id             = module.storage.logs_bucket_id
  acm_certificate_arn           = var.acm_certificate_arn
  aliases                       = var.aliases
  default_root_object           = var.default_root_object
  price_class                   = var.cloudfront_price_class
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
