# cdn

Creates a CloudFront distribution in front of an S3 origin, with Origin Access Control and a bucket policy that restricts S3 reads to this distribution.

## Usage

```hcl
module "cdn" {
  source = "./modules/cdn"

  name_prefix                   = "portfolio-dev"
  origin_bucket_id              = module.storage.site_bucket_id
  origin_bucket_arn             = module.storage.site_bucket_arn
  origin_bucket_regional_domain = module.storage.site_bucket_regional_domain_name
  logging_bucket_id             = module.storage.logs_bucket_id
  logging_bucket_arn            = module.storage.logs_bucket_arn
  tags                          = { Project = "portfolio" }
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| logging\_bucket\_arn | ARN of the S3 bucket for logs | `string` | n/a | yes |
| logging\_bucket\_id | ID of the S3 bucket for logs | `string` | n/a | yes |
| name\_prefix | Prefix for the OAC and origin-id naming | `string` | n/a | yes |
| origin\_bucket\_arn | ARN of the origin bucket | `string` | n/a | yes |
| origin\_bucket\_id | ID of the S3 bucket serving as the origin | `string` | n/a | yes |
| origin\_bucket\_regional\_domain | Bucket regional domain of the origin. | `string` | n/a | yes |
| acm\_certificate\_arn | ARN of an ACM certificate in us-east-1. Null uses the default *.cloudfront.net cert. | `string` | `null` | no |
| aliases | Alternate domain names (CNAMEs). Only applied when a custom cert is set. | `list(string)` | `[]` | no |
| default\_root\_object | Default object served at / | `string` | `"index.html"` | no |
| price\_class | CloudFront price class. Defaults to PriceClass\_100 for portfolio cost. | `string` | `"PriceClass_100"` | no |
| tags | Tags applied to every resource the module creates. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| distribution\_arn | CloudFront distribution ARN. |
| distribution\_id | CloudFront distribution ID |
| domain\_name | Public CloudFront domain |
| oac\_id | Origin Access Control ID. |
| url | Convenience HTTPS URL of the distribution. |
<!-- END_TF_DOCS -->
