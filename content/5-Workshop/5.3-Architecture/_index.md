---
title: "Architecture"
date: 2026-05-14
weight: 3
chapter: false
---

# Architecture

![E-commerce AWS architecture](/images/workshop/ecommerce-architecture.svg)

## Service choices

| Service | Purpose | Reason |
|---|---|---|
| VPC | Network isolation | Separates public and private resources. |
| EC2 | Backend runtime | Simple for learning Linux, SSH, deployment, and logs. |
| RDS MySQL | Product database | Managed backups, patching, and private subnet placement. |
| S3 | Product images and frontend assets | Low-cost object storage and static hosting. |
| IAM | Access control | Least privilege for EC2 to reach S3/CloudWatch. |
| CloudWatch | Logs, metrics, alarms | Troubleshooting and operational visibility. |
| SNS | Notifications | Sends alarm notifications. |

## Security baseline

- RDS is not publicly accessible.
- Security Group allows MySQL only from backend EC2.
- EC2 role grants only required S3 bucket and CloudWatch Logs actions.
- No access keys are stored in source code.
