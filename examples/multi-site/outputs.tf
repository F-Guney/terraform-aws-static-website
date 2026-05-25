output "cloudfront_url_a" {
  description = "Public HTTPS URL of stack A's distribution."
  value       = "https://${module.cdn_a.domain_name}"
}

output "cloudfront_url_b" {
  description = "Public HTTPS URL of stack B's distribution."
  value       = "https://${module.cdn_b.domain_name}"
}
