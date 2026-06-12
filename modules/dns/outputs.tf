output "record_fqdns" {
  description = "FQDNs of the created Route53 records."
  value       = [for r in aws_route53_record.this : r.fqdn]
}
