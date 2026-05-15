---
title: "Worklog Tuần 4"
date: 2026-05-11
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

## Mục tiêu tuần 4

- Hiểu VPC: subnets, CIDR, route tables, internet gateway.
- Tạo Custom VPC với public và private subnet.
- Cấu hình NAT Gateway cho private subnet.
- Di chuyển EC2 vào VPC mới, kiểm tra connectivity.
- Bật VPC Flow Logs để monitor traffic.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Đọc lý thuyết VPC, CIDR, Subnet, Route Table. Tạo Custom VPC `ecommerce-vpc` | 11/05/2026 | 11/05/2026 | [Create VPC – Lab 000003](https://000003.awsstudygroup.com/3-prerequisite/3.1-createvpc/) |
| 3 | Tạo 4 subnet (2 public, 2 private, multi-AZ). Tạo Internet Gateway và Route Table | 12/05/2026 | 12/05/2026 | [Create Subnet](https://000003.awsstudygroup.com/3-prerequisite/3.2-createsubnet/) · [Create IGW](https://000003.awsstudygroup.com/3-prerequisite/3.3-createigw/) · [Create Route Table](https://000003.awsstudygroup.com/3-prerequisite/3.4-createroutetable/) |
| 4 | **Thực hành NAT Gateway:** Tạo NAT Gateway trong public subnet, cập nhật route table private | 13/05/2026 | 13/05/2026 | [Create NAT Gateway – Lab 000003](https://000003.awsstudygroup.com/4-createec2server/4.3-natgateway/) |
| 5 | Tạo Security Group cho web server và database. Launch EC2 vào VPC mới, test SSH và ping internet | 14/05/2026 | 14/05/2026 | [Create Security Group](https://000003.awsstudygroup.com/3-prerequisite/3.5-createsecuritygroup/) · [Deploy EC2](https://000003.awsstudygroup.com/4-createec2server/4.1-createec2/) |
| 6 | Bật VPC Flow Logs → CloudWatch. Ôn tập, viết báo cáo worklog. Lên kế hoạch tuần 5 | 15/05/2026 | 15/05/2026 | [Enable VPC Flow Logs – Lab 000003](https://000003.awsstudygroup.com/3-prerequisite/3.6-enablevpcflowlogs/) |

### Kết quả đạt được tuần 4

- VPC `ecommerce-vpc` (10.0.0.0/16) tạo thành công.
- 4 subnet: 2 public (1a, 1b), 2 private (1a, 1b) — multi-AZ.
- Internet Gateway attach và route table public hoạt động.
- NAT Gateway trong public subnet, route table private trỏ đúng.
- Security Group `web-server-sg` và `db-server-sg` cấu hình đúng.
- EC2 trong public subnet SSH được và ping internet thành công.
- VPC Flow Logs bật → log ghi vào CloudWatch.

#### Bài tập 1: Tạo VPC

Vào VPC Console → Your VPCs → Create VPC:

| Tham số | Giá trị |
| :--- | :--- |
| Name | `ecommerce-vpc` |
| IPv4 CIDR | `10.0.0.0/16` |
| Tenancy | Default |
| IPv6 | Không bật |

> **Lưu ý:** Chọn VPC only (không dùng Wizard) để hiểu từng thành phần riêng lẻ.

```text
CIDR 10.0.0.0/16 cho phép tạo đến 65.536 địa chỉ IP
→ Đủ dùng để chia thành nhiều subnet nhỏ hơn
```

> **Screenshot:** ![VPC created](/images/evidence/week-04/01-vpc-created.png)

#### Bài tập 2: Tạo Subnets, Internet Gateway & Route Tables

Tạo lần lượt 4 subnet (2 public, 2 private — multi-AZ để chuẩn bị cho tuần 6 ELB):

| Tên | CIDR | Availability Zone | Loại |
| :--- | :--- | :--- | :--- |
| public-subnet-1a | 10.0.1.0/24 | ap-southeast-1a | Public |
| public-subnet-1b | 10.0.2.0/24 | ap-southeast-1b | Public |
| private-subnet-1a | 10.0.3.0/24 | ap-southeast-1a | Private |
| private-subnet-1b | 10.0.4.0/24 | ap-southeast-1b | Private |

Sau khi tạo xong, bật Auto-assign public IPv4 cho 2 public subnet: chọn subnet → Actions → Edit subnet settings → Enable auto-assign public IPv4 address.

Tạo Internet Gateway `ecommerce-igw` → Actions → Attach to VPC → chọn `ecommerce-vpc`.

Tạo 2 route table trong `ecommerce-vpc`:

- `public-rtb`: thêm route `0.0.0.0/0` → `ecommerce-igw`, gắn `public-subnet-1a` và `public-subnet-1b`.
- `private-rtb`: chưa thêm route `0.0.0.0/0` — sẽ gắn NAT Gateway ở bước tiếp theo. Gắn `private-subnet-1a` và `private-subnet-1b`.

> **Screenshot:** ![Subnets created](/images/evidence/week-04/02-subnets-created.png)
>
> **Screenshot:** ![IGW attached](/images/evidence/week-04/03-igw-attached.png)
>
> **Screenshot:** ![Route tables](/images/evidence/week-04/04-route-tables.png)

#### Bài tập 3: Tạo NAT Gateway

NAT Gateway cho phép EC2 trong private subnet ra internet để update packages, nhưng không cho phép internet vào trực tiếp.

Vào NAT Gateways → Create NAT Gateway:

| Tham số | Giá trị |
| :--- | :--- |
| Name | `ecommerce-nat` |
| Subnet | `public-subnet-1a` (bắt buộc phải là public subnet) |
| Connectivity type | Public |
| Elastic IP | Click Allocate Elastic IP |

Sau khi NAT Gateway chuyển sang trạng thái Available, cập nhật `private-rtb`: thêm route `0.0.0.0/0` → target `ecommerce-nat`.

> **Screenshot:** ![NAT Gateway](/images/evidence/week-04/05-nat-gateway.png)

#### Bài tập 4: Tạo Security Groups, Launch EC2 & Test Connectivity

Tạo 2 Security Group trong `ecommerce-vpc`.

Security Group cho Web Server (public subnet) — `web-server-sg`:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

Security Group cho Database (private subnet) — `db-server-sg`:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| MySQL/Aurora | TCP | 3306 | `web-server-sg` | Chỉ EC2 mới vào được RDS |

Launch EC2 instance vào `ecommerce-vpc`: Network `ecommerce-vpc`, Subnet `public-subnet-1a`, Security Group `web-server-sg`, Auto-assign public IP Enabled.

```bash
# SSH vào EC2 public
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Test ping ra internet từ EC2 public
ping -c 4 google.com
# Kết quả mong đợi: 4 packets transmitted, 4 received

# Kiểm tra Public IP
curl ifconfig.me
```

> **Screenshot:** ![Security groups](/images/evidence/week-04/06-security-groups.png)
>
> **Screenshot:** ![EC2 in VPC](/images/evidence/week-04/07-ec2-in-vpc.png)
>
> **Screenshot:** ![Ping success](/images/evidence/week-04/08-ping-success.png)
>
> **Screenshot:** ![Deploy web server](/images/evidence/week-04/09-deploy-web-server.png)

#### Bài tập 5: Bật VPC Flow Logs

VPC Flow Logs ghi lại toàn bộ traffic vào/ra VPC — hữu ích để debug và audit bảo mật.

Vào Your VPCs → chọn `ecommerce-vpc` → tab Flow logs → Create flow log:

| Tham số | Giá trị |
| :--- | :--- |
| Filter | All |
| Destination | CloudWatch Logs |
| Log group | `/aws/vpc/ecommerce-vpc` |
| IAM role | Tạo role mới cho phép VPC ghi vào CloudWatch |

VPC Architecture tổng thể sau khi hoàn thành:

```text
VPC: ecommerce-vpc (10.0.0.0/16)
│
├── public-subnet-1a (10.0.1.0/24) — AZ: ap-southeast-1a
│   ├── Route: 0.0.0.0/0 → ecommerce-igw
│   ├── EC2 Web Server (có Public IP)
│   └── NAT Gateway (ecommerce-nat)
│
├── public-subnet-1b (10.0.2.0/24) — AZ: ap-southeast-1b
│   ├── Route: 0.0.0.0/0 → ecommerce-igw
│   └── [Dự phòng cho tuần 6: ALB / EC2 thứ 2]
│
├── private-subnet-1a (10.0.3.0/24) — AZ: ap-southeast-1a
│   ├── Route: 0.0.0.0/0 → ecommerce-nat
│   └── RDS MySQL [tuần 5]
│
└── private-subnet-1b (10.0.4.0/24) — AZ: ap-southeast-1b
    ├── Route: 0.0.0.0/0 → ecommerce-nat
    └── [Dự phòng cho RDS Multi-AZ]
```

> **Screenshot:** ![VPC Flow Logs](/images/evidence/week-04/10-flow-logs.png)

#### Khó khăn gặp phải

| Vấn đề | Nguyên nhân | Cách giải quyết |
| :--- | :--- | :--- |
| NAT Gateway status "Pending" mãi không lên "Available" | Bình thường, cần 1–2 phút để provision | Chờ và refresh lại console |
| EC2 mới không SSH được dù security group đúng | Quên bật Auto-assign public IPv4 cho public subnet | Vào subnet settings → Enable auto-assign public IPv4 |
| Private subnet vẫn không ra được internet sau khi tạo NAT | Quên cập nhật route `0.0.0.0/0` → NAT trong `private-rtb` | Thêm route đúng target là NAT Gateway |
| Tạo subnet bị lỗi CIDR overlap | Nhập nhầm CIDR trùng với subnet khác | Kiểm tra lại: public dùng 10.0.1.x và 10.0.2.x, private dùng 10.0.3.x và 10.0.4.x |

### Kế hoạch tuần 5

- Tạo RDS MySQL instance (db.t3.micro Free Tier).
- Đặt RDS vào `private-subnet-1a` với Security Group `db-server-sg`.
- Kết nối RDS từ EC2 qua MySQL client.
- Import schema ecommerce và sample data (products table).
- Confirm: EC2 public → RDS private kết nối được, nhưng internet không vào được RDS trực tiếp.
