# storage

Creates the S3 origin bucket and a sibling access-log bucket for a static site, and uploads files from a local directory.

## Usage

```hcl
module "storage" {
  source = "./modules/storage"

  bucket_name     = "my-portfolio-site"
  site_source_dir = "${path.module}/site"
  tags            = { Project = "portfolio" }
}
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| bucket\_name | Unique S3 bucket name for the site origin (must follow S3 naming rules). | `string` | n/a | yes |
| site\_source\_dir | Local directory whose contents will be uploaded to the origin bucket. | `string` | n/a | yes |
| kms\_key\_arn | KMS key ARN (in the bucket's region) for SSE-KMS. Null uses SSE-S3 (AES256). | `string` | `null` | no |
| logs\_bucket\_suffix | Suffix appended to bucket\_name to derive the logs bucket name. | `string` | `"-logs"` | no |
| logs\_retention\_days | Days to retain access logs before lifecycle expiration. | `number` | `30` | no |
| tags | Tags applied to every resource the module creates. | `map(string)` | `{}` | no |
| versioning\_enabled | Toggle S3 object versioning on the origin bucket. | `bool` | `true` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| logs\_bucket\_arn | ARN of the logs bucket. |
| logs\_bucket\_id | ID of the logs bucket. |
| origin\_bucket\_arn | ARN of the origin bucket. |
| origin\_bucket\_id | ID of the origin bucket. |
| origin\_bucket\_regional\_domain\_name | Regional domain name of the origin bucket. |
| site\_files\_hash | Hash that changes when any uploaded file changes — feed to terraform\_data.invalidate. |
<!-- END_TF_DOCS -->
