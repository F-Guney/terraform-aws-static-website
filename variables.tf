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

variable "create_route53_records" {
  description = "Create Route53 alias records pointing at the distribution. Requires route53_zone_id."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for alias records. Required when create_route53_records is true."
  type        = string
  default     = null
}

variable "is_ipv6_enabled" {
  description = "Whether the distribution responds to IPv6 (AAAA) requests."
  type        = bool
  default     = true
}

variable "web_acl_id" {
  description = "ARN of a WAFv2 Web ACL (scope = CLOUDFRONT, created in us-east-1) to associate. Null disables WAF."
  type        = string
  default     = null
}

variable "geo_restriction" {
  description = "CloudFront geo-restriction. restriction_type is none|whitelist|blacklist; locations are ISO 3166-1-alpha-2 country codes (empty when none)."
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction.restriction_type)
    error_message = "geo_restriction.restriction_type must be one of none, whitelist, blacklist."
  }

  validation {
    condition     = var.geo_restriction.restriction_type == "none" ? length(var.geo_restriction.locations) == 0 : length(var.geo_restriction.locations) > 0
    error_message = "Provide locations for whitelist/blacklist, and none for 'none'."
  }
}

variable "logs_retention_days" {
  description = "Days to retain CloudFront access logs before lifecycle expiration."
  type        = number
  default     = 30
}

variable "create_log_bucket" {
  description = "Create a dedicated S3 bucket for access logs. Set false to reuse an existing bucket via log_bucket."
  type        = bool
  default     = true
}

variable "log_bucket" {
  description = "Name of an existing bucket to write logs to. Required when create_log_bucket is false."
  type        = string
  default     = null
}

variable "log_prefix" {
  description = "S3 key prefix under the log bucket where CloudFront access logs are written."
  type        = string
  default     = "cloudfront"
}
