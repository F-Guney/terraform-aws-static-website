variables {
  name_prefix                   = "test-cdn"
  origin_bucket_id              = "test-origin-bucket"
  origin_bucket_arn             = "arn:aws:s3:::test-origin-bucket"
  origin_bucket_regional_domain = "test-origin-bucket.s3.eu-central-1.amazonaws.com"
  logging_bucket_domain_name    = "test-logs.s3.amazonaws.com"
}

run "wiring_defaults" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.default_cache_behavior[0].viewer_protocol_policy == "redirect-to-https"
    error_message = "viewer policy must redirect http to https"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.price_class == "PriceClass_100"
    error_message = "price_class must default to PriceClass_100"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.default_root_object == "index.html"
    error_message = "default_root_object must default to index.html"
  }

  assert {
    condition     = aws_cloudfront_origin_access_control.control.signing_protocol == "sigv4" && aws_cloudfront_origin_access_control.control.signing_behavior == "always"
    error_message = "OAC must use SigV4 always-sign"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.logging_config[0].prefix == "cloudfront/"
    error_message = "CloudFront access logs must be written under cloudfront/ prefix"
  }
}

run "price_class_overridable" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    name_prefix                   = "test-cdn"
    origin_bucket_id              = "test-origin-bucket"
    origin_bucket_arn             = "arn:aws:s3:::test-origin-bucket"
    origin_bucket_regional_domain = "test-origin-bucket.s3.eu-central-1.amazonaws.com"
    logging_bucket_domain_name    = "test-logs.s3.amazonaws.com"
    price_class                   = "PriceClass_200"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.price_class == "PriceClass_200"
    error_message = "price_class must be overridable per environment"
  }
}
