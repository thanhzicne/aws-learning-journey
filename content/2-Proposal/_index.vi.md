---
title: "Proposal"
date: 2026-05-14
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## Tổng quan

Dự án triển khai một hệ thống e-commerce nhỏ trên AWS, gồm React frontend, Spring Boot backend, MySQL database, nơi lưu ảnh sản phẩm và phần giám sát vận hành.

## Mục tiêu

- Xây dựng ứng dụng end-to-end trên AWS bằng các dịch vụ managed/scalable.
- Giữ database ở private subnet và chỉ public các entry point cần thiết.
- Có log, metric, alarm và cleanup để kiểm soát chi phí.

## Vấn đề cần giải quyết

Một cửa hàng nhỏ cần hệ thống danh mục sản phẩm dễ triển khai, an toàn cơ bản và đủ khả năng quan sát để xử lý lỗi.

## Kiến trúc giải pháp

![Architecture](/images/workshop/ecommerce-architecture.svg)

Dịch vụ AWS chính: VPC, EC2, RDS MySQL, S3, CloudFront, IAM, CloudWatch, SNS và có thể mở rộng thêm ALB/Auto Scaling.

## Timeline

| Giai đoạn | Thời gian | Kết quả |
| --- | --- | --- |
| Foundation | Week 1-4 | AWS account, S3, EC2, VPC |
| Data và app | Week 5-8 | RDS, backend API, frontend |
| DevOps | Week 9-11 | Docker, CI/CD, monitoring |
| Hoàn thiện | Week 12 | Workshop website và báo cáo cuối khóa |

## Ngân sách

Dự án ưu tiên Free Tier. NAT Gateway, ALB, RDS và CloudWatch alarms có thể phát sinh chi phí, vì vậy cần cleanup sau khi lab.

## Rủi ro

| Rủi ro | Giải pháp |
| --- | --- |
| Phát sinh chi phí ngoài dự kiến | Cấu hình budget alert và cleanup sau khi test. |
| Database bị public | Đặt RDS trong private subnet và giới hạn Security Group chỉ từ app tier. |
| Lộ credentials | Dùng biến môi trường hoặc AWS Secrets Manager. |
| Triển khai không nhất quán | Dùng CloudFormation/CLI và ghi rõ lệnh validation. |
