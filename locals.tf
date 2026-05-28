locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    CostCenter  = var.cost_center
    Repository  = "github.com/F-Guney/terraform-aws-static-website"
  }

  name_prefix = "${var.project}-${var.environment}"
}
