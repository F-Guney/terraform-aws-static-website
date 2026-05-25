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
}

variable "logging_bucket_domain_name" {
  description = "Optional logs bucket domain. If set, CloudFront access logs are written here."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource the module creates."
  type        = map(string)
  default     = {}
}
