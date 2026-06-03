variables {
  name_prefix                   = "test-cdn"
  origin_bucket_id              = "test-origin-bucket"
  origin_bucket_arn             = "arn:aws:s3:::test-origin-bucket"
  origin_bucket_regional_domain = "test-origin-bucket.s3.eu-central-1.amazonaws.com"
  logging_bucket_id             = "test-logging-bucket"
  logging_bucket_arn            = "arn:aws:s3:::test-logging-bucket"
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
    condition     = jsondecode(aws_s3_bucket_policy.bucket.policy).Statement[0].Condition.StringEquals["AWS:SourceArn"] == aws_cloudfront_distribution.distribution.arn
    error_message = "OAC bucket policy must scope AWS:SourceArn to the distribution ARN"
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
    logging_bucket_id             = "test-logging-bucket"
    logging_bucket_arn            = "arn:aws:s3:::test-logging-bucket"
    price_class                   = "PriceClass_200"
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.price_class == "PriceClass_200"
    error_message = "price_class must be overridable per environment"
  }
}

run "custom_cert_sets_tls_floor" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    name_prefix                   = "test-cdn"
    origin_bucket_id              = "test-origin-bucket"
    origin_bucket_arn             = "arn:aws:s3:::test-origin-bucket"
    origin_bucket_regional_domain = "test-origin-bucket.s3.eu-central-1.amazonaws.com"
    logging_bucket_id             = "test-logging-bucket"
    logging_bucket_arn            = "arn:aws:s3:::test-logging-bucket"
    acm_certificate_arn           = "arn:aws:acm:us-east-1:123456789012:certificate/abcd"
    aliases                       = ["example.com"]
  }

  assert {
    condition     = aws_cloudfront_distribution.distribution.viewer_certificate[0].minimum_protocol_version == "TLSv1.2_2021"
    error_message = "custom cert must pin minimum_protocol_version to TLSv1.2_2021"
  }
}
