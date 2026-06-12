output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "Public CloudFront domain"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "url" {
  description = "Convenience HTTPS URL of the distribution."
  value       = "https://${aws_cloudfront_distribution.this.domain_name}"
}

output "oac_id" {
  description = "Origin Access Control ID."
  value       = aws_cloudfront_origin_access_control.this.id
}

output "hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID (for Route53 alias records)."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
