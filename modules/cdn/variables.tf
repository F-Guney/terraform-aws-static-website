variable "name_prefix" {
  description = "Prefix for the OAC and origin-id naming"
  type        = string
}

variable "origin_bucket_id" {
  description = "ID of the S3 bucket serving as the origin"
  type        = string
}

variable "origin_bucket_arn" {
  description = "ARN of the origin bucket"
  type        = string
}

variable "origin_bucket_regional_domain" {
  description = "Bucket regional domain of the origin."
  type        = string
}

variable "default_root_object" {
  description = "Default object served at /"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class. Defaults to PriceClass_100 for portfolio cost."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "price_class must be one of PriceClass_100, PriceClass_200, PriceClass_All."
  }
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

variable "logging_bucket_id" {
  description = "ID of the S3 bucket for logs"
  type        = string
}

variable "logging_bucket_arn" {
  description = "ARN of the S3 bucket for logs"
  type        = string
}

variable "log_prefix" {
  description = "S3 key prefix under the log bucket where CloudFront access logs are written."
  type        = string
  default     = "cloudfront"
}

variable "acm_certificate_arn" {
  description = "ARN of an ACM certificate in us-east-1. Null uses the default *.cloudfront.net cert."
  type        = string
  default     = null
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs). Only applied when a custom cert is set."
  type        = list(string)
  default     = []
}

variable "create_response_headers_policy" {
  description = "Whether to create a response headers policy for the CloudFront distribution."
  type        = bool
  default     = false
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

variable "tags" {
  description = "Tags applied to every resource the module creates."
  type        = map(string)
  default     = {}
}
