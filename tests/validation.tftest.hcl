run "bucket_name_too_short_rejected" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name     = "ab"
    site_source_dir = "./examples/minimal/site"
  }

  expect_failures = [var.bucket_name]
}

run "bucket_name_uppercase_rejected" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name     = "BadName"
    site_source_dir = "./examples/minimal/site"
  }

  expect_failures = [var.bucket_name]
}

run "bucket_name_trailing_dash_rejected" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name     = "good-name-"
    site_source_dir = "./examples/minimal/site"
  }

  expect_failures = [var.bucket_name]
}

run "valid_bucket_name_passes" {
  command = plan

  module {
    source = "./modules/storage"
  }

  variables {
    bucket_name     = "valid-bucket-name-123"
    site_source_dir = "./examples/minimal/site"
  }
}
