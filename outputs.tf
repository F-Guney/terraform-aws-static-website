output "bucket_name" {
  description = "Name of the bucket for site"
  value       = module.storage.site_bucket_id
}

output "cloudfront_url" {
  description = "Public HTTPS URL of the distribution. Use this in browsers and smoke tests."
  value       = "https://${module.cdn.domain_name}"
}

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cdn.distribution_id
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = module.cdn.domain_name
}

output "bucket_arn" {
  description = "ARN of the bucket"
  value       = module.storage.site_bucket_arn
}

output "oac_id" {
  description = "ID of the origin access control"
  value       = module.cdn.oac_id
}
