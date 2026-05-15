---
title: "Worklog Tuần 5"
date: 2026-05-14
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

## Mục tiêu tuần 5

- Tạo RDS MySQL instance (db.t2.micro Free Tier).
- Đặt RDS trong private subnet (chỉ EC2 mới access được).
- Kết nối RDS từ EC2 qua MySQL client.
- Import database schema và sample data.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu RDS: managed vs self-managed. Tạo DB Security Group và DB Subnet Group | 18/05/2026 | 18/05/2026 | [Prerequisite Steps – Lab 000005](https://000005.awsstudygroup.com/2-prerequiste/) |
| 3 | Tạo RDS MySQL 8.0 instance (db.t2.micro, Free Tier) trong private subnet | 19/05/2026 | 19/05/2026 | [Create MySQL DB Instance – Lab 000005](https://000005.awsstudygroup.com/4-createdbinstance/4.1-cretaemysqldbinstance/) |
| 4 | **Thực hành kết nối:** SSH vào EC2, cài MySQL client, connect vào RDS endpoint | 20/05/2026 | 20/05/2026 | [Connect DB Instance – Lab 000005](https://000005.awsstudygroup.com/4-createdbinstance/4.2-connectmysqldbinstance/) |
| 5 | Import schema ecommerce và sample data (products table). Test query | 21/05/2026 | 21/05/2026 | [Application Deployment – Lab 000005](https://000005.awsstudygroup.com/5-deploy-app/) |
| 6 | Ôn tập, tổng hợp kiến thức tuần 5. Viết báo cáo worklog. Lên kế hoạch tuần 6 | 22/05/2026 | 22/05/2026 | |

### Kết quả đạt được tuần 5

- RDS MySQL instance chạy trong private subnet, không accessible từ internet.
- Kết nối thành công từ EC2 qua MySQL client.
- Schema `ecommerce` và bảng `products` tạo thành công.
- Confirm: EC2 (public) → RDS (private) kết nối được, internet không vào được RDS trực tiếp.

#### Bài tập 1: Tạo DB Security Group & DB Subnet Group

Tạo Security Group `db-server-sg` trong `ecommerce-vpc`:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| MySQL/Aurora | TCP | 3306 | `web-server-sg` (Security Group ID) | Chỉ EC2 mới vào được RDS |

> **Lưu ý bảo mật:** Source là Security Group ID của EC2, không mở public IP — đây là best practice cho production.

Tạo DB Subnet Group `rds-subnet-group`:

- VPC: `ecommerce-vpc`
- Subnets: `private-subnet-1a` và `private-subnet-1b` (bắt buộc ít nhất 2 AZ để hỗ trợ Multi-AZ sau này)

> **Screenshot:** ![DB Security Group and Subnet Group](/screenshots/week-05/01-rds-prereq.png)

#### Bài tập 2: Tạo RDS MySQL Instance

Vào RDS Console → Databases → Create database:

| Tham số | Giá trị |
| :--- | :--- |
| Engine | MySQL 8.0 |
| Template | **Free Tier** |
| Instance class | `db.t2.micro` |
| Storage | 20 GB gp2 |
| Multi-AZ | No |
| Subnet group | `rds-subnet-group` |
| Public access | **No** |
| Security Group | `db-server-sg` |

Nắm vững sự khác biệt giữa RDS và tự cài MySQL trên EC2:

| | RDS | Tự cài MySQL trên EC2 |
| :--- | :--- | :--- |
| Backup | Tự động | Tự làm |
| Patching | AWS lo | Tự làm |
| Multi-AZ | Click chuột | Phức tạp |
| Chi phí | Cao hơn | Thấp hơn |
| Use case | Production | Học tập / Dev |

> **Screenshot:** ![RDS created](/screenshots/week-05/01-rds-created.png)

#### Bài tập 3: Kết nối RDS từ EC2

```bash
# SSH vào EC2 trước
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Cài MySQL client
sudo apt install mysql-client -y

# Connect vào RDS
mysql -h <RDS-ENDPOINT> -u admin -p<password>

# Test kết nối
SHOW DATABASES;
SELECT VERSION();
```

RDS trong private subnet → chỉ có EC2 trong cùng VPC mới connect được → đây là **best practice** cho production.

> **Screenshot:** ![RDS connected](/screenshots/week-05/02-rds-connected.png)

#### Bài tập 4: Import Schema & Sample Data

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

> **Screenshot:** ![Schema imported](/screenshots/week-05/03-schema-imported.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| RDS status "Creating" mãi không lên "Available" | Bình thường, cần 5–10 phút để provision — chờ và refresh |
| Connect bị timeout dù security group đúng | Kiểm tra lại DB Subnet Group — phải dùng private subnet, không phải public |
| Quên mật khẩu master user sau khi tạo | Vào RDS → Modify instance → đổi master password |
| `mysql: command not found` trên EC2 | Cài `mysql-client` trước: `sudo apt install mysql-client -y` |

### Kế hoạch tuần 6

- Tạo Application Load Balancer (ALB).
- Cấu hình Target Group và Health Check.
- Launch thêm EC2 instance thứ 2 vào `public-subnet-1b`.
- Test load balancing giữa 2 EC2 instance.
- Cấu hình Auto Scaling Group.
