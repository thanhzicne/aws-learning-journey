---
title: "Điều kiện tiên quyết"
date: 2026-05-14
weight: 2
chapter: false
---

# Điều kiện tiên quyết

| Yêu cầu | Giá trị |
|---|---|
| AWS account | Tài khoản có thể dùng Free Tier |
| Region | `ap-southeast-1` |
| Công cụ | AWS CLI, Git, Docker, Java 17, Node.js 20 |
| Quyền IAM | VPC, EC2, RDS, S3, IAM, CloudWatch, SNS, CloudFormation |
| Source local | Backend, frontend, Dockerfile và script deploy |

Cấu hình AWS CLI:

```bash
aws configure
aws sts get-caller-identity
```

File đính kèm:

- [CloudFormation network template](/files/cloudformation/network.yml)
- [Backend Dockerfile](/files/docker/Dockerfile)
- [Deploy script](/files/scripts/deploy-backend.sh)
