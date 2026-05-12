locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  name_prefix      = "${var.project}-${var.environment}"
  logs_bucket_name = "${var.bucket_name}-logs"
  oac_name         = "${local.name_prefix}-oac"
  origin_id        = "${local.name_prefix}-s3-origin"

  content_types = {
    "html"  = "text/html"
    "css"   = "text/css"
    "js"    = "application/javascript"
    "json"  = "application/json"
    "png"   = "image/png"
    "jpg"   = "image/jpeg"
    "svg"   = "image/svg+xml"
    "ico"   = "image/x-icon"
    "webp"  = "image/webp"
    "woff2" = "font/woff2"
    "ttf"   = "font/ttf"
    "otf"   = "font/otf"
    "txt"   = "text/plain"
    "xml"   = "application/xml"
  }

  site_files = fileset("${var.site_source_dir}/", "**/*")
}
