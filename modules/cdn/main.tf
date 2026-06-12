data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = local.oac_name
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  default_root_object = var.default_root_object
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id

  tags = var.tags

  origin {
    domain_name              = var.origin_bucket_regional_domain
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    cache_policy_id            = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
    response_headers_policy_id = var.create_response_headers_policy ? aws_cloudfront_response_headers_policy.this[0].id : null
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  is_ipv6_enabled = var.is_ipv6_enabled
  aliases         = var.acm_certificate_arn != null ? var.aliases : null

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  lifecycle {
    precondition {
      condition     = length(var.aliases) == 0 || var.acm_certificate_arn != null
      error_message = "acm_certificate_arn (an ACM cert in us-east-1) is required when aliases are set; CloudFront cannot serve custom domains on the default certificate."
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = var.logging_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSLogDeliveryWrite"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${var.logging_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control"
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:delivery-source:*"
          }
        }
      },
    ]
  })
}

resource "aws_cloudwatch_log_delivery_source" "cloudfront" {
  region       = "us-east-1"
  name         = "${var.name_prefix}-cf-access-logs"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.this.arn
}

resource "aws_cloudwatch_log_delivery_destination" "logs" {
  region        = "us-east-1"
  name          = "${var.name_prefix}-cf-s3-dest"
  output_format = "json"

  delivery_destination_configuration {
    destination_resource_arn = "${var.logging_bucket_arn}/${var.log_prefix}"
  }
}

resource "aws_cloudwatch_log_delivery" "cloudfront" {
  region                   = "us-east-1"
  delivery_source_name     = aws_cloudwatch_log_delivery_source.cloudfront.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.logs.arn

  depends_on = [aws_s3_bucket_policy.logs]
}

resource "aws_s3_bucket_policy" "origin" {
  bucket = var.origin_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${var.origin_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      },
    ]
  })
}

resource "aws_cloudfront_response_headers_policy" "this" {
  count   = var.create_response_headers_policy ? 1 : 0
  name    = "security-headers-${count.index}"
  comment = "Security headers policy for ${var.name_prefix} CloudFront distribution"

  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    content_type_options {
      override = true
    }

    frame_options {
      frame_option = "DENY"
      override     = true
    }

    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }

    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
  }
}
