<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| distribution\_domain\_name | CloudFront distribution domain name (alias target). | `string` | n/a | yes |
| distribution\_hosted\_zone\_id | CloudFront distribution hosted zone ID (always Z2FDTNDATAQYW2). | `string` | n/a | yes |
| aliases | Alternate domain names (CNAMEs). Only applied when a custom cert is set. | `list(string)` | `[]` | no |
| route53\_zone\_id | Route53 zone ID to create alias records in. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| record\_fqdns | FQDNs of the created Route53 records. |
<!-- END_TF_DOCS -->