variables {
  bucket_name     = "test-storage-example"
  site_source_dir = "./examples/minimal/site"
}

run "wiring_defaults" {
  command = plan

  module {
    source = "./modules/storage"
  }

  assert {
    condition     = aws_s3_bucket.site.bucket == "test-storage-example"
    error_message = "site bucket name must match bucket_name input"
  }

  assert {
    condition     = aws_s3_bucket.logs.bucket == "test-storage-example-logs"
    error_message = "logs bucket must derive from bucket_name + logs_bucket_suffix default '-logs'"
  }

  assert {
    condition = (
      aws_s3_bucket_public_access_block.site.block_public_acls &&
      aws_s3_bucket_public_access_block.site.block_public_policy &&
      aws_s3_bucket_public_access_block.site.ignore_public_acls &&
      aws_s3_bucket_public_access_block.site.restrict_public_buckets
    )
    error_message = "site bucket must block all four forms of public access"
  }

  assert {
    condition = (
      aws_s3_bucket_public_access_block.logs.block_public_acls &&
      aws_s3_bucket_public_access_block.logs.block_public_policy &&
      aws_s3_bucket_public_access_block.logs.ignore_public_acls &&
      aws_s3_bucket_public_access_block.logs.restrict_public_buckets
    )
    error_message = "logs bucket must also block all four forms of public access"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.site.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "site bucket must enforce AES256 server-side encryption"
  }

  assert {
    condition     = aws_s3_bucket_versioning.site.versioning_configuration[0].status == "Enabled"
    error_message = "versioning must default to Enabled"
  }
}

run "versioning_can_be_suspended" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name       = "test-storage-example"
    site_source_dir   = "./examples/minimal/site"
    enable_versioning = false
  }

  assert {
    condition     = aws_s3_bucket_versioning.site.versioning_configuration[0].status == "Suspended"
    error_message = "versioning must suspend when enable_versioning = false"
  }
}

run "logs_retention_honored" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name         = "test-storage-example"
    site_source_dir     = "./examples/minimal/site"
    logs_retention_days = 7
  }

  assert {
    condition     = aws_s3_bucket_lifecycle_configuration.logs.rule[0].expiration[0].days == 7
    error_message = "lifecycle expiration must match logs_retention_days input"
  }
}
