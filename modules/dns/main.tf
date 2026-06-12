resource "aws_route53_record" "this" {
  for_each = local.records

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type


  alias {
    name                   = var.distribution_domain_name
    zone_id                = var.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
