# 📅 Báo cáo Tuần 11 — Optimization + Documentation

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (06/07/2026 – 12/07/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Review & tối ưu chi phí AWS (Cost Explorer)
- [ ] Security audit (IAM, Security Groups)
- [ ] Viết README cho project repo (professional)
- [ ] Tạo Architecture Diagram
- [ ] Viết Deployment Guide chi tiết

---

## 🔧 Bài tập thực hành

### Bước 1: Cost Optimization Review

```
AWS Cost Explorer → xem chi phí từng service:
- EC2: Có thể dùng Spot instance cho non-prod
- RDS: Tắt khi không dùng (dev environment)
- NAT Gateway: Tốn nhiều tiền → review có cần không
- S3: Lifecycle rules cho old objects
```

> 📸 Screenshot: `01-cost-explorer.png`

### Bước 2: Security Audit Checklist

```
IAM:
☐ Root user không dùng hàng ngày
☐ MFA bật cho tất cả users
☐ Access keys rotate định kỳ
☐ Không hardcode credentials trong code

Security Groups:
☐ SSH port 22 chỉ mở cho IP cụ thể
☐ RDS không public access
☐ Không mở port thừa

S3:
☐ Bucket không có sensitive data public
☐ Versioning bật cho production buckets
☐ Lifecycle rules cấu hình
```

### Bước 3: Architecture Diagram

Tạo diagram bằng [draw.io](https://draw.io) hoặc [Lucidchart](https://lucidchart.com):

```
┌──────────────────────────────────────────────────┐
│                   AWS Cloud                       │
│                                                   │
│  ┌─────────────────────────────────────────┐      │
│  │              VPC (10.0.0.0/16)          │      │
│  │                                         │      │
│  │  ┌─────────────┐   ┌─────────────────┐  │      │
│  │  │Public Subnet│   │ Private Subnet  │  │      │
│  │  │             │   │                 │  │      │
│  │  │  ┌───────┐  │   │  ┌──────────┐  │  │      │
│  │  │  │  EC2  │──┼───┼──►   RDS    │  │  │      │
│  │  │  │Spring │  │   │  │  MySQL   │  │  │      │
│  │  │  │ Boot  │  │   │  └──────────┘  │  │      │
│  │  │  └───────┘  │   │                │  │      │
│  │  └─────────────┘   └─────────────────┘  │      │
│  └─────────────────────────────────────────┘      │
│                                                   │
│  ┌─────────┐  ┌───────────┐  ┌────────────────┐  │
│  │   S3    │  │CloudWatch │  │      IAM       │  │
│  │(Static) │  │ Monitoring│  │(Users/Policies)│  │
│  └─────────┘  └───────────┘  └────────────────┘  │
└──────────────────────────────────────────────────┘
          ↑ CI/CD: GitHub Actions
```

> 📸 Screenshot: `02-architecture-diagram.png`

### Bước 4: Professional README cho Project Repo

Viết README với các section:
1. Project Overview + Demo GIF/Screenshot
2. Architecture Diagram
3. Tech Stack
4. Prerequisites
5. Setup & Installation (step by step)
6. Environment Variables
7. API Documentation
8. Deployment Guide
9. Lessons Learned

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
