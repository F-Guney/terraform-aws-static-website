# terraform-aws-static-website

Terraform that provisions an S3 + CloudFront (OAC) stack to host a static site on AWS.

## Architecture

```mermaid
flowchart LR
    user([User])
    cf[CloudFront<br/>HTTPS · OAC]
    s3[(S3 bucket<br/>private)]
    logs[(S3 logs bucket<br/>30d lifecycle)]
    user -->|HTTPS| cf
    cf -->|sigv4 via OAC| s3
    cf -.access logs.-> logs
    s3 -.access logs.-> logs
```

## What you get

- Private S3 origin (public access blocked, AES256 SSE, versioning on)
- CloudFront distribution with OAC, HTTPS-only viewer policy, `PriceClass_100` (US + EU + IL) by default
- Per-extension cache headers on uploads: HTML revalidates every 5 min, JS/CSS cached for a year (`immutable`), images 1 day
- Sibling logs bucket capturing both S3 and CloudFront access logs, expiring after 30 days
- `default_tags` propagating `Project`, `Environment`, `Owner`, `CostCenter`, `Repository` to every taggable resource

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| bucket\_name | Globally-unique S3 bucket name for the site origin. | `string` | n/a | yes |
| project | Project name. | `string` | n/a | yes |
| aws\_region | AWS region to deploy resources to | `string` | `"eu-central-1"` | no |
| cloudfront\_price\_class | CloudFront price class. | `string` | `"PriceClass_100"` | no |
| cost\_center | Billing identifier used to attribute spend in AWS Cost Explorer. Tag value, not a real charge code for portfolio use. | `string` | `"personal"` | no |
| default\_root\_object | Object CloudFront serves at the distribution root. | `string` | `"index.html"` | no |
| environment | Environment name. | `string` | `"dev"` | no |
| owner | Owner of the project. | `string` | `"demoadmin"` | no |
| site\_source\_dir | Local directory uploaded to the origin bucket. | `string` | `"site"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| bucket\_arn | ARN of the bucket |
| bucket\_name | Name of the bucket for site |
| cloudfront\_url | Public HTTPS URL of the distribution. Use this in browsers and smoke tests. |
| distribution\_domain\_name | Domain name of the CloudFront distribution |
| distribution\_id | ID of the CloudFront distribution |
| oac\_id | ID of the origin access control |
<!-- END_TF_DOCS -->

## Cost notes

Costs come from CloudFront egress/requests and S3 storage. Idle portfolio traffic typically sits inside AWS free-tier limits; once that expires, the bill is dominated by per-GB egress at the `PriceClass_100` rate. Access logs are bounded by the 30-day lifecycle. No Route 53, ACM, or WAF charges in this baseline.

## Design notes

- **OAC over OAI** — CloudFront reads the private origin with SigV4 via Origin Access Control. Rationale in [`docs/decisions/0001-oac-over-oai.md`](docs/decisions/0001-oac-over-oai.md).
- **Public access blocked on every bucket** — both origin and logs apply the four-flag `aws_s3_bucket_public_access_block`.
- **HTTPS-only viewer policy** — `redirect-to-https` on the default CloudFront cert.

## Prerequisites

- Terraform `>= 1.6`
- AWS credentials with permission to create S3 buckets and CloudFront distributions
- A globally-unique S3 bucket name

## Quickstart

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set bucket_name and project
terraform init
terraform plan
terraform apply
```

The `cloudfront_url` output is the public URL. First-deploy propagation takes a few minutes.

## Updating the site

Edit anything under `site/`, then re-run `terraform apply`. CloudFront is invalidated automatically on every file change, so updates show up within ~30 seconds instead of waiting for the cache TTL.

## Cleanup

```bash
terraform destroy
```

If the bucket isn't empty: `aws s3 rm s3://<BUCKET_NAME> --recursive`, then destroy.
