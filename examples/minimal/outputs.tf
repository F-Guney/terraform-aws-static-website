output "cloudfront_url" {
  description = "Public HTTPS URL of the example distribution."
  value       = "https://${module.cdn.domain_name}"
}
