# 📅 Báo cáo Tuần 3 — EC2 + Linux + Security Group

> **Thời gian học:** (04/05/2026 – 10/05/2026)  

---

## 🎯 Mục tiêu tuần này

- [x] Hiểu EC2: instance types, AMI, key pair
- [x] Launch EC2 instance (Ubuntu t2.micro Free Tier)
- [x] Cấu hình Security Group (SSH, HTTP, HTTPS)
- [x] SSH vào EC2 từ máy local
- [x] Cài đặt Nginx và chạy web server

---

## 📚 Tài liệu đã học

| Tài liệu | Thời gian | Ghi chú |
| :--- | :--- | :--- |
| <https://www.youtube.com/watch?v=L_lSsEbh3LQ> | 6:08 | How to SSH into an AWS EC2 Instance using PowerShell |
| <https://www.youtube.com/watch?v=86Tuwtn3zp0> | 5:28 | How to SSH into an EC2 Instance using PowerShell |
| <https://www.youtube.com/watch?v=VRoG6U6xMa4> | 5:57 | Install Nginx Ubuntu EC2 AWS |

---

## 🔧 Bài tập thực hành

### ✅/🔄 Bước 1: Launch EC2 Instance

Cấu hình instance:

- AMI: Ubuntu Server 22.04 LTS (Free Tier)
- Instance type: `t3.micro` (2 vCPU, 1GB RAM)
- Key pair: Tạo mới `aws-learning-key.pem`
- Storage: 8GB gp2

> 📸 **Screenshot:** [01-ec2-launch-config](../../screenshots/week-03/01-ec2-launch-config.png)
---

### ✅/🔄 Bước 2: Cấu hình Security Group

Tạo Security Group `web-server-sg`:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

> ⚠️ **Lưu ý bảo mật:** SSH chỉ cho phép My IP, không mở 0.0.0.0/0
>
> 📸 **Screenshot:** [02-security-group](../../screenshots/week-03/02-security-group.png)
---

### ✅/🔄 Bước 3: SSH vào EC2

```bash
# Cấp quyền cho key file
chmod 400 aws-learning-key.pem

# SSH vào EC2
ssh -i "aws-learning-key.pem" ubuntu@3.26.104.170

# Kết quả mong đợi:
# Welcome to Ubuntu 24.04.4 LTS (GNU/Linux 6.17.0-1012-aws x86_64)
# ubuntu@ip-172-31-24-73:~$
```

> 📸 **Screenshot:** [03-ssh-connected](../../screenshots/week-03/03-ssh-connected.png)
---

### ✅/🔄 Bước 4: Cài Nginx Web Server

```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Cài Nginx
sudo apt install nginx -y

# Khởi động và enable
sudo systemctl start nginx
sudo systemctl enable nginx

# Kiểm tra status
sudo systemctl status nginx
```

Truy cập `http://3.26.104.170` → thấy trang "Welcome to Nginx"

> 📸 **Screenshot:** [04-nginx-running](../../screenshots/week-03/04-nginx-running.png)
>
> 📸 **Screenshot:** [05-nginx-browser](../../screenshots/week-03/05-nginx-browser.png)
---

## 💡 Kiến thức quan trọng đã học

### EC2 Instance Types (Naming Convention)

```bash
t3.micro
│ │  └─── Size: nano/micro/small/medium/large/xlarge
│ └────── Generation: số càng lớn càng mới
└──────── Family:
          t = General Purpose (Burstable)
          m = General Purpose (Fixed)
          c = Compute Optimized
          r = Memory Optimized
          g = GPU
```

### EBS vs Instance Store

| | EBS | Instance Store |
| :--- | :--- | :--- |
| Dữ liệu khi tắt máy | Vẫn giữ nguyên | Mất sạch |
| Tốc độ | Chậm hơn | Nhanh hơn |
| Dùng cho | Hệ điều hành, database | Cache, dữ liệu tạm |

### Security Group vs NACL

| | Security Group | NACL |
| :--- | :--- | :--- |
| Tầng bảo vệ | Instance (từng máy) | Subnet (cả nhóm máy) |
| Loại rule | Chỉ cho phép | Cho phép + Chặn |
| Stateful | ✅ Có | ❌ Không |

---

## ❌ Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Security Group có rule MSSQL port 1433 mở 0.0.0.0/0 | Xóa rule MSSQL, không cần thiết cho bài tập này |
| SSH port 22 để source 0.0.0.0/0 (mở toàn internet) | Đổi source type sang "My IP" để chỉ máy mình SSH được |
| HTTP/HTTPS để source "My IP" thay vì 0.0.0.0/0 | Đổi sang "Anywhere" — web public phải cho mọi người truy cập |
| Instance launch failed: "Microsoft SQL Server is not supported for t3.micro" | Chọn sai AMI (SQL Server thay vì Ubuntu 22.04 LTS) — quay lại chọn đúng AMI Ubuntu Free Tier |

---

## 📊 Kết quả đạt được

- [x] EC2 instance running, truy cập được qua SSH
- [x] Nginx chạy, access được qua browser
- [x] Hiểu Security Group inbound/outbound rules

---

## 🔜 Kế hoạch tuần 4

- [ ] Học VPC: subnets, route tables, internet gateway
- [ ] Tạo VPC với public/private subnet
- [ ] Cấu hình NAT Gateway
- [ ] Move EC2 vào VPC mới

---

*Cập nhật: 07/05/2026 | [Pham Đuc Thanh]*
