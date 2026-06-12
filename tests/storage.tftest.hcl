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
    condition     = aws_s3_bucket.origin.bucket == "test-storage-example"
    error_message = "site bucket name must match bucket_name input"
  }

  assert {
    condition     = aws_s3_bucket.logs[0].bucket == "test-storage-example-logs"
    error_message = "logs bucket must derive from bucket_name + logs_bucket_suffix default '-logs'"
  }

  assert {
    condition = (
      aws_s3_bucket_public_access_block.origin.block_public_acls &&
      aws_s3_bucket_public_access_block.origin.block_public_policy &&
      aws_s3_bucket_public_access_block.origin.ignore_public_acls &&
      aws_s3_bucket_public_access_block.origin.restrict_public_buckets
    )
    error_message = "site bucket must block all four forms of public access"
  }

  assert {
    condition = (
      aws_s3_bucket_public_access_block.logs[0].block_public_acls &&
      aws_s3_bucket_public_access_block.logs[0].block_public_policy &&
      aws_s3_bucket_public_access_block.logs[0].ignore_public_acls &&
      aws_s3_bucket_public_access_block.logs[0].restrict_public_buckets
    )
    error_message = "logs bucket must also block all four forms of public access"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.origin.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "AES256"
    error_message = "site bucket must enforce AES256 server-side encryption"
  }

  assert {
    condition     = aws_s3_bucket_versioning.origin.versioning_configuration[0].status == "Enabled"
    error_message = "versioning must default to Enabled"
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.origin.rule[0].object_ownership == "BucketOwnerEnforced"
    error_message = "site bucket must enforce BucketOwnerEnforced"
  }

  assert {
    condition     = aws_s3_bucket_ownership_controls.logs[0].rule[0].object_ownership == "BucketOwnerEnforced"
    error_message = "logs bucket must enforce BucketOwnerEnforced"
  }
}

run "versioning_can_be_suspended" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name        = "test-storage-example"
    site_source_dir    = "./examples/minimal/site"
    versioning_enabled = false
  }

  assert {
    condition     = aws_s3_bucket_versioning.origin.versioning_configuration[0].status == "Suspended"
    error_message = "versioning must suspend when versioning_enabled = false"
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
    condition     = aws_s3_bucket_lifecycle_configuration.logs[0].rule[0].expiration[0].days == 7
    error_message = "lifecycle expiration must match logs_retention_days input"
  }
}

run "kms_opt_in_uses_aws_kms" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name     = "test-storage-example"
    site_source_dir = "./examples/minimal/site"
    kms_key_arn     = "arn:aws:kms:eu-central-1:123456789012:key/00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = one(aws_s3_bucket_server_side_encryption_configuration.origin.rule).apply_server_side_encryption_by_default[0].sse_algorithm == "aws:kms"
    error_message = "kms_key_arn must switch sse_algorithm to aws:kms"
  }
}

run "byo_log_bucket" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name       = "test-storage-example"
    site_source_dir   = "./examples/minimal/site"
    create_log_bucket = false
    log_bucket        = "external-logs"
  }

  assert {
    condition     = length(aws_s3_bucket.logs) == 0
    error_message = "no logs bucket should be created when create_log_bucket = false"
  }

  assert {
    condition     = output.logs_bucket_id == "external-logs"
    error_message = "logs_bucket_id output must resolve to the bring-your-own bucket"
  }
}

run "byo_requires_log_bucket_name" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name       = "test-storage-example"
    site_source_dir   = "./examples/minimal/site"
    create_log_bucket = false
  }

  expect_failures = [terraform_data.log_bucket_guard]
}
