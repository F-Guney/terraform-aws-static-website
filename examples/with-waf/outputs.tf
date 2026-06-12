output "cloudfront_url" {
  description = "Public HTTPS URL of the distribution."
  value       = "https://${module.cdn.domain_name}"
}

output "web_acl_arn" {
  description = "ARN of the WAFv2 Web ACL associated with the distribution."
  value       = aws_wafv2_web_acl.cf.arn
}
