---
title: "Testing and monitoring"
date: 2026-05-14
weight: 5
chapter: false
---

# Testing, Logs, Metrics, and Alerts

## Functional test

```bash
curl http://<EC2_PUBLIC_IP>/health
curl http://<EC2_PUBLIC_IP>/api/products
```

Expected result:

- `/health` returns `200 OK`.
- `/api/products` returns JSON data from RDS.

## Database test

```bash
mysql -h <RDS_ENDPOINT> -u app_user -p ecommerce
select count(*) from products;
```

## S3 upload test

```bash
aws s3 cp sample-product.jpg s3://pdthanh-ecommerce-assets/products/
aws s3 ls s3://pdthanh-ecommerce-assets/products/
```

## Logs and metrics

- Check EC2 CPU, network, and status checks in CloudWatch Metrics.
- Check backend application logs in `/aws/ec2/ecommerce-backend`.
- Trigger a CPU alarm or stop the backend container to validate alerting.

Week 4 networking evidence:

![Security groups](/images/evidence/week-04/06-security-groups.png)
![Flow logs](/images/evidence/week-04/10-flow-logs.png)
