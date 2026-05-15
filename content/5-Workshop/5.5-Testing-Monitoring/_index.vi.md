---
title: "Kiểm thử và monitoring"
date: 2026-05-14
weight: 5
chapter: false
---

# Kiểm thử, log, metric và alert

## Kiểm thử chức năng

```bash
curl http://<EC2_PUBLIC_IP>/health
curl http://<EC2_PUBLIC_IP>/api/products
```

Kết quả mong đợi:

- `/health` trả về `200 OK`.
- `/api/products` trả về JSON data từ RDS.

## Kiểm thử database

```bash
mysql -h <RDS_ENDPOINT> -u app_user -p ecommerce
select count(*) from products;
```

## Kiểm thử upload S3

```bash
aws s3 cp sample-product.jpg s3://pdthanh-ecommerce-assets/products/
aws s3 ls s3://pdthanh-ecommerce-assets/products/
```

## Logs và metrics

- Kiểm tra EC2 CPU, network và status checks trong CloudWatch Metrics.
- Kiểm tra application logs ở `/aws/ec2/ecommerce-backend`.
- Kích hoạt thử CPU alarm hoặc stop backend container để validate alert.

Minh chứng networking Week 4:

![Security groups](/images/evidence/week-04/06-security-groups.png)
![Flow logs](/images/evidence/week-04/10-flow-logs.png)
