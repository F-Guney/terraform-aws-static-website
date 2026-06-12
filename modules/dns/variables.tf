variable "route53_zone_id" {
  description = "Route53 zone ID to create alias records in."
  type        = string
  default     = null
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs). Only applied when a custom cert is set."
  type        = list(string)
  default     = []
}


variable "distribution_domain_name" {
  description = "CloudFront distribution domain name (alias target)."
  type        = string
}

variable "distribution_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID (always Z2FDTNDATAQYW2)."
  type        = string
}
