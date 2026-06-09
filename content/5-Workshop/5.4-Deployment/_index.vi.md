---
title: "5.4 Các bước triển khai"
date: 2026-05-14
weight: 4
chapter: false
---

# Các bước triển khai

## Bước 1: Tạo network

Tạo nền tảng VPC từ template đính kèm:

```bash
aws cloudformation deploy \
  --template-file static/files/cloudformation/network.yml \
  --stack-name ecommerce-network \
  --capabilities CAPABILITY_NAMED_IAM
```

Template chủ động chỉ tạo network foundation chi phí thấp. Chỉ thêm NAT Gateway khi private instances cần outbound internet, rồi xóa sau khi test.

Minh chứng Week 4:

![VPC created](/images/evidence/week-04/01-vpc-created.png)
![Subnets created](/images/evidence/week-04/02-subnets-created.png)

## Bước 2: Tạo S3 buckets

```bash
aws s3 mb s3://pdthanh-ecommerce-assets
aws s3 mb s3://pdthanh-ecommerce-frontend
```

Bật static website hosting hoặc dùng CloudFront để phân phối HTTPS.

## Bước 3: Launch backend EC2

- AMI: Ubuntu LTS.
- Subnet: public subnet.
- Security Group: SSH từ My IP và HTTP/HTTPS từ user.
- IAM role: quyền đọc/ghi S3 image bucket và ghi CloudWatch Logs.

Cài Docker và chạy backend:

```bash
chmod +x static/files/scripts/deploy-backend.sh
./static/files/scripts/deploy-backend.sh
```

## Bước 4: Tạo RDS MySQL

- Engine: MySQL.
- Public access: disabled.
- Subnet group: private subnets.
- Security Group inbound: MySQL 3306 chỉ từ backend EC2 SG.

## Bước 5: Deploy frontend

```bash
npm ci
npm run build
aws s3 sync dist/ s3://pdthanh-ecommerce-frontend --delete
```

## Bước 6: Cấu hình monitoring

- Cài CloudWatch Agent trên EC2.
- Tạo log group `/aws/ec2/ecommerce-backend`.
- Tạo alarm cho CPU và API error.
- Subscribe email vào SNS topic.
