# 📅 Báo cáo Tuần 6 — CloudWatch + Monitoring + AWS CLI

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (01/06/2026 – 07/06/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Tạo CloudWatch alarms (CPU, Network)
- [ ] Thiết lập SNS topic gửi email alert
- [ ] Thành thạo AWS CLI (cài đặt + cấu hình)
- [ ] Thực hành CLI: list S3, describe EC2, query RDS

---

## 🔧 Bài tập thực hành

### Bước 1: CloudWatch Alarm cho CPU

- Metric: `CPUUtilization`
- Instance: EC2 của mình
- Threshold: > 80%
- Period: 5 phút liên tục
- Action: SNS notification

> 📸 Screenshot: `01-cloudwatch-alarm.png`

### Bước 2: SNS Topic + Email Subscription

```
SNS Topic: aws-learning-alerts
  └── Subscription: email → your@email.com
```

Confirm subscription email → Test alarm → Nhận email thông báo.

> 📸 Screenshot: `02-sns-email-received.png`

### Bước 3: Cài AWS CLI

```bash
# macOS
brew install awscli

# Ubuntu/Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Cấu hình
aws configure
# AWS Access Key ID: [IAM User access key]
# AWS Secret Access Key: [IAM User secret key]
# Default region: ap-southeast-1
# Default output format: json
```

### Bước 4: Thực hành CLI commands

```bash
# S3
aws s3 ls                                    # List tất cả buckets
aws s3 ls s3://simple-ecommerce-fe-yourname  # List files trong bucket
aws s3 cp file.txt s3://bucket/              # Upload file

# EC2
aws ec2 describe-instances                   # List instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' --output table

# RDS
aws rds describe-db-instances               # List RDS instances

# CloudWatch
aws cloudwatch list-metrics                 # List metrics
```

> 📸 Screenshot: `03-cli-commands.png`

---

## 💡 Kiến thức quan trọng đã học

### CloudWatch Architecture

```
EC2/RDS/S3 → Metrics → CloudWatch
                           ↓
                        Alarms
                           ↓
                    SNS Topic → Email/SMS/Lambda
```

### AWS CLI Profile Management

```bash
# Tạo multiple profiles
aws configure --profile dev
aws configure --profile prod

# Sử dụng profile cụ thể
aws s3 ls --profile dev
```

> ✏️ *Điền thêm khi học xong*

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
