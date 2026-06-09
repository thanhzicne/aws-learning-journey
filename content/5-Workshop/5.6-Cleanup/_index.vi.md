---
title: "5.6 Cleanup"
date: 2026-05-14
weight: 6
chapter: false
---

# Cleanup

Thực hiện cleanup sau lab để tránh phát sinh chi phí.

```bash
aws cloudformation delete-stack --stack-name ecommerce-network
aws s3 rm s3://pdthanh-ecommerce-assets --recursive
aws s3 rm s3://pdthanh-ecommerce-frontend --recursive
aws s3 rb s3://pdthanh-ecommerce-assets
aws s3 rb s3://pdthanh-ecommerce-frontend
```

Checklist thủ công:

- Xóa RDS instance và snapshot nếu không cần giữ lại.
- Terminate EC2 instances.
- Xóa NAT Gateway và release Elastic IP.
- Xóa CloudWatch alarms, log groups và SNS subscriptions.
- Kiểm tra AWS Billing Dashboard để đảm bảo không còn resource phát sinh chi phí.
