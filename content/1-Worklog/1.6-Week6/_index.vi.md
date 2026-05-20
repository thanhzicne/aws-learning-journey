---
title: "Worklog Tuần 6"
date: 2026-05-14
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

## Mục tiêu tuần 6

- Tạo CloudWatch alarms (CPU, Network).
- Thiết lập SNS topic gửi email alert.
- Thành thạo AWS CLI (cài đặt + cấu hình).
- Thực hành CLI: list S3, describe EC2, query RDS.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu CloudWatch: Metrics, Logs, Logs Insights. Xem metrics EC2 và RDS | 25/05/2026 | 25/05/2026 | [CloudWatch Metrics – Lab 000008](https://000008.awsstudygroup.com/3-cloud-watch-metric/) |
| 3 | Tạo CloudWatch Alarm cho CPU > 80%. Thiết lập SNS Topic + Email Subscription | 26/05/2026 | 26/05/2026 | [CloudWatch Alarms – Lab 000008](https://000008.awsstudygroup.com/5-cloud-watch-alarm/) |
| 4 | **Thực hành Dashboard:** Tạo CloudWatch Dashboard tổng hợp metrics EC2, RDS, S3 | 27/05/2026 | 27/05/2026 | [CloudWatch Dashboard – Lab 000008](https://000008.awsstudygroup.com/6-cloud-watch-dashboard/) |
| 5 | Cài AWS CLI, cấu hình `aws configure`, tạo multiple profiles (dev, prod) | 28/05/2026 | 28/05/2026 | [Install AWS CLI – Lab 000011](https://000011.awsstudygroup.com/3-installcli/) |
| 6 | Thực hành CLI commands: S3, EC2, RDS, CloudWatch. Ôn tập, viết báo cáo worklog. Lên kế hoạch tuần 7 | 29/05/2026 | 29/05/2026 | [Getting Started with the AWS CLI](https://000011.awsstudygroup.com/) |

### Kết quả đạt được tuần 6

- CloudWatch Alarm `cpu-high-alarm` hoạt động, trigger khi CPU > 80%.
- SNS Topic `aws-learning-alerts` tạo thành công, nhận email thông báo.
- CloudWatch Dashboard tổng hợp metrics EC2, RDS hiển thị đầy đủ.
- AWS CLI cài đặt và cấu hình thành công với profile `default` và `dev`.
- Thực hành thành thạo các lệnh CLI cơ bản cho S3, EC2, RDS, CloudWatch.

#### Bài tập 1: CloudWatch Metrics & Logs

Vào CloudWatch Console → Metrics → All metrics để xem toàn bộ metrics theo namespace:

- `AWS/EC2`: CPUUtilization, NetworkIn, NetworkOut, StatusCheckFailed
- `AWS/RDS`: CPUUtilization, DatabaseConnections, FreeStorageSpace

Xem CloudWatch Logs từ VPC Flow Logs, EC2 & RDS đã bật ở tuần 4 và 5.

> **Screenshot:** ![CloudWatch metrics](/images/evidence/week-06/01-cloudwatch-metrics.png)

#### Bài tập 2: Tạo CloudWatch Alarm & SNS Topic

Tạo SNS Topic `aws-learning-alerts`:

```text
SNS Topic: aws-learning-alerts
  └── Subscription: Email → your@email.com
```

Confirm subscription email → nhận email xác nhận từ `no-reply@sns.amazonaws.com`.

Tạo CloudWatch Alarm cho CPU:

- Metric: `CPUUtilization` (namespace `AWS/EC2`)
- Instance: EC2 `web-server` trong `ecommerce-vpc`
- Threshold: > 80%
- Period: 5 phút liên tục
- Action: gửi notification đến SNS Topic `aws-learning-alerts`

**Lưu ý:** Alarm sẽ ở trạng thái `INSUFFICIENT_DATA` cho đến khi metric có đủ data points và SNS subscription được confirm.

> **Screenshot:** ![CloudWatch alarm](/images/evidence/week-06/01-cloudwatch-alarm.png)
>
> **Screenshot:** ![SNS email received](/images/evidence/week-06/02-sns-email-received.png)

#### Bài tập 3: Tạo CloudWatch Dashboard

Vào CloudWatch → Dashboards → Create dashboard `ecommerce-monitoring`:

Thêm các widget:

- Line chart: `CPUUtilization` của EC2
- Line chart: `DatabaseConnections` của RDS
- Number widget: `FreeStorageSpace` của RDS
- Alarm status widget: hiển thị trạng thái các alarm

> **Screenshot:** ![CloudWatch dashboard](/images/evidence/week-06/03-cloudwatch-dashboard.png)

#### Bài tập 4: Cài đặt & Cấu hình AWS CLI

```bash
# macOS
brew install awscli

# Ubuntu/Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Xác nhận cài đặt
aws --version

# Cấu hình profile default
aws configure
# AWS Access Key ID: [IAM User access key]
# AWS Secret Access Key: [IAM User secret key]
# Default region: ap-southeast-1
# Default output format: json
```

Tạo multiple profiles để quản lý nhiều môi trường:

```bash
# Tạo profile riêng cho từng môi trường
aws configure --profile dev
aws configure --profile prod

# Sử dụng profile cụ thể
aws s3 ls --profile dev
aws ec2 describe-instances --profile prod
```

> **Screenshot:** ![CLI configured](/images/evidence/week-06/03-cli-commands.png)

#### Bài tập 5: Thực hành CLI Commands

```bash

# EC2
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]" --output table

# RDS
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Endpoint.Address]' --output table

# CloudWatch:
aws cloudwatch describe-alarms --output table

# Profile dev:
aws ec2 describe-instances --profile dev --output table
```

> **Screenshot:** ![CLI commands output](/images/evidence/week-06/04-cli-output.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Alarm ở trạng thái `INSUFFICIENT_DATA` mãi | Cần confirm SNS subscription email trước, sau đó chờ metric có data point |
| SNS không gửi email | Kiểm tra spam folder — email từ `no-reply@sns.amazonaws.com` hay bị lọc |
| `aws: command not found` sau khi cài | Thêm AWS CLI vào PATH: `export PATH=$PATH:/usr/local/bin` |
| `An error occurred (AuthFailure)` khi chạy CLI | Access key chưa đúng hoặc chưa chạy `aws configure` — kiểm tra lại `~/.aws/credentials` |

### Kế hoạch tuần 7

- Tìm hiểu Application Load Balancer (ALB) và Target Group.
- Launch thêm EC2 instance thứ 2 vào `public-subnet-1b`.
- Cấu hình ALB để phân phối traffic giữa 2 EC2.
- Tạo Launch Template và Auto Scaling Group.
- Test scale-out khi CPU vượt ngưỡng.
