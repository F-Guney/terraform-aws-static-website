output "origin_bucket_id" {
  description = "ID of the origin bucket."
  value       = aws_s3_bucket.origin.id
}

output "origin_bucket_arn" {
  description = "ARN of the origin bucket."
  value       = aws_s3_bucket.origin.arn
}

output "origin_bucket_regional_domain_name" {
  description = "Regional domain name of the origin bucket."
  value       = aws_s3_bucket.origin.bucket_regional_domain_name
}

output "logs_bucket_id" {
  description = "ID of the logs bucket (created or bring-your-own)."
  value       = local.logs_bucket_id
}

output "logs_bucket_arn" {
  description = "ARN of the logs bucket (created or bring-your-own)."
  value       = local.logs_bucket_arn
}

output "site_files_hash" {
  description = "Hash that changes when any uploaded file changes — feed to terraform_data.invalidate."
  value       = sha1(jsonencode({ for k, v in aws_s3_object.files : k => v.etag }))
}
