locals {
  logs_bucket_name = "${var.bucket_name}${var.logs_bucket_suffix}"

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

  cache_control_by_extension = {
    html = "public, max-age=300, must-revalidate"
    css  = "public, max-age=31536000, immutable"
    js   = "public, max-age=31536000, immutable"
    svg  = "public, max-age=86400"
    png  = "public, max-age=86400"
    jpg  = "public, max-age=86400"
    json = "public, max-age=60"
  }

  site_files = fileset("${var.site_source_dir}/", "**/*")
}
