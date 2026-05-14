# Báo cáo Tuần 4 — VPC + Networking

> **Thời gian học:** — (11/05/2026 – 17/05/2026)

---

## Mục tiêu tuần này

- [x] Hiểu VPC: subnets, CIDR, route tables, internet gateway
- [x] Tạo Custom VPC với public và private subnet
- [x] Cấu hình NAT Gateway cho private subnet
- [x] Di chuyển EC2 vào VPC mới, kiểm tra connectivity
- [x] Bật VPC Flow Logs để monitor traffic

---

## Tài liệu đã học

| Tài liệu | Ghi chú |
| :--- | :--- |
| <https://000003.awsstudygroup.com/> | Lab chính, theo từng bước |
| <https://000019.awsstudygroup.com/> | Đọc thêm, chưa thực hành |
| AWS Docs: VPC User Guide | CIDR, Subnet sizing |

---

## Bài tập thực hành

### Bước 1: Tạo VPC

Vào VPC Console → Your VPCs → Create VPC

| Tham số | Giá trị |
| :--- | :--- |
| Name | `ecommerce-vpc` |
| IPv4 CIDR | `10.0.0.0/16` |
| Tenancy | Default |
| IPv6 | Không bật |

⚠️ Lưu ý: Chọn VPC only (không dùng Wizard) để hiểu từng thành phần riêng lẻ.

```bash

 CIDR 10.0.0.0/16 cho phép tạo đến 65.536 địa chỉ IP
→ Đủ dùng để chia thành nhiều subnet nhỏ hơn

```

> **Screenshot:** [01-vpc-created](../../screenshots/week-04/01-vpc-created.png)

### Bước 2: Tạo Subnets

- Vào Subnets → Create subnet → chọn ecommerce-vpc
- Tạo lần lượt 4 subnet (2 public, 2 private — multi-AZ để chuẩn bị cho tuần 6 ELB):

| Tên | CIDR | Availability Zone | Loại |
| :--- | :--- | :--- | :--- |
| public-subnet-1a | 10.0.1.0/24 | ap-southeast-1a | Public |
| public-subnet-1b | 10.0.2.0/24 | ap-southeast-1b | Public |
| private-subnet-1a | 10.0.3.0/24 | ap-southeast-1a | Private |
| private-subnet-1b | 10.0.4.0/24 | ap-southeast-1b | Private |

Sau khi tạo xong, bật Auto-assign public IPv4 cho 2 public subnet:

- Chọn `public-subnet-1a` → Actions → Edit subnet settings → bật `Enable auto-assign public IPv4 address`
- Lặp lại cho `public-subnet-1b`

>**Screenshot:** [02-subnets-created](../../screenshots/week-04/02-subnets-created.png)

### Bước 3: Tạo Internet Gateway (IGW)

Vào Internet Gateways → Create internet gateway

| Tham số | Giá trị |
| :--- | :--- |
| Name | `ecommerce-igw` |

Sau khi tạo → Actions → Attach to VPC → chọn `ecommerce-vpc`

>**Screenshot:** [03-igw-attached](../../screenshots/week-04/03-igw-attached.png)

### Bước 4: Tạo Route Tables

Cần tạo 2 route table: một cho public subnet, một cho private subnet.
**Route Table cho Public Subnet**
Vào Route Tables → Create route table

| Tham số | Giá trị |
| :--- | :--- |
| Name | `public-rtb` |
| VPC | `ecommerce-vpc` |

Thêm route:

- Destination: `0.0.0.0/0`
- Target: `ecommerce-igw`

Gắn subnet: Subnet associations → Edit subnet associations → chọn `public-subnet-1a` và `public-subnet-1b`
**Route Table cho Private Subnet**

| Tham số | Giá trị |
| :--- | :--- |
| Name | `private-rtb` |
| VPC | `ecommerce-vpc` |

⚠️ Chưa thêm route 0.0.0.0/0 vào private-rtb. Sẽ gắn NAT Gateway ở bước 5.
Gắn subnet: chọn `private-subnet-1a` và `private-subnet-1b`
>**Screenshot:** [04-route-tables](../../screenshots/week-04/04-route-tables.png)

### Bước 5: Tạo NAT Gateway

- NAT Gateway cho phép EC2 trong private subnet ra internet để update packages, nhưng không cho phép internet vào trực tiếp.
- Vào NAT Gateways → Create NAT Gateway

| Tham số | Giá trị |
| :--- | :--- |
| Name | `ecommerce-nat` |
| Subnet | `public-subnet-1a`← bắt buộc phải là public subnet |
| Connectivity type | Public |
| Elastic IP | Click Allocate Elastic IP |

Sau khi NAT Gateway Available, cập nhật private-rtb

- Destination: `0.0.0.0/0`
- Target: `ecommerce-nat`

>**Screenshot:** [05-nat-gateway](../../screenshots/week-04/05-nat-gateway.png)

### Bước 6: Tạo Security Groups

Tạo 2 Security Group trong `ecommerce-vpc`:
SG cho Web Server (public subnet)

| Tham số | Giá trị |
| :--- | :--- |
| Name | `web-server-sg` |
| VPC | `ecommerce-vpc` |

