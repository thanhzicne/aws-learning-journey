---
title: "Worklog Tuần 3"
date: 2026-05-04
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

## Mục tiêu tuần 3

- Hiểu EC2: instance types, AMI, key pair.
- Launch EC2 instance (Ubuntu t3.micro Free Tier).
- Cấu hình Security Group (SSH, HTTP, HTTPS).
- SSH vào EC2 từ máy local.
- Cài đặt Nginx và chạy web server.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu EC2: instance types, AMI, key pair. Launch EC2 instance Ubuntu t3.micro Free Tier | 04/05/2026 | 04/05/2026 | [Launch Linux Instance – Lab 000004](https://000004.awsstudygroup.com/4-launchlinuxinstance/4.1-createlinuxinstance/) |
| 3 | Tạo và cấu hình Security Group `web-server-sg` (SSH, HTTP, HTTPS) | 05/05/2026 | 05/05/2026 | [Create Security Group for Linux – Lab 000004](https://000004.awsstudygroup.com/2-prerequiste/2.3-createsecuritygrouplinux/) |
| 4 | **Thực hành SSH:** Kết nối vào EC2 từ máy local bằng key pair `.pem` | 06/05/2026 | 06/05/2026 | [Connect to Linux Instance – Lab 000004](https://000004.awsstudygroup.com/4-launchlinuxinstance/4.2-connectlinuxinstance/) |
| 5 | Cài đặt Nginx, khởi động web server, kiểm tra truy cập qua browser | 07/05/2026 | 07/05/2026 | [Introduction to Amazon EC2](https://000004.awsstudygroup.com) |
| 6 | Ôn tập, tổng hợp kiến thức tuần 3. Viết báo cáo worklog. Lên kế hoạch tuần 4 | 08/05/2026 | 08/05/2026 | |

### Kết quả đạt được tuần 3

- EC2 instance running, truy cập được qua SSH.
- Nginx chạy, access được qua browser tại `http://3.26.104.170`.
- Hiểu Security Group inbound/outbound rules.
- Hiểu rõ sự khác biệt giữa Security Group và NACL.

#### Bài tập 1: Launch EC2 Instance

Cấu hình instance:

- AMI: Ubuntu Server 22.04 LTS (Free Tier)
- Instance type: `t3.micro` (2 vCPU, 1GB RAM)
- Key pair: Tạo mới `aws-learning-key.pem`
- Storage: 8GB gp2

Nắm vững naming convention của EC2 instance types:

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

> **Screenshot:** ![EC2 launch config](/images/evidence/week-03/01-ec2-launch-config.png)

#### Bài tập 2: Cấu hình Security Group

Tạo Security Group `web-server-sg` với các inbound rules sau:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

> **Lưu ý bảo mật:** SSH chỉ cho phép My IP, không mở 0.0.0.0/0.

Hiểu rõ sự khác biệt giữa Security Group và NACL:

| | Security Group | NACL |
| :--- | :--- | :--- |
| Tầng bảo vệ | Instance (từng máy) | Subnet (cả nhóm máy) |
| Loại rule | Chỉ cho phép | Cho phép + Chặn |
| Stateful | Có | Không |

> **Screenshot:** ![Security group](/images/evidence/week-03/02-security-group.png)

#### Bài tập 3: SSH vào EC2

```bash
# Cấp quyền cho key file
chmod 400 aws-learning-key.pem

# SSH vào EC2
ssh -i "aws-learning-key.pem" ubuntu@3.26.104.170

# Kết quả mong đợi:
# Welcome to Ubuntu 24.04.4 LTS (GNU/Linux 6.17.0-1012-aws x86_64)
# ubuntu@ip-172-31-24-73:~$
```

> **Screenshot:** ![SSH connected](/images/evidence/week-03/03-ssh-connected.png)

#### Bài tập 4: Cài Nginx Web Server

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

Truy cập `http://3.26.104.170` → thấy trang "Welcome to Nginx".

Hiểu rõ sự khác biệt giữa EBS và Instance Store:

| | EBS | Instance Store |
| :--- | :--- | :--- |
| Dữ liệu khi tắt máy | Vẫn giữ nguyên | Mất sạch |
| Tốc độ | Chậm hơn | Nhanh hơn |
| Dùng cho | Hệ điều hành, database | Cache, dữ liệu tạm |

> **Screenshot:** ![Nginx running](/images/evidence/week-03/04-nginx-running.png)
>
> **Screenshot:** ![Nginx browser](/images/evidence/week-03/05-nginx-browser.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Security Group có rule MSSQL port 1433 mở 0.0.0.0/0 | Xóa rule MSSQL, không cần thiết cho bài tập này |
| SSH port 22 để source 0.0.0.0/0 (mở toàn internet) | Đổi source type sang "My IP" để chỉ máy mình SSH được |
| HTTP/HTTPS để source "My IP" thay vì 0.0.0.0/0 | Đổi sang "Anywhere" — web public phải cho mọi người truy cập |
| Instance launch failed: "Microsoft SQL Server is not supported for t3.micro" | Chọn sai AMI (SQL Server thay vì Ubuntu 22.04 LTS) — quay lại chọn đúng AMI Ubuntu Free Tier |

### Kế hoạch tuần 4

- Học VPC: subnets, route tables, internet gateway.
- Tạo VPC với public/private subnet.
- Cấu hình NAT Gateway.
- Move EC2 vào VPC mới.
