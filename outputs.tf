output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.distribution.domain_name}"
}

output "distribution_id" {
  value = aws_cloudfront_distribution.distribution.id
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "oac_id" {
  value = aws_cloudfront_origin_access_control.bucket.id
}
