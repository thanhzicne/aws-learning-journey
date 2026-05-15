---
title: "Worklog Tuần 1"
date: 2026-04-17
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

## Mục tiêu tuần 1

- Hiểu cấu trúc global của AWS (Regions, AZs, Edge Locations).
- Hiểu được Billing and Cost Management.
- Hiểu được IAM role và permission model.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu cấu trúc global AWS (Regions, AZs, Edge Locations). Tạo tài khoản AWS Free Tier | 20/04/2026 | 20/04/2026 | [AWS Free Tier 2025 – Create AWS Account](https://000001.awsstudygroup.com) |
| 3 | Tìm hiểu IAM: User, Group, Role, Policy. Tìm hiểu Least Privilege Principle | 21/04/2026 | 21/04/2026 | [AWS IAM Access Control](https://000002.awsstudygroup.com) |
| 4 | **Thực hành IAM:** Tạo `admin-user` (AdministratorAccess), `dev-user` (PowerUserAccess), Group `Developers` | 22/04/2026 | 22/04/2026 | [AWS IAM Access Control – Create IAM Group and User](https://000002.awsstudygroup.com/2-create-admin-user-and-group/) |
| 5 | Tìm hiểu Billing and Cost Management: xem chi phí, thiết lập cảnh báo Free Tier, tạo Budget | 23/04/2026 | 23/04/2026 | [Cost Management with AWS Budgets](https://000007.awsstudygroup.com) |
| 6 | Ôn tập, tổng hợp kiến thức tuần 1. Viết báo cáo worklog. Lên kế hoạch tuần 2 | 24/04/2026 | 24/04/2026 | |

### Kết quả đạt được tuần 1

- Hiểu cấu trúc global của AWS:
  - **Region:** Khu vực địa lý (vd: `ap-southeast-1` = Singapore)
  - **Availability Zone:** Data center trong Region (thường 3 AZs/region)
  - **Edge Location:** Cache cho CloudFront CDN

#### Bài tập 1: Tạo AWS Account

Tạo tài khoản AWS với email mới, chọn Free Tier. Đã xác nhận thẻ tín dụng thành công.

> **Screenshot:** ![AWS account created](/images/evidence/week-01/01-aws-account-created.png)

#### Bài tập 2: Tạo IAM User

Nắm vững các khái niệm IAM:

- **User:** Người dùng cụ thể (có credentials)
- **Group:** Nhóm user để gán policy chung
- **Role:** Quyền tạm thời cho service/application
- **Policy:** Tài liệu JSON định nghĩa permissions

Tạo 2 users:

- `admin-user`: Có `AdministratorAccess` policy
- `dev-user`: Có `PowerUserAccess` policy (không có quyền IAM)

Thêm cả 2 vào Group `Developers`.

```text
IAM Structure:
├── Group: Developers
│   ├── Policy: PowerUserAccess
│   ├── User: dev-user
│   └── User: admin-user (có thêm AdministratorAccess)
```

> **Screenshot:** ![IAM dashboard](/images/evidence/week-01/02-iam-dashboard.png)
>
> **Screenshot:** ![IAM users created](/images/evidence/week-01/03-iam-users-created.png)

#### Bài tập 3: Tìm hiểu Billing and Cost Management

Billing and Cost Management trong Amazon Web Services (AWS) là dịch vụ dùng để theo dõi chi phí, kiểm soát ngân sách và quản lý thanh toán cho toàn bộ tài nguyên AWS đang sử dụng.

Billing and Cost Management giúp:

- Xem tổng chi phí AWS theo ngày / tháng
- Kiểm tra dịch vụ nào đang phát sinh tiền (EC2, RDS, S3…)
- Thiết lập cảnh báo khi gần hết Free Tier
- Tạo ngân sách giới hạn chi tiêu (Budget)
- Tải hóa đơn thanh toán (Invoices)
- Xem lịch sử thanh toán
- Quản lý phương thức thanh toán (Visa/MasterCard)

> **Screenshot:** ![Billing and cost management](/images/evidence/week-01/04-billing-and-cost-management.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Lúc đầu không biết chọn Region nào | Chọn `ap-southeast-1` (Singapore) gần VN nhất, latency thấp |
| Nhầm IAM User và IAM Role | Đọc lại docs, User = người thật, Role = quyền cho service |

## Kế hoạch tuần 2

- Nắm vững S3: bucket, object, storage classes.
- Hiểu ACL, Bucket Policy, Public Access settings.
- Triển khai Static Website Hosting trên S3.
- Quản lý object versioning & lifecycle.
