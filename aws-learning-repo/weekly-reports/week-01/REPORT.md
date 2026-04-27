# 📅 Báo cáo Tuần 1 — AWS Foundation + IAM + Billing

> **Thời gian học:**  (17/04/2026 – 26/04/2026)

---

## 🎯 Mục tiêu tuần này

- [x] Hiểu cấu trúc global của AWS (Regions, AZs, Edge Locations)
- [x] CHiểu được Billing and Cost Management
- [x] Hiểu được IAM role và permission model

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
>
> 📸 **Screenshot:** [03-iam-users-created](../../screenshots/week-01/03-iam-users-created.png)

---

### ✅ Bài tập 3: Tìm hiểu Billing and Cost Management

Billing and Cost Management trong Amazon Web Services (AWS) là dịch vụ dùng để theo dõi chi phí, kiểm soát ngân sách và quản lý thanh toán cho toàn bộ tài nguyên AWS đang sử dụng.

Billing and Cost Management giúp:

- Xem tổng chi phí AWS theo ngày / tháng
- Kiểm tra dịch vụ nào đang phát sinh tiền (EC2, RDS, S3…)
- Thiết lập cảnh báo khi gần hết Free Tier
- Tạo ngân sách giới hạn chi tiêu (Budget)
- Tải hóa đơn thanh toán (Invoices)
- Xem lịch sử thanh toán
- Quản lý phương thức thanh toán (Visa/MasterCard)

> 📸 **Screenshot:** [04-billing-and-cost-management](../../screenshots/week-01/04-billing-and-cost-management.png)

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
- ✅ Kiểm tra Billing and Cost Management để theo dõi chi phí
- ✅ Không lo mất tiền ngoài ý muốn

---

## 🔜 Kế hoạch tuần 2

- [ ] Học S3: bucket, object, ACL, policy
- [ ] Tạo S3 bucket `simple-ecommerce-fe`
- [ ] Upload HTML tĩnh và cấu hình Static Website Hosting
- [ ] Test public access qua browser

---

*Cập nhật: 26/04/2026 | [Pham Đuc Thanh]*
