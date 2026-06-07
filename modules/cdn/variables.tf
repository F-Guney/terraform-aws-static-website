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

variable "logging_bucket_id" {
  description = "ID of the S3 bucket for logs"
  type        = string
}

variable "logging_bucket_arn" {
  description = "ARN of the S3 bucket for logs"
  type        = string
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

variable "tags" {
  description = "Tags applied to every resource the module creates."
  type        = map(string)
  default     = {}
}
