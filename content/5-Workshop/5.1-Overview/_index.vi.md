---
title: "Tổng quan workshop"
date: 2026-05-14
weight: 1
chapter: false
---

## Bối cảnh

Một cửa hàng nhỏ cần đưa danh mục sản phẩm lên internet. Admin quản lý sản phẩm qua backend API, dữ liệu lưu trong MySQL và ảnh sản phẩm lưu trên S3.

## Output mong muốn

- React frontend được host dạng static assets.
- Spring Boot API chạy trên EC2.
- RDS MySQL chỉ cho application security group truy cập.
- Ảnh sản phẩm lưu trên S3.
- CloudWatch logs, metrics và alarms cho vận hành cơ bản.

## Tiêu chí thành công

- Browser load được frontend.
- API `/health` trả về `200 OK`.
- Backend đọc/ghi được dữ liệu sản phẩm trong RDS.
- Upload ảnh thành công lên S3.
- CloudWatch ghi log và alarm có thể gửi thông báo qua SNS.
