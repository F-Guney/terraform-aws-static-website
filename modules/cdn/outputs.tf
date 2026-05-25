output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.distribution.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.distribution.arn
}

output "domain_name" {
  description = "Public CloudFront domain"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "url" {
  description = "Convenience HTTPS URL of the distribution."
  value       = "https://${aws_cloudfront_distribution.distribution.domain_name}"
}

output "oac_id" {
  description = "Origin Access Control ID."
  value       = aws_cloudfront_origin_access_control.control.id
}
