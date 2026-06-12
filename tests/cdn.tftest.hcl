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

  override_resource {
    target          = aws_cloudfront_distribution.this
    override_during = plan
    values = {
      arn = "arn:aws:cloudfront::123456789012:distribution/E1EXAMPLE"
    }
  }

  module {
    source = "./modules/cdn"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.default_cache_behavior[0].viewer_protocol_policy == "redirect-to-https"
    error_message = "viewer policy must redirect http to https"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.price_class == "PriceClass_100"
    error_message = "price_class must default to PriceClass_100"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.default_root_object == "index.html"
    error_message = "default_root_object must default to index.html"
  }

  assert {
    condition     = aws_cloudfront_origin_access_control.this.signing_protocol == "sigv4" && aws_cloudfront_origin_access_control.this.signing_behavior == "always"
    error_message = "OAC must use SigV4 always-sign"
  }

  assert {
    condition     = jsondecode(aws_s3_bucket_policy.origin.policy).Statement[0].Condition.StringEquals["AWS:SourceArn"] == aws_cloudfront_distribution.this.arn
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
    condition     = aws_cloudfront_distribution.this.price_class == "PriceClass_200"
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
    condition     = aws_cloudfront_distribution.this.viewer_certificate[0].minimum_protocol_version == "TLSv1.2_2021"
    error_message = "custom cert must pin minimum_protocol_version to TLSv1.2_2021"
  }
}

run "rejects_invalid_price_class" {
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
    price_class                   = "PriceClass_999"
  }

  expect_failures = [var.price_class]
}

run "aliases_without_cert_rejected" {
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
    aliases                       = ["example.com"]
  }

  expect_failures = [aws_cloudfront_distribution.this]
}

run "web_acl_id_wired" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    web_acl_id = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/test/abcd-1234"
  }

  assert {
    condition     = aws_cloudfront_distribution.this.web_acl_id == "arn:aws:wafv2:us-east-1:123456789012:global/webacl/test/abcd-1234"
    error_message = "web_acl_id must pass through to the distribution"
  }
}

run "geo_restriction_applied" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    geo_restriction = { restriction_type = "whitelist", locations = ["US", "CA"] }
  }

  assert {
    condition     = aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].restriction_type == "whitelist"
    error_message = "geo_restriction.restriction_type must drive the distribution restriction"
  }

  assert {
    condition     = contains(aws_cloudfront_distribution.this.restrictions[0].geo_restriction[0].locations, "US")
    error_message = "geo_restriction.locations must be applied to the distribution"
  }
}

run "geo_restriction_whitelist_requires_locations" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    geo_restriction = { restriction_type = "whitelist", locations = [] }
  }

  expect_failures = [var.geo_restriction]
}

run "log_prefix_overridable" {
  command = plan

  module {
    source = "./modules/cdn"
  }

  variables {
    log_prefix = "audit"
  }

  assert {
    condition     = aws_cloudwatch_log_delivery_destination.logs.delivery_destination_configuration[0].destination_resource_arn == "arn:aws:s3:::test-logging-bucket/audit"
    error_message = "log_prefix must set the log delivery destination key prefix"
  }
}
