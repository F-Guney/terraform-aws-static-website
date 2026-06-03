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

variable "owner" {
  type        = string
  description = "Owner of the project."
  default     = "demoadmin"
}

variable "cost_center" {
  type        = string
  description = "Billing identifier used to attribute spend in AWS Cost Explorer. Tag value, not a real charge code for portfolio use."
  default     = "personal"
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
  default     = "www"
}

variable "cloudfront_price_class" {
  type        = string
  description = "CloudFront price class."
  default     = "PriceClass_100"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of an ACM cert in us-east-1 for the distribution. Null uses the default CloudFront cert."
  default     = null
}

variable "aliases" {
  type        = list(string)
  description = "Alternate domain names (CNAMEs) for the distribution."
  default     = []
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN (same region as the origin bucket) for SSE-KMS. Null uses AES256."
  default     = null
}
