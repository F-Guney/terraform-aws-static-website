locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    CostCenter  = var.cost_center
    Repository  = "github.com/furkanguney/aws-static-infra"
  }

  name_prefix      = "${var.project}-${var.environment}"
  logs_bucket_name = "${var.bucket_name}-logs"
  oac_name         = "${local.name_prefix}-oac"
  origin_id        = "${local.name_prefix}-s3-origin"

  cache_control_by_extension = {
    html = "public, max-age=300, must-revalidate"
    css  = "public, max-age=31536000, immutable"
    js   = "public, max-age=31536000, immutable"
    svg  = "public, max-age=86400"
    png  = "public, max-age=86400"
    jpg  = "public, max-age=86400"
    json = "public, max-age=60"
  }

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
