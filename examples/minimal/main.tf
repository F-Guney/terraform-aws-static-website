provider "aws" {
  region = var.aws_region
}

module "storage" {
  source = "../../modules/storage"

  bucket_name     = var.bucket_name
  site_source_dir = var.site_source_dir
  tags            = { Project = "example-minimal" }
}

module "cdn" {
  source = "../../modules/cdn"

  name_prefix                   = "example-minimal"
  origin_bucket_id              = module.storage.origin_bucket_id
  origin_bucket_arn             = module.storage.origin_bucket_arn
  origin_bucket_regional_domain = module.storage.origin_bucket_regional_domain_name
  logging_bucket_arn            = module.storage.logs_bucket_arn
  logging_bucket_id             = module.storage.logs_bucket_id
  tags                          = { Project = "example-minimal" }
}
