# 📅 Báo cáo Tuần 3 — EC2 + Linux + Security Group

> **Trạng thái:** 🔄 Đang học  
> **Thời gian học:** ~X giờ (11/05/2026 – 17/05/2026)  
> **Mentor review:** ⏳ Chưa nộp

---

## 🎯 Mục tiêu tuần này

- [ ] Hiểu EC2: instance types, AMI, key pair
- [ ] Launch EC2 instance (Ubuntu t2.micro Free Tier)
- [ ] Cấu hình Security Group (SSH, HTTP, HTTPS)
- [ ] SSH vào EC2 từ máy local
- [ ] Cài đặt Nginx và chạy web server

---

## 📚 Tài liệu đã học

| Tài nguyên | Thời gian | Ghi chú |
|---|---|---|
| AWS Documentation: EC2 User Guide | ... | |
| YouTube: Nana DevOps - EC2 Tutorial | 30 phút | |
| YouTube: AWS re:Invent - EC2 Best Practices | 45 phút | |

> ✏️ *Điền thêm khi học xong*

---

## 🔧 Bài tập thực hành

### ✅/🔄 Bước 1: Launch EC2 Instance

Cấu hình instance:
- AMI: Ubuntu Server 22.04 LTS (Free Tier)
- Instance type: `t2.micro` (1 vCPU, 1GB RAM)
- Key pair: Tạo mới `aws-learning-key.pem`
- Storage: 8GB gp2

> 📸 **Screenshot:** [`01-ec2-launch-config.png`](./screenshots/01-ec2-launch-config.png)

---

### ✅/🔄 Bước 2: Cấu hình Security Group

Tạo Security Group `web-server-sg`:

| Type | Protocol | Port | Source | Lý do |
|---|---|---|---|---|
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

> ⚠️ **Lưu ý bảo mật:** SSH chỉ cho phép My IP, không mở 0.0.0.0/0

> 📸 **Screenshot:** [`02-security-group.png`](./screenshots/02-security-group.png)

---

### ✅/🔄 Bước 3: SSH vào EC2

```bash
# Cấp quyền cho key file
chmod 400 aws-learning-key.pem

# SSH vào EC2
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Kết quả mong đợi:
# Welcome to Ubuntu 22.04.x LTS
# ubuntu@ip-xxx-xxx-xxx-xxx:~$
```

> 📸 **Screenshot:** [`03-ssh-connected.png`](./screenshots/03-ssh-connected.png)

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

Truy cập `http://<EC2-PUBLIC-IP>` → thấy trang "Welcome to Nginx"

> 📸 **Screenshot:** [`04-nginx-running.png`](./screenshots/04-nginx-running.png)  
> 📸 **Screenshot:** [`05-nginx-browser.png`](./screenshots/05-nginx-browser.png)

---

### 🔄 Bước 5: [Thêm bài tập nếu có]

> ✏️ *Cập nhật khi hoàn thành*

---

## 💡 Kiến thức quan trọng đã học

### EC2 Instance Types (Naming Convention)

```
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
|---|---|---|
| Persistence | Tồn tại khi stop | Mất khi stop |
| Speed | Chậm hơn | Nhanh hơn |
| Use case | OS, database | Cache, temp |

### Security Group vs NACL
| | Security Group | NACL |
|---|---|---|
| Level | Instance level | Subnet level |
| Rules | Allow only | Allow + Deny |
| Stateful | ✅ | ❌ |

---

## ❌ Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
|---|---|
| *(Điền khi gặp phải)* | |

---

## 📊 Kết quả đạt được

- [ ] EC2 instance running, truy cập được qua SSH
- [ ] Nginx chạy, access được qua browser
- [ ] Hiểu Security Group inbound/outbound rules

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| Thứ 2 (11/05) | ... | |
| Thứ 3 (12/05) | ... | |
| ... | ... | |
| **Tổng** | **... giờ** | |

---

## 🔜 Kế hoạch tuần 4

- [ ] Học VPC: subnets, route tables, internet gateway
- [ ] Tạo VPC với public/private subnet
- [ ] Cấu hình NAT Gateway
- [ ] Move EC2 vào VPC mới

---

*Cập nhật: [Ngày] | [Tên học viên]*
