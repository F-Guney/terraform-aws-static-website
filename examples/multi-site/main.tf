provider "aws" {
  region = var.aws_region
}

module "storage_a" {
  source = "../../modules/storage"

  bucket_name     = var.bucket_name_a
  site_source_dir = var.site_source_dir
  tags            = { Project = "example-multi", Stack = "a" }
}

module "storage_b" {
  source = "../../modules/storage"

  bucket_name     = var.bucket_name_b
  site_source_dir = var.site_source_dir
  tags            = { Project = "example-multi", Stack = "b" }
}

module "cdn_a" {
  source = "../../modules/cdn"

  name_prefix                   = "example-multi-a"
  origin_bucket_id              = module.storage_a.site_bucket_id
  origin_bucket_arn             = module.storage_a.site_bucket_arn
  origin_bucket_regional_domain = module.storage_a.site_bucket_regional_domain_name
  logging_bucket_domain_name    = module.storage_a.logs_bucket_domain_name
  tags                          = { Project = "example-multi", Stack = "a" }
}

module "cdn_b" {
  source = "../../modules/cdn"

  name_prefix                   = "example-multi-b"
  origin_bucket_id              = module.storage_b.site_bucket_id
  origin_bucket_arn             = module.storage_b.site_bucket_arn
  origin_bucket_regional_domain = module.storage_b.site_bucket_regional_domain_name
  logging_bucket_domain_name    = module.storage_b.logs_bucket_domain_name
  tags                          = { Project = "example-multi", Stack = "b" }
}
