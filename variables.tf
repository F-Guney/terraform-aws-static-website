variable "aws_region" {
  description = "AWS region to deploy resources to"
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the site origin."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be 3-63 chars, lowercase alphanumerics, dots, or hyphens, and start/end alphanumeric."
  }
}

variable "owner" {
  description = "Owner of the project."
  type        = string
  default     = "demoadmin"
}

variable "cost_center" {
  description = "Billing identifier used to attribute spend in AWS Cost Explorer. Tag value, not a real charge code for portfolio use."
  type        = string
  default     = "personal"
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "default_root_object" {
  description = "Object CloudFront serves at the distribution root."
  type        = string
  default     = "index.html"
}

variable "site_source_dir" {
  description = "Local directory uploaded to the origin bucket."
  type        = string
  default     = "www"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be one of PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM cert in us-east-1 for the distribution. Null uses the default CloudFront cert."
  type        = string
  default     = null
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs) for the distribution."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "KMS key ARN (same region as the origin bucket) for SSE-KMS. Null uses AES256."
  type        = string
  default     = null
}
