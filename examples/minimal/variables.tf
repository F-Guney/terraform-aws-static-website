variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name for the example."
  type        = string
}

variable "site_source_dir" {
  description = "Directory to upload as the site origin. Defaults to the repo's site/."
  type        = string
  default     = "../../site"
}
