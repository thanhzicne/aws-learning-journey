# 📅 Báo cáo Tuần 1 — AWS Foundation + IAM + Billing

> **Thời gian học:**  (17/04/2026 – 26/04/2026)

---

## 🎯 Mục tiêu tuần này

- [x] Hiểu cấu trúc global của AWS (Regions, AZs, Edge Locations)
- [x] Thiết lập tài khoản an toàn với IAM + MFA
- [x] Cấu hình Budget & Billing Alerts
- [x] Hiểu được IAM role và permission model

---

## 📚 Tài liệu đã học

AWS Cloud Practitioner Essentials (Skill Builder)
YouTube: A Cloud Guru - AWS Global Infrastructure
YouTube: Linux Academy - IAM Deep Dive
AWS Documentation: IAM User Guide

---

## 🔧 Bài tập thực hành

### ✅ Bài tập 1: Tạo AWS Account

Tạo tài khoản AWS với email mới, chọn Free Tier. Đã xác nhận thẻ tín dụng thành công.

> 📸 **Screenshot:** [01-aws-account-created](../../screenshots/week-01/01-aws-account-created.png)

---

### ✅ Bài tập 2: Tạo IAM User

Tạo 2 users:

- `admin-user`: Có `AdministratorAccess` policy
- `dev-user`: Có `PowerUserAccess` policy (không có quyền IAM)

Thêm cả 2 vào Group `Developers`.

```bash
IAM Structure:
├── Group: Developers
│   ├── Policy: PowerUserAccess
│   ├── User: dev-user
│   └── User: admin-user (có thêm AdministratorAccess)
```

> 📸 **Screenshot:** [02-iam-dashboard](../../screenshots/week-01/02-iam-dashboard.png)
> 📸 **Screenshot:** [03-iam-users-created](../../screenshots/week-01/03-iam-users-created.png)

---

### ✅ Bài tập 3: Tìm hiểu CloudWatch

CloudWatch là dịch vụ dùng để giám sát (monitoring) tài nguyên và ứng dụng trên AWS như:

- EC2 (CPU, RAM, Disk)
- RDS
- Lambda
- S3
- Load Balancer
- Billing
- Logs ứng dụng
- Cảnh báo khi hệ thống lỗi

> 📸 **Screenshot:** [04-CloudWatch](../../screenshots/week-01/04-CloudWatch.png)

---

## 💡 Kiến thức quan trọng đã học

### IAM Concepts

- **User:** Người dùng cụ thể (có credentials)
- **Group:** Nhóm user để gán policy chung
- **Role:** Quyền tạm thời cho service/application
- **Policy:** Tài liệu JSON định nghĩa permissions

### Least Privilege Principle
>
> *"Chỉ cấp quyền tối thiểu cần thiết, không cấp dư"*

Ví dụ: Dev chỉ cần quyền EC2 + S3, không cần quyền IAM hay Billing.

### AWS Global Infrastructure

- **Region:** Khu vực địa lý (vd: `ap-southeast-1` = Singapore)
- **Availability Zone:** Data center trong Region (thường 3 AZs/region)
- **Edge Location:** Cache cho CloudFront CDN

---

## ❌ Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Lúc đầu không biết chọn Region nào | Chọn `ap-southeast-1` (Singapore) gần VN nhất, latency thấp |
| Nhầm IAM User và IAM Role | Đọc lại docs, User = người thật, Role = quyền cho service |

---

## 📊 Kết quả đạt được

- ✅ Tạo tài khoản AWS
- ✅ IAM Users & Groups cấu hình đúng theo Least Privilege
- ✅ CloudWatch đang hoạt động
- ✅ Không lo mất tiền ngoài ý muốn

---

## 🔜 Kế hoạch tuần 2

- [ ] Học S3: bucket, object, ACL, policy
- [ ] Tạo S3 bucket `simple-ecommerce-fe`
- [ ] Upload HTML tĩnh và cấu hình Static Website Hosting
- [ ] Test public access qua browser

---

*Cập nhật: 26/04/2026 | [Pham Đuc Thanh]*
