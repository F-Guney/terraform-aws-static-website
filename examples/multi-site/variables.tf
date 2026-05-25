variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name_a" {
  description = "Unique S3 bucket name for stack A."
  type        = string
}

variable "bucket_name_b" {
  description = "Unique S3 bucket name for stack B."
  type        = string
}

variable "site_source_dir" {
  description = "Directory to upload as the site origin for both stacks."
  type        = string
  default     = "../../site"
}
