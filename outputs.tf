output "bucket_name" {
  description = "Name of the bucket for site"
  value       = aws_s3_bucket.bucket.id
}

output "cloudfront_url" {
  description = "Public HTTPS URL of the distribution. Use this in browsers and smoke tests."
  value       = "https://${aws_cloudfront_distribution.distribution.domain_name}"
}

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.id
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "oac_id" {
  description = "ID of the origin access control"
  value       = aws_cloudfront_origin_access_control.bucket.id
}
