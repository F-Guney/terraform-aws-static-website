output "site_bucket_id" {
  description = "ID of the bucket for site"
  value       = aws_s3_bucket.site.id
}

output "site_bucket_arn" {
  description = "ARN of the bucket for site"
  value       = aws_s3_bucket.site.arn
}

output "site_bucket_regional_domain_name" {
  description = "Regional domain name of the bucket for site"
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}

output "logs_bucket_id" {
  description = "ID of the bucket for logs"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN of the bucket for logs"
  value       = aws_s3_bucket.logs.arn
}

output "site_files_hash" {
  description = "Hash that changes when any uploaded file changes — feed to terraform_data.invalidate."
  value       = sha1(jsonencode({ for k, v in aws_s3_object.files : k => v.etag }))
}
