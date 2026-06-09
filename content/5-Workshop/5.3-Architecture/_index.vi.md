---
title: "5.3 Kiến trúc"
date: 2026-05-14
weight: 3
chapter: false
---

# Kiến trúc

![E-commerce AWS architecture](/images/workshop/ecommerce-architecture.svg)

## Lý do chọn dịch vụ

| Dịch vụ | Mục đích | Lý do |
|---|---|---|
| VPC | Cô lập network | Tách public/private resources rõ ràng. |
| EC2 | Runtime cho backend | Phù hợp để học Linux, SSH, deployment và logs. |
| RDS MySQL | Database sản phẩm | Managed backup, patching và đặt trong private subnet. |
| S3 | Lưu ảnh sản phẩm và frontend assets | Object storage chi phí thấp, hỗ trợ static hosting. |
| IAM | Kiểm soát truy cập | Least privilege cho EC2 truy cập S3/CloudWatch. |
| CloudWatch | Logs, metrics, alarms | Hỗ trợ troubleshoot và quan sát vận hành. |
| SNS | Notification | Gửi thông báo khi alarm kích hoạt. |

## Bảo mật cơ bản

- RDS không public.
- Security Group chỉ cho MySQL từ backend EC2.
- EC2 role chỉ có quyền cần thiết với S3 bucket và CloudWatch Logs.
- Không hard-code access key trong source code.
