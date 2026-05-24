# 1. Use Origin Access Control (OAC) instead of Origin Access Identity (OAI)

- **Status:** Accepted — 2026-05-24

## Context

CloudFront must read from a private S3 origin without making the bucket public. AWS offers two mechanisms: the legacy Origin Access Identity (OAI) and its successor Origin Access Control (OAC).

## Decision

Use `aws_cloudfront_origin_access_control` with `signing_protocol = "sigv4"` and `signing_behavior = "always"`. The bucket policy grants `s3:GetObject` to the `cloudfront.amazonaws.com` service principal, scoped by an `AWS:SourceArn` condition pinned to this distribution.

## Consequences

- SigV4 supports origins OAI cannot reach: SSE-KMS-encrypted buckets, S3 cross-region replication, and S3 access points.
- No separate managed identity to track or rotate; permissions live entirely in the bucket policy.
