# 📅 Báo cáo Tuần 5 — RDS + Database

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (25/05/2026 – 31/05/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Tạo RDS MySQL instance (db.t2.micro Free Tier)
- [ ] Đặt RDS trong private subnet (chỉ EC2 mới access được)
- [ ] Kết nối RDS từ EC2 qua MySQL client
- [ ] Import database schema và sample data

---

## 📚 Tài liệu đã học

| Tài nguyên | Thời gian | Ghi chú |
|---|---|---|
| AWS Docs: RDS User Guide | | |
| YouTube: Techwith Tim - RDS Setup | 25 phút | |

---

## 🔧 Bài tập thực hành

### Bước 1: Tạo RDS MySQL

Cấu hình:
- Engine: MySQL 8.0
- Template: **Free Tier**
- Instance class: `db.t2.micro`
- Storage: 20GB gp2
- Multi-AZ: No
- Subnet: private-subnet trong VPC của mình
- Public access: **No**

> 📸 Screenshot: `01-rds-created.png`

### Bước 2: Security Group cho RDS

| Rule | Protocol | Port | Source |
|---|---|---|---|
| MySQL/Aurora | TCP | 3306 | EC2 Security Group ID |

> ⚠️ **QUAN TRỌNG:** Chỉ cho EC2 security group access, KHÔNG mở public

### Bước 3: Connect từ EC2

```bash
# SSH vào EC2 trước
ssh -i key.pem ubuntu@<EC2-IP>

# Cài MySQL client
sudo apt install mysql-client -y

# Connect vào RDS
mysql -h <RDS-ENDPOINT> -u admin -p<password>

# Test
SHOW DATABASES;
SELECT VERSION();
```

> 📸 Screenshot: `02-rds-connected.png`

### Bước 4: Import Schema & Data

```sql
CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description TEXT,
  image_url VARCHAR(500),
  stock INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO products (name, price, description, stock) VALUES 
  ('Laptop Gaming', 25000000, 'Laptop gaming hiệu năng cao', 10),
  ('Điện thoại', 15000000, 'Smartphone flagship', 25),
  ('Tai nghe', 2000000, 'Tai nghe noise-cancelling', 50);

SELECT * FROM products;
```

> 📸 Screenshot: `03-schema-imported.png`

---

## 💡 Kiến thức quan trọng đã học

### RDS vs Self-managed MySQL

| | RDS | Tự cài MySQL trên EC2 |
|---|---|---|
| Backup | Tự động | Tự làm |
| Patching | AWS lo | Tự làm |
| Multi-AZ | Click chuột | Phức tạp |
| Chi phí | Cao hơn | Thấp hơn |
| Use case | Production | Học tập / Dev |

### Connection Security
RDS trong private subnet → chỉ có EC2 trong cùng VPC mới connect được → đây là **best practice** cho production.

> ✏️ *Điền thêm khi học xong*

---

## ❌ Khó khăn gặp phải

> ✏️ *Ghi lại vấn đề và cách giải*

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