Inbound rules:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

SG cho Database (private subnet):

| Tham số | Giá trị |
| :--- | :--- |
| Name | `db-server-sg` |
| VPC | `ecommerce-vpc` |

Inbound rules:

| Type | Protocol | Port | Source | Lý do |
| :--- | :--- | :--- | :--- | :--- |
| MySQL/Aurora | TCP | 3306 | `web-server-sg` | Chỉ EC2 mới vào được RDS |

>**Screenshot:** [06-security-groups](../../screenshots/week-04/06-security-groups.png)

### Bước 7: Tạo EC2 Instance

Launch EC2 instance mới (hoặc re-launch instance từ tuần 3) vào ecommerce-vpc:

- Network: ecommerce-vpc
- Subnet: public-subnet-1a
- Security Group: web-server-sg
- Auto-assign public IP: Enable

SSH vào EC2 và kiểm tra:

```bash
# SSH vào EC2 public
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Test ping ra internet từ EC2 public
ping -c 4 google.com
# Kết quả mong đợi: 4 packets transmitted, 4 received

# Kiểm tra IP
curl ifconfig.me
# Trả về Public IP của EC2
```

>**Screenshot:** [07-ec2-in-vpc](../../screenshots/week-04/07-ec2-in-vpc.png)
>
>**Screenshot:** [08-ping-success](../../screenshots/week-04/08-ping-success.png)
>
>**Screenshot:** [09-deploy-web-server](../../screenshots/week-04/09-deploy-web-server.png)

### Bước 8: Bật VPC Flow Logs

VPC Flow Logs ghi lại toàn bộ traffic vào/ra VPC — rất hữu ích để debug và audit bảo mật.
Vào Your VPCs → chọn `ecommerce-vpc` → tab Flow logs → Create flow log

| Tham số | Giá trị |
| :--- | :--- |
| Filter | All |
| Destination | CloudWatch Logs |
| Log group | `/aws/vpc/ecommerce-vpc` |
| IAM role | Tạo role mới cho phép VPC ghi vào CloudWatch |

>**Screenshot:** [10-flow-logs](../../screenshots/week-04/10-flow-logs.png)

---

## Kiến thức quan trọng đã học

### VPC Architecture tổng thể

```bash

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

---

## Khó khăn gặp phải

| Vấn đề | Nguyên nhân | Cách giải quyết |
| :--- | :--- | :--- |
| NAT Gateway status "Pending" mãi không lên "Available" | Bình thường, cần 1–2 phút để provision | Chờ và refresh lại console |
| EC2 mới không SSH được dù security group đúng | Quên bật Auto-assign public IPv4 cho public subnet | Vào subnet settings → Enable auto-assign public IPv4 |
| Private subnet vẫn không ra được internet sau khi tạo NAT | Quên cập nhật route `0.0.0.0/0` → NAT trong `private-rtb` | Thêm route đúng target là NAT Gateway |
| Tạo subnet bị lỗi CIDR overlap | Nhập nhầm CIDR trùng với subnet khác | Kiểm tra lại: public dùng 10.0.1.x và 10.0.2.x, private dùng 10.0.3.x và 10.0.4.x |

---

## Kết quả đạt được

- [x] VPC ecommerce-vpc (10.0.0.0/16) tạo thành công
- [x] 4 subnet: 2 public (1a, 1b), 2 private (1a, 1b) — multi-AZ
- [x] Internet Gateway attach và route table public hoạt động
- [x] NAT Gateway trong public subnet, route table private trỏ đúng
- [x] Security Group web-server-sg và db-server-sg cấu hình đúng
- [x] EC2 trong public subnet SSH được và ping internet thành công
- [x] VPC Flow Logs bật → log ghi vào CloudWatch

---

## Worklog giờ học

| Ngày | Ngày bắt đầu | Ngày hoàn thành | Hoạt động |
| :--- | :--- | :--- |
| Thứ 2 | 11/05/2026 | 11/05/2026 | Đọc lý thuyết VPC, CIDR, Subnet, Route Table |
| Thứ 3 | 12/05/2026 | 12/05/2026 | TThực hành tạo Custom VPC, Public/Private Subnet, Internet Gateway |
| Thứ 4 | 13/05/2026 | 13/05/2026 | Tạo NAT Gateway, cấu hình Route Table cho private subnet |
| Thứ 5 | 14/05/2026 | 14/05/2026 | Tạo Security Group, launch EC2 vào VPC mới, test SSH và internet connectivity |
| Thứ 6 | 15/05/2026 | 15/05/2026 | Bật VPC Flow Logs, kiểm tra log trên CloudWatch, hoàn thiện report |

---

## Kế hoạch tuần 5

- [ ] Tạo RDS MySQL instance (db.t3.micro Free Tier)
- [ ] Đặt RDS vào private-subnet-1a với Security Group db-server-sg
- [ ] Kết nối RDS từ EC2 qua MySQL client
- [ ] Import schema ecommerce và sample data (products table)
- [ ] Confirm: EC2 public → RDS private kết nối được, nhưng internet không vào được RDS trực tiếp

---
