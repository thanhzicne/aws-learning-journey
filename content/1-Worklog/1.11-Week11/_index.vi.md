---
title: "Worklog Tuần 11"
date: 2026-05-14
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

## Mục tiêu tuần 11

- Review và tối ưu chi phí AWS qua Cost Explorer.
- Thực hiện Security Audit cho IAM, Security Groups và S3.
- Vẽ Architecture Diagram cho toàn bộ hệ thống.
- Viết README chuyên nghiệp và Deployment Guide cho project repo.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Review chi phí AWS với Cost Explorer: phân tích từng service, xác định điểm tốn kém, lập kế hoạch tối ưu | 29/06/2026 | 29/06/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 3 | Security Audit IAM: kiểm tra root user, MFA, access key rotation, Least Privilege Principle | 30/06/2026 | 30/06/2026 | [Security Compliance with AWS Security Hub](https://000018.awsstudygroup.com) |
| 4 | **Thực hành Security:** Audit Security Groups (SSH, RDS, ports). Audit S3 (public access, versioning, lifecycle) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| 5 | Vẽ Architecture Diagram bằng draw.io. Xác định đầy đủ các thành phần: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 6 | Viết README chuyên nghiệp và Deployment Guide cho project repo. Ôn tập, viết báo cáo worklog | 03/07/2026 | 03/07/2026 | |

### Kết quả đạt được tuần 11

Nắm vững các khái niệm nền tảng của AWS Optimization và Documentation:

- **AWS Cost Explorer:** Công cụ trực quan hóa chi phí AWS theo service, region, tag, và thời gian. Hỗ trợ nhận diện xu hướng chi tiêu và dự báo chi phí tháng tiếp theo.
- **Savings Plans / Reserved Instances:** Cam kết sử dụng tài nguyên theo giờ trong 1–3 năm để đổi lấy mức giảm giá lên đến 72% so với On-Demand.
- **Spot Instance:** Mua năng lực EC2 dư thừa của AWS với giá rẻ hơn đến 90%, nhưng có thể bị thu hồi bất kỳ lúc nào — phù hợp cho môi trường non-production.
- **Least Privilege Principle:** Nguyên tắc bảo mật IAM — mỗi user/role chỉ được cấp đúng quyền cần thiết, không hơn. Giảm thiểu bề mặt tấn công nếu credentials bị lộ.
- **MFA (Multi-Factor Authentication):** Bảo vệ tài khoản bằng 2 lớp xác thực: mật khẩu + thiết bị vật lý/ứng dụng OTP. Bắt buộc cho root account và các IAM user có quyền cao.
- **Security Group:** Tường lửa ảo cấp instance, kiểm soát inbound/outbound traffic theo IP và port. Hoạt động theo whitelist — chỉ cho phép những gì khai báo rõ ràng.
- **S3 Block Public Access:** Cơ chế bảo vệ cấp account/bucket, ngăn việc vô tình public hóa object qua ACL hoặc Bucket Policy.
- **Architecture Diagram:** Tài liệu trực quan thể hiện toàn bộ hệ thống: các service AWS, cách chúng kết nối với nhau, và luồng dữ liệu. Là tài liệu quan trọng khi bàn giao hoặc onboard thành viên mới.

```text
Tổng quan kiến trúc hệ thống sau 11 tuần:

  Internet
     ↓
  GitHub Actions (CI/CD)
     ↓ SSH deploy
  ┌──────────────── VPC (10.0.0.0/16) ──────────────────┐
  │                                                      │
  │  Public Subnet              Private Subnet           │
  │  ┌──────────────┐          ┌──────────────────┐      │
  │  │  EC2 (8080)  │─────────►│  RDS MySQL       │      │
  │  │  Spring Boot │          │  (3306, private) │      │
  │  └──────────────┘          └──────────────────┘      │
  └──────────────────────────────────────────────────────┘
       ↑ image pull               ↑ object storage
  Docker Hub                   S3 (product images)
                               S3 (frontend static)
                               CloudWatch (monitoring)
```

#### Bài tập 1: Cost Optimization Review với Cost Explorer

**Các chiến lược tối ưu chi phí AWS:**

| Service | Vấn đề | Giải pháp tối ưu |
| :--- | :--- | :--- |
| **EC2** | On-Demand tốn kém khi chạy 24/7 | Dùng Spot Instance cho môi trường dev/test |
| **RDS** | Chạy cả khi không dùng (cuối tuần, ban đêm) | Tắt thủ công hoặc dùng RDS Scheduler ngoài giờ làm việc |
| **NAT Gateway** | Tính phí theo giờ + theo GB data ($0.045/GB) | Xem xét thay bằng VPC Endpoint nếu traffic chỉ đến S3/DynamoDB |
| **S3** | Lưu trữ object cũ không cần thiết | Cấu hình Lifecycle Rule: chuyển sang S3-IA sau 30 ngày, xóa sau 90 ngày |

Xem chi phí từng service trong Cost Explorer:

```text
AWS Console → Cost Explorer → Reports → Daily Costs by Service
  ├── EC2:          $X.XX/ngày
  ├── RDS:          $X.XX/ngày
  ├── NAT Gateway:  $X.XX/ngày
  └── S3:           $X.XX/ngày
```

> **Screenshot:** ![Cost Explorer dashboard](/images/evidence/week-11/01-cost-explorer.png)

#### Bài tập 2: Security Audit — IAM

**IAM Security Checklist và lý do:**

| Hạng mục | Lý do quan trọng |
| :--- | :--- |
| Root user không dùng hàng ngày | Root có toàn quyền, không thể bị giới hạn bởi IAM Policy — nếu bị lộ thì mất toàn bộ tài khoản |
| MFA bật cho root và admin user | Ngay cả khi password bị lộ, kẻ tấn công vẫn cần thiết bị vật lý để đăng nhập |
| Access key rotate định kỳ (90 ngày) | Giới hạn thời gian kẻ tấn công có thể dùng key nếu bị lộ mà không phát hiện |
| Không hardcode credentials trong code | Code thường được push lên GitHub — credentials công khai = tài khoản bị chiếm trong vài phút |
| Áp dụng Least Privilege Principle | Dev user không cần quyền IAM hay Billing — cấp thừa = rủi ro không cần thiết |

```text
Kiểm tra nhanh qua AWS Console:
  IAM → Security recommendations
    ✅ / ❌ Root MFA
    ✅ / ❌ No root access keys
    ✅ / ❌ Users have MFA
    ✅ / ❌ Access key age < 90 days
```

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

#### Bài tập 3: Security Audit — Security Groups và S3

**Security Groups — nguyên tắc tối thiểu hóa bề mặt tấn công:**

- **SSH (port 22):** Chỉ mở cho IP cụ thể của máy dev, không mở `0.0.0.0/0` — nếu mở rộng rãi, bot sẽ brute-force liên tục.
- **RDS (port 3306):** Chỉ cho phép inbound từ Security Group của EC2, không gán Public IP cho RDS.
- **Application (port 8080):** Chỉ mở khi cần, hoặc đặt sau Load Balancer — expose cổng ứng dụng trực tiếp ra internet là anti-pattern.

**S3 Security Checklist:**

```text
S3 → Bucket → Permissions:
   Block all public access: ON
   Bucket Policy: không cho s3:GetObject từ "*" trừ bucket frontend
   Versioning: Enabled (cho production bucket)
   Lifecycle Rule: Transition to S3-IA sau 30 ngày
   Server-side Encryption: SSE-S3 (AES-256) hoặc SSE-KMS
```

> **Screenshot:** ![Security Group audit](/images/evidence/week-11/03-security-group-audit.png)
>
> **Screenshot:** ![S3 security settings](/images/evidence/week-11/04-s3-security.png)

#### Bài tập 4: Architecture Diagram

**Tại sao cần Architecture Diagram:**

Architecture Diagram không chỉ là tài liệu đẹp — đây là công cụ tư duy giúp phát hiện điểm yếu trong thiết kế (single point of failure, bottleneck, security gap) trước khi code. Khi onboard thành viên mới hoặc trình bày với stakeholder, diagram thay thế hàng chục trang văn bản.

**Công cụ vẽ:** [draw.io](https://draw.io) — miễn phí, có sẵn AWS icon library, export được PNG/SVG/PDF.

```text
┌──────────────────────────────────────────────────┐
│                   AWS Cloud                      │
│                                                  │
│  ┌─────────────────────────────────────────┐     │
│  │              VPC (10.0.0.0/16)          │     │
│  │                                         │     │
│  │  ┌─────────────┐   ┌─────────────────┐  │     │
│  │  │Public Subnet│   │ Private Subnet  │  │     │
│  │  │             │   │                 │  │     │
│  │  │  ┌───────┐  │   │  ┌──────────┐   │  │     │
│  │  │  │  EC2  │──┼───┼──►   RDS    │   │  │     │
│  │  │  │Spring │  │   │  │  MySQL   │   │  │     │
│  │  │  │ Boot  │  │   │  └──────────┘   │  │     │
│  │  │  └───────┘  │   │                 │  │     │
│  │  └─────────────┘   └─────────────────┘  │     │
│  └─────────────────────────────────────────┘     │
│                                                  │
│  ┌─────────┐  ┌───────────┐  ┌────────────────┐  │
│  │   S3    │  │CloudWatch │  │      IAM       │  │
│  │(Static) │  │ Monitoring│  │(Users/Policies)│  │
│  └─────────┘  └───────────┘  └────────────────┘  │
└──────────────────────────────────────────────────┘
          ↑ CI/CD: GitHub Actions
```

> **Screenshot:** ![Architecture diagram](/images/evidence/week-11/05-architecture-diagram.png)

#### Bài tập 5: Viết README chuyên nghiệp

**Cấu trúc README chuẩn cho project AWS:**

Một README tốt phải trả lời được 3 câu hỏi của người đọc lần đầu: *Đây là gì? Nó làm được gì? Tôi chạy nó như thế nào?* — trong vòng 30 giây đầu.

| Section | Nội dung |
| :--- | :--- |
| **Project Overview** | Mô tả ngắn gọn (2–3 câu), demo screenshot hoặc GIF |
| **Architecture Diagram** | Embed diagram đã vẽ |
| **Tech Stack** | Liệt kê ngắn: Java 17, Spring Boot, React, MySQL, Docker, AWS (EC2, RDS, S3) |
| **Prerequisites** | Java 17, Docker, AWS CLI, Node 18 |
| **Setup & Installation** | Từng bước clone → cấu hình env → build → chạy local |
| **Environment Variables** | Bảng liệt kê tên biến, mô tả, giá trị mẫu |
| **API Documentation** | Bảng endpoint: Method, Path, Description, Request/Response mẫu |
| **Deployment Guide** | Các bước deploy lên AWS: EC2, RDS, S3, Docker Hub, GitHub Actions |
| **Lessons Learned** | 3–5 điều rút ra sau 11 tuần — phần quan trọng nhất với reviewer |

> **Screenshot:** ![README preview](/images/evidence/week-11/06-readme-preview.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| NAT Gateway chiếm phần lớn chi phí | Chuyển traffic S3 sang VPC Gateway Endpoint (miễn phí), không đi qua NAT |
| Cost Explorer không hiển thị chi tiết theo tag | Bật Cost Allocation Tags trong Billing settings, đợi 24h để data hiện |
| RDS vẫn tính phí khi "stopped" sau 7 ngày | AWS tự động start lại RDS sau 7 ngày stopped — cần snapshot rồi xóa hẳn nếu không dùng lâu dài |
| README quá dài, người đọc không cuộn hết | Thêm Table of Contents với anchor link ở đầu file |

## Kế hoạch tuần 12

- Tổng kết toàn bộ 12 tuần: review lại kiến trúc, kiến thức tích lũy.
- Chuẩn bị nội dung presentation cho demo ngày cuối.
- Dọn dẹp tài nguyên AWS để tránh phát sinh chi phí sau khi kết thúc chương trình.
- Lên kế hoạch học tiếp: AWS Solutions Architect Associate certificate.
