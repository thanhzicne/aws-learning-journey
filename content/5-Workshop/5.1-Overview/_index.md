---
title: "Workshop overview"
date: 2026-05-14
weight: 1
chapter: false
---

## Scenario

A small shop wants to publish a product catalog. Admins can manage products through a backend API, product data is stored in MySQL, and images are stored in S3.

## Expected output

- A React frontend hosted as static assets.
- A Spring Boot API running on EC2.
- RDS MySQL reachable only from the application security group.
- Product images stored in S3.
- CloudWatch logs, metrics, and alarms for basic operations.

## Success criteria

- Browser can load the frontend.
- API `/health` returns `200 OK`.
- Backend can read/write product data in RDS.
- Image upload reaches S3.
- CloudWatch records logs and an alarm can notify through SNS.
