data "aws_cloudfront_cache_policy" "managed_caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_control" "control" {
  name                              = local.oac_name
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  default_root_object = var.default_root_object
  price_class         = var.price_class

  tags = var.tags

  origin {
    domain_name              = var.origin_bucket_regional_domain
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.control.id
  }

  default_cache_behavior {
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.managed_caching_optimized.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  aliases = var.acm_certificate_arn != null ? var.aliases : null

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
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
  resource_arn = aws_cloudfront_distribution.distribution.arn
}

resource "aws_cloudwatch_log_delivery_destination" "logs" {
  region        = "us-east-1"
  name          = "${var.name_prefix}-cf-s3-dest"
  output_format = "json"

  delivery_destination_configuration {
    destination_resource_arn = "${var.logging_bucket_arn}/cloudfront"
  }
}

resource "aws_cloudwatch_log_delivery" "cloudfront" {
  region                   = "us-east-1"
  delivery_source_name     = aws_cloudwatch_log_delivery_source.cloudfront.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.logs.arn

  depends_on = [aws_s3_bucket_policy.logs]
}

resource "aws_s3_bucket_policy" "bucket" {
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
            "AWS:SourceArn" = aws_cloudfront_distribution.distribution.arn
          }
        }
      },
    ]
  })
}
