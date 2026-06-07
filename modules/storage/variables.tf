variable "bucket_name" {
  description = "Unique S3 bucket name for the site origin (must follow S3 naming rules)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "bucket_name must be 3-63 chars, lowercase alphanumerics, dots, or hyphens, and start/end alphanumeric."
  }
}

variable "site_source_dir" {
  description = "Local directory whose contents will be uploaded to the origin bucket."
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource the module creates."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  description = "Toggle S3 object versioning on the origin bucket."
  type        = bool
  default     = true
}

variable "logs_bucket_suffix" {
  description = "Suffix appended to bucket_name to derive the logs bucket name."
  type        = string
  default     = "-logs"
}

variable "logs_retention_days" {
  description = "Days to retain access logs before lifecycle expiration."
  type        = number
  default     = 30
}

variable "kms_key_arn" {
  description = "KMS key ARN (in the bucket's region) for SSE-KMS. Null uses SSE-S3 (AES256)."
  type        = string
  default     = null
}
