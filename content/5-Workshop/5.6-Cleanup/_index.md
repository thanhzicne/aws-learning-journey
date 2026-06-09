---
title: "5.6 Cleanup"
date: 2026-05-14
weight: 6
chapter: false
---

# Cleanup

Run cleanup after the lab to avoid unnecessary cost.

```bash
aws cloudformation delete-stack --stack-name ecommerce-network
aws s3 rm s3://pdthanh-ecommerce-assets --recursive
aws s3 rm s3://pdthanh-ecommerce-frontend --recursive
aws s3 rb s3://pdthanh-ecommerce-assets
aws s3 rb s3://pdthanh-ecommerce-frontend
```

Manual checklist:

- Delete RDS instance and snapshots if they are no longer needed.
- Terminate EC2 instances.
- Delete NAT Gateway and release Elastic IP.
- Delete CloudWatch alarms, log groups, and SNS subscriptions.
- Confirm AWS Billing Dashboard shows no unexpected active resources.
