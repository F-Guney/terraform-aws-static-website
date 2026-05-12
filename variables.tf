variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources to"
  default     = "eu-central-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for the site origin."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be 3-63 chars, lowercase alphanumerics, dots, or hyphens, and start/end alphanumeric."
  }
}

variable "project" {
  type        = string
  description = "Project name."
}

variable "environment" {
  type        = string
  description = "Environment name."
  default     = "dev"
}

variable "default_root_object" {
  type        = string
  description = "Object CloudFront serves at the distribution root."
  default     = "index.html"
}

variable "site_source_dir" {
  type        = string
  description = "Local directory uploaded to the origin bucket."
  default     = "site"
}
