---
title: "Deployment steps"
date: 2026-05-14
weight: 4
chapter: false
---

# Deployment Steps

## Step 1: Create network

Create the VPC foundation from the provided template:

```bash
aws cloudformation deploy \
  --template-file static/files/cloudformation/network.yml \
  --stack-name ecommerce-network \
  --capabilities CAPABILITY_NAMED_IAM
```

The template intentionally creates the low-cost network foundation. Add NAT Gateway only when private instances need outbound internet access, then delete it after testing.

Week 4 evidence:

![VPC created](/images/evidence/week-04/01-vpc-created.png)
![Subnets created](/images/evidence/week-04/02-subnets-created.png)

## Step 2: Create S3 buckets

```bash
aws s3 mb s3://pdthanh-ecommerce-assets
aws s3 mb s3://pdthanh-ecommerce-frontend
```

Enable static website hosting or use CloudFront for HTTPS delivery.

## Step 3: Launch backend EC2

- AMI: Ubuntu LTS.
- Subnet: public subnet.
- Security Group: allow SSH from My IP and HTTP/HTTPS from users.
- IAM role: S3 read/write for the image bucket and CloudWatch Logs write.

Install Docker and run the backend:

```bash
chmod +x static/files/scripts/deploy-backend.sh
./static/files/scripts/deploy-backend.sh
```

## Step 4: Create RDS MySQL

- Engine: MySQL.
- Public access: disabled.
- Subnet group: private subnets.
- Security Group inbound: MySQL 3306 only from backend EC2 SG.

## Step 5: Deploy frontend

```bash
npm ci
npm run build
aws s3 sync dist/ s3://pdthanh-ecommerce-frontend --delete
```

## Step 6: Configure monitoring

- Install CloudWatch Agent on EC2.
- Create log group `/aws/ec2/ecommerce-backend`.
- Create CPU and API error alarms.
- Subscribe email to SNS topic.
