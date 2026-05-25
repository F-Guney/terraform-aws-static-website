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
| enable\_versioning | Toggle S3 object versioning on the origin bucket. | `bool` | `true` | no |
| logs\_bucket\_suffix | Suffix appended to bucket\_name to derive the logs bucket name. | `string` | `"-logs"` | no |
| logs\_retention\_days | Days to retain access logs before lifecycle expiration. | `number` | `30` | no |
| tags | Tags applied to every resource the module creates. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| logs\_bucket\_domain\_name | Domain name of the bucket for logs |
| logs\_bucket\_id | ID of the bucket for logs |
| site\_bucket\_arn | ARN of the bucket for site |
| site\_bucket\_id | ID of the bucket for site |
| site\_bucket\_regional\_domain\_name | Regional domain name of the bucket for site |
| site\_files\_hash | Hash that changes when any uploaded file changes — feed to terraform\_data.invalidate. |
<!-- END_TF_DOCS -->
