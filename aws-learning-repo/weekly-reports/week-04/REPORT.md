# 📅 Báo cáo Tuần 4 — VPC + Networking

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (18/05/2026 – 24/05/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Hiểu VPC: subnets, CIDR, route tables, internet gateway
- [ ] Tạo Custom VPC với public và private subnet
- [ ] Cấu hình NAT Gateway cho private subnet
- [ ] Di chuyển EC2 vào VPC mới, kiểm tra connectivity

---

## 📚 Tài liệu đã học

| Tài nguyên | Thời gian | Ghi chú |
|---|---|---|
| *(Điền khi bắt đầu học)* | | |

---

## 🔧 Bài tập thực hành

### Bước 1: Tạo VPC

- CIDR: `10.0.0.0/16`
- Name: `ecommerce-vpc`

> 📸 Screenshot: `01-vpc-created.png`

### Bước 2: Tạo Subnets

| Tên | CIDR | AZ | Loại |
|---|---|---|---|
| public-subnet-1a | 10.0.1.0/24 | ap-southeast-1a | Public |
| private-subnet-1b | 10.0.2.0/24 | ap-southeast-1b | Private |

### Bước 3: Internet Gateway + Route Table

Tạo Internet Gateway → Attach vào VPC → Tạo Route Table cho public subnet:
- Route: `0.0.0.0/0` → Internet Gateway

### Bước 4: NAT Gateway

Cho phép private subnet ra internet (update packages) mà không cần IP public.

### Bước 5: Launch EC2 vào VPC mới

Test SSH vào EC2 public subnet → ping internet thành công.

---

## 💡 Kiến thức quan trọng đã học

### VPC Architecture Overview

```
VPC (10.0.0.0/16)
├── Public Subnet (10.0.1.0/24)
│   ├── Route: 0.0.0.0/0 → Internet Gateway
│   └── EC2 Web Server (Public IP)
│
└── Private Subnet (10.0.2.0/24)
    ├── Route: 0.0.0.0/0 → NAT Gateway
    └── EC2 App Server / RDS (No Public IP)
```

> ✏️ *Điền thêm kiến thức khi học xong*

---

## ❌ Khó khăn gặp phải

> ✏️ *Ghi lại vấn đề và cách giải*

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| Thứ 2 | | |
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
