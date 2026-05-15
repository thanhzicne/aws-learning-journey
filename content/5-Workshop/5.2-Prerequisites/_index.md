---
title: "Prerequisites"
date: 2026-05-14
weight: 2
chapter: false
---

# Prerequisites

| Requirement | Value |
|---|---|
| AWS account | Free Tier capable account |
| Region | `ap-southeast-1` |
| Tools | AWS CLI, Git, Docker, Java 17, Node.js 20 |
| IAM permissions | VPC, EC2, RDS, S3, IAM, CloudWatch, SNS, CloudFormation |
| Local source | Backend, frontend, Dockerfile, and deployment script |

Configure AWS CLI:

```bash
aws configure
aws sts get-caller-identity
```

Download attachments:

- [CloudFormation network template](/files/cloudformation/network.yml)
- [Backend Dockerfile](/files/docker/Dockerfile)
- [Deploy script](/files/scripts/deploy-backend.sh)
