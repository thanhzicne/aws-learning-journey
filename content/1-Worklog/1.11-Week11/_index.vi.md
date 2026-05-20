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
- Hoàn thiện kiến trúc với CloudFront CDN và Route 53 DNS.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Review chi phí AWS với Cost Explorer: phân tích từng service, xác định điểm tốn kém, lập kế hoạch tối ưu | 29/06/2026 | 29/06/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 3 | Security Audit IAM: kiểm tra root user, MFA, access key rotation, Least Privilege Principle | 30/06/2026 | 30/06/2026 | [Security Compliance with AWS Security Hub](https://000018.awsstudygroup.com) |
| 4 | Thực hành Security: Audit Security Groups (SSH, RDS, ports). Audit S3 (public access, versioning, lifecycle) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| 5 | Vẽ Architecture Diagram bằng draw.io. Xác định đầy đủ các thành phần: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 6 | Tìm hiểu CloudFront và Route 53 — hoàn thiện kiến trúc với CDN và custom domain. Viết README chuyên nghiệp và Deployment Guide cho project repo. Ôn tập, viết báo cáo worklog | 03/07/2026 | 03/07/2026 | [Content Delivery with Amazon CloudFront](https://000094.awsstudygroup.com), [Hybrid DNS Management with Amazon Route 53](https://000010.awsstudygroup.com), [Custom Domains and SSL for Serverless Applications](https://000082.awsstudygroup.com) |

### Kết quả đạt được tuần 11

Nắm vững các khái niệm nền tảng của AWS Optimization, Documentation và kiến trúc hoàn chỉnh:

- **AWS Cost Explorer:** Công cụ trực quan hóa chi phí AWS theo service, region, tag, và thời gian. Hỗ trợ nhận diện xu hướng chi tiêu và dự báo chi phí tháng tiếp theo.
- **Savings Plans / Reserved Instances:** Cam kết sử dụng tài nguyên theo giờ trong 1–3 năm để đổi lấy mức giảm giá lên đến 72% so với On-Demand.
- **Spot Instance:** Mua năng lực EC2 dư thừa của AWS với giá rẻ hơn đến 90%, nhưng có thể bị thu hồi bất kỳ lúc nào — phù hợp cho môi trường non-production.
- **Least Privilege Principle:** Nguyên tắc bảo mật IAM — mỗi user/role chỉ được cấp đúng quyền cần thiết, không hơn. Giảm thiểu bề mặt tấn công nếu credentials bị lộ.
- **MFA (Multi-Factor Authentication):** Bảo vệ tài khoản bằng 2 lớp xác thực: mật khẩu + thiết bị vật lý/ứng dụng OTP. Bắt buộc cho root account và các IAM user có quyền cao.
- **Security Group:** Tường lửa ảo cấp instance, kiểm soát inbound/outbound traffic theo IP và port. Hoạt động theo whitelist — chỉ cho phép những gì khai báo rõ ràng.
- **S3 Block Public Access:** Cơ chế bảo vệ cấp account/bucket, ngăn việc vô tình public hóa object qua ACL hoặc Bucket Policy.
- **Architecture Diagram:** Tài liệu trực quan thể hiện toàn bộ hệ thống: các service AWS, cách chúng kết nối với nhau, và luồng dữ liệu. Là tài liệu quan trọng khi bàn giao hoặc onboard thành viên mới.
- **CloudFront:** CDN toàn cầu của AWS với 400+ edge server — giảm latency, thêm HTTPS, cache nội dung gần user.
- **Route 53:** DNS service của AWS — trỏ domain thật về CloudFront thay vì dùng IP hoặc URL mặc định.
- **ACM (AWS Certificate Manager):** Cấp SSL certificate miễn phí để bật HTTPS cho CloudFront.

```text
Kiến trúc hoàn chỉnh sau tuần 11:

  User
   ↓
  myapp.com
   ↓
  Route 53 (DNS)
   ↓
  CloudFront (HTTPS + CDN)
  ├── /api/*  ──────────────────────────────► EC2:8080 (Spring Boot)
  │                                               ↓
  │                                          RDS MySQL (private subnet)
  └── /*  ──────────────────────────────────► S3 (React frontend)
                                                  ↑
                                          S3 (product images)

  GitHub Actions ──SSH──► EC2 (CI/CD deploy)
  CloudWatch ──────────── Monitoring toàn hệ thống
```

---

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

---

#### Bài tập 2: Security Audit — IAM

**IAM Security Checklist và lý do:**

| Hạng mục | Lý do quan trọng |
| :--- | :--- |
| Root user không dùng hàng ngày | Root có toàn quyền, không thể bị giới hạn bởi IAM Policy — nếu bị lộ thì mất toàn bộ tài khoản |
| MFA bật cho root và admin user | Ngay cả khi password bị lộ, kẻ tấn công vẫn cần thiết bị vật lý để đăng nhập |
| Access key rotate định kỳ (90 ngày) | Giới hạn thời gian kẻ tấn công có thể dùng key nếu bị lộ mà không phát hiện |
| Không hardcode credentials trong code | Code thường được push lên GitHub — credentials công khai = tài khoản bị chiếm trong vài phút |
| Áp dụng Least Privilege Principle | Dev user không cần quyền IAM hay Billing — cấp thừa = rủi ro không cần thiết |

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

---

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

---

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

---

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

---

#### Bài tập 6: CloudFront & Route 53 — Hoàn thiện kiến trúc

##### Tại sao cần CloudFront & Route 53?

Sau 11 tuần, hệ thống vẫn còn 3 vấn đề chưa giải quyết:

| Vấn đề | Triệu chứng | Giải pháp |
| :--- | :--- | :--- |
| URL xấu, khó nhớ | `http://15.135.21.123:8080/api/products` | Route 53 + domain thật |
| Không có HTTPS | Browser cảnh báo "Not Secure" | CloudFront + ACM certificate |
| Load chậm cho user ở xa | User ở Việt Nam kết nối thẳng vào Sydney | CloudFront CDN cache tại edge gần nhất |

##### CloudFront là gì?

CloudFront là CDN (Content Delivery Network) của AWS — có 400+ edge server toàn cầu. Thay vì user kết nối thẳng vào S3/EC2 ở Sydney, CloudFront phục vụ từ edge gần nhất.

```text
Không có CloudFront:
  User (HCM) ──────────────────────────► S3/EC2 (Sydney)   ~200ms

Có CloudFront:
  User (HCM) ──► Edge (Singapore) ──► S3/EC2 (Sydney)      ~30ms
                 └─ cache hit → trả về ngay, không cần vào Sydney
```

CloudFront có 2 loại origin trong project này:

| Origin | Path | Dùng cho |
| :--- | :--- | :--- |
| S3 bucket frontend | `/*` | Phục vụ React app (HTML/CSS/JS) |
| EC2 IP:8080 | `/api/*` | Proxy API calls, thêm HTTPS |

##### Route 53 là gì?

Route 53 là DNS service của AWS — chuyển đổi domain (`myapp.com`) thành địa chỉ CloudFront.

```text
Không có Route 53:
  https://d1234abc.cloudfront.net   ← URL mặc định, xấu

Có Route 53:
  https://myapp.com → Route 53 → CloudFront → S3 / EC2
```

##### ACM (AWS Certificate Manager) là gì?

ACM cấp SSL certificate **miễn phí** để bật HTTPS. CloudFront yêu cầu certificate phải tạo ở **region us-east-1** (N. Virginia), không phải ap-southeast-2.

```text
HTTP  → không mã hóa → dữ liệu có thể bị đọc giữa chừng
HTTPS → mã hóa TLS  → an toàn, browser không hiển thị cảnh báo
```

##### Kiến trúc hoàn chỉnh sau bài tập 6

```text
  User
   ↓
  myapp.com
   ↓
  Route 53 (DNS — trỏ domain về CloudFront)
   ↓
  CloudFront Distribution (HTTPS + cache)
  ├── /api/*  ──────────────────────────────► EC2:8080 (Spring Boot)
  │                                               ↓
  │                                         RDS MySQL (private subnet)
  └── /*  ──────────────────────────────────► S3 (React frontend)
                                                  ↑
                                          S3 (product images)

  GitHub Actions ──SSH──► EC2 (CI/CD deploy)
  CloudWatch ──────────── Monitoring toàn hệ thống
```

##### Hướng dẫn thực hiện

###### Bước 1: Tạo SSL Certificate trên ACM

> Bắt buộc tạo ở region **us-east-1 (N. Virginia)** — đây là lỗi phổ biến nhất khi dùng CloudFront.

- Vào **ACM Console** (chuyển region sang us-east-1) → **Request certificate** → **Request a public certificate**
- Domain name: `myapp.com` và `*.myapp.com` (wildcard để dùng cho subdomain sau này)
- Validation method: **DNS validation**
- Nhấn **Request** → copy CNAME record được tạo ra → thêm vào Route 53
- Chờ status chuyển sang **Issued** (thường 1–5 phút)

###### Bước 2: Tạo CloudFront Distribution

Vào **CloudFront Console** → **Create distribution**:

*Origin 1 — S3 frontend:*

| Tham số | Giá trị |
| :--- | :--- |
| Origin domain | `simple-ecommerce-fe-yourname.s3.ap-southeast-2.amazonaws.com` |
| Origin access | Origin Access Control (OAC) — bảo mật hơn public URL |
| Viewer protocol policy | Redirect HTTP to HTTPS |
| Default root object | `index.html` |

*Origin 2 — EC2 backend:*

| Tham số | Giá trị |
| :--- | :--- |
| Origin domain | `http://<EC2-IP>:8080` |
| Protocol | HTTP only |

*Behavior cho API (`/api/*`):*

| Tham số | Giá trị |
| :--- | :--- |
| Path pattern | `/api/*` |
| Origin | EC2 |
| Cache policy | **CachingDisabled** — API không được cache, phải luôn gọi thẳng vào EC2 |
| Allowed HTTP methods | GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE |

*Behavior mặc định (`/*`):*

| Tham số | Giá trị |
| :--- | :--- |
| Path pattern | `/*` (default) |
| Origin | S3 |
| Cache policy | **CachingOptimized** — cache HTML/CSS/JS tại edge |

*Cấu hình chung:*

- Alternate domain name: `myapp.com`
- SSL Certificate: chọn certificate vừa tạo ở ACM (us-east-1)
- Custom error response: HTTP 403 → `/index.html` → HTTP 200 *(để React Router hoạt động khi refresh trang)*

###### Bước 3: Tạo Route 53 Hosted Zone

- **Route 53 Console** → **Hosted zones** → **Create hosted zone**
- Domain name: `myapp.com` → **Create**
- Copy 4 NS (Name Server) records → cập nhật vào nhà đăng ký domain (nếu mua ở nơi khác như Namecheap, GoDaddy...)

###### Bước 4: Tạo A Record trỏ về CloudFront

Trong hosted zone `myapp.com` → **Create record**:

| Tham số | Giá trị |
| :--- | :--- |
| Record name | (để trống — root domain) |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |
| Distribution | chọn distribution vừa tạo |

###### Bước 5: Cập nhật React frontend và deploy

Sau khi có domain, cập nhật `API_URL` trong React:

```javascript
// services/productService.js — trước
const API_URL = 'http://15.135.21.123:8080/api';

// Sau khi có CloudFront + Route 53
const API_URL = 'https://myapp.com/api';
```

Build lại và deploy lên S3:

```bash
# Build React app
npm run build

# Sync lên S3
aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete

# Xóa cache CloudFront để user thấy version mới ngay
aws cloudfront create-invalidation \
  --distribution-id <DISTRIBUTION-ID> \
  --paths "/*"
```

##### Kết quả sau bài tập 6

| Trước | Sau |
| :--- | :--- |
| `http://15.135.21.123:8080/api` | `https://myapp.com/api` |
| `http://simple-ecommerce-fe.s3-website.amazonaws.com` | `https://myapp.com` |
| Load ~200ms từ Việt Nam | Load ~30ms nhờ edge server Singapore |
| HTTP không mã hóa | HTTPS với SSL certificate miễn phí |

> **Screenshot:** ![CloudFront distribution](/images/evidence/week-11/07-cloudfront-distribution.png)
>
> **Screenshot:** ![Route 53 records](/images/evidence/week-11/08-route53-records.png)

---

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| NAT Gateway chiếm phần lớn chi phí | Chuyển traffic S3 sang VPC Gateway Endpoint (miễn phí), không đi qua NAT |
| Cost Explorer không hiển thị chi tiết theo tag | Bật Cost Allocation Tags trong Billing settings, đợi 24h để data hiện |
| RDS vẫn tính phí khi "stopped" sau 7 ngày | AWS tự động start lại RDS sau 7 ngày stopped — cần snapshot rồi xóa hẳn nếu không dùng lâu dài |
| README quá dài, người đọc không cuộn hết | Thêm Table of Contents với anchor link ở đầu file |
| ACM certificate không được cấp (pending) | Đảm bảo đã thêm đúng CNAME record vào Route 53 — thường mất 1–5 phút |
| CloudFront trả về 403 khi truy cập S3 | Cấu hình OAC và cập nhật Bucket Policy cho phép CloudFront đọc S3 |
| React Router bị 404 khi refresh trang | Thêm custom error page: HTTP 403/404 → redirect về `/index.html` với HTTP 200 |
| API bị CORS error sau khi đổi sang domain mới | Cập nhật `@CrossOrigin(origins = "https://myapp.com")` trong Spring Boot controller |
| CloudFront hiển thị nội dung cũ sau khi deploy | Chạy `aws cloudfront create-invalidation --paths "/*"` sau mỗi lần deploy React |

---

## Kế hoạch tuần 12

- Tổng kết toàn bộ 12 tuần: review lại kiến trúc, kiến thức tích lũy.
- Chuẩn bị nội dung presentation cho demo ngày cuối.
- Dọn dẹp tài nguyên AWS để tránh phát sinh chi phí sau khi kết thúc chương trình.
- Lên kế hoạch học tiếp: AWS Solutions Architect Associate certificate.
