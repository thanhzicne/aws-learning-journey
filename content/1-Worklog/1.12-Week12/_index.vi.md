---
title: "Worklog Tuần 12"
date: 2026-05-14
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

## Mục tiêu tuần 12

- Tìm hiểu CloudFront và Route 53 — hoàn thiện kiến trúc với CDN và custom domain.
- Kiểm thử toàn bộ hệ thống end-to-end lần cuối.
- Hoàn thiện tất cả documentation: README, Deployment Guide, Architecture Diagram.
- Quay demo video và nộp project cho mentor.
- Dọn dẹp tài nguyên AWS, hoàn thiện báo cáo thực tập.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu CloudFront và Route 53 — hoàn thiện kiến trúc với CDN và custom domain, bật HTTPS với ACM | 06/07/2026 | 06/07/2026 | [Content Delivery with Amazon CloudFront](https://000094.awsstudygroup.com), [Hybrid DNS Management with Amazon Route 53](https://000010.awsstudygroup.com), [Custom Domains and SSL for Serverless Applications](https://000082.awsstudygroup.com) |
| 3 | Final testing toàn bộ hệ thống: CRUD sản phẩm, upload ảnh S3, CI/CD pipeline, CloudWatch alerts | 07/07/2026 | 07/07/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| 4 | Hoàn thiện README, Deployment Guide, Architecture Diagram (cập nhật CloudFront & Route 53). Quay demo video (3–5 phút): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
| 5 | Dọn dẹp tài nguyên AWS không cần thiết. Kiểm tra lại chi phí lần cuối với Cost Explorer | 09/07/2026 | 09/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 6 | Nộp project: GitHub repo, live app link. Viết báo cáo worklog tuần 12 và hoàn thiện báo cáo thực tập | 10/07/2026 | 10/07/2026 | |

### Kết quả đạt được tuần 12

Tổng hợp toàn bộ kiến thức tích lũy qua 12 tuần học AWS:

- **Cloud Infrastructure:** Nắm vững mô hình global AWS (Region, AZ, Edge Location), thiết kế VPC với public/private subnet, cấu hình Security Group theo nguyên tắc Least Privilege, quản lý IAM user/group/role/policy và Billing.
- **Storage & Database:** Sử dụng S3 cho object storage và static hosting, RDS MySQL trong private subnet, hiểu các storage class của S3 và chiến lược Lifecycle Rule.
- **Compute & Networking:** Triển khai ứng dụng trên EC2, cấu hình VPC, hiểu luồng traffic giữa public và private subnet qua NAT Gateway, dùng AWS CLI để tương tác với các service.
- **Application Development:** Xây dựng REST API với Spring Boot, React SPA với Vite và Axios, kết nối Frontend → Backend → RDS → S3 thành một hệ thống hoàn chỉnh.
- **Containerization:** Viết Dockerfile (single-stage và multi-stage), cấu hình Docker Compose cho local dev, push image lên Docker Hub, chạy container trên EC2.
- **CI/CD:** Thiết lập GitHub Actions workflow tự động: build JAR → build Docker image → push Docker Hub → SSH deploy lên EC2. Hiểu sự khác biệt giữa GitHub Actions và AWS CodePipeline.
- **Monitoring & Security:** Cấu hình CloudWatch metrics và SNS alerts, thực hiện security audit cho IAM/Security Group/S3, tối ưu chi phí với Cost Explorer.
- **CDN & DNS:** Triển khai CloudFront với 400+ edge server toàn cầu, cấu hình Route 53 để trỏ custom domain, bật HTTPS miễn phí với ACM.
- **Documentation:** Viết README chuyên nghiệp, vẽ Architecture Diagram bằng draw.io, ghi Deployment Guide và Lessons Learned.

---

#### Bài tập 1: CloudFront & Route 53 — Hoàn thiện kiến trúc

##### Tại sao cần CloudFront & Route 53?

Sau 11 tuần, hệ thống vẫn còn 3 vấn đề chưa giải quyết:

| Vấn đề | Triệu chứng | Giải pháp |
| :--- | :--- | :--- |
| URL xấu, khó nhớ | `http://15.135.21.123:8080/api/products` | Route 53 + domain thật |
| Không có HTTPS | Browser cảnh báo "Not Secure" | CloudFront + ACM certificate |
| Load chậm cho user ở xa | User ở Việt Nam kết nối thẳng vào Sydney | CloudFront CDN cache tại edge gần nhất |

##### CloudFront là gì?

CloudFront là CDN (Content Delivery Network) của AWS — có 400+ edge server toàn cầu. Thay vì user kết nối thẳng vào S3/EC2 ở Sydney, CloudFront phục vụ từ edge gần nhất.

CloudFront có 2 loại origin trong project này:

| Origin | Path | Dùng cho |
| :--- | :--- | :--- |
| S3 bucket frontend | `/*` | Phục vụ React app (HTML/CSS/JS) |
| EC2 IP:8080 | `/api/*` | Proxy API calls, thêm HTTPS |

##### Route 53 là gì?

Route 53 là DNS service của AWS — chuyển đổi domain (`myapp.com`) thành địa chỉ CloudFront.

**Không có Route 53:** <https://d1234abc.cloudfront.net>   ← URL mặc định, xấu

**Có Route 53:** <https://myapp.com> → Route 53 → CloudFront → S3 / EC2

##### ACM (AWS Certificate Manager) là gì?

ACM cấp SSL certificate **miễn phí** để bật HTTPS. CloudFront yêu cầu certificate phải tạo ở **region us-east-1** (N. Virginia), không phải ap-southeast-2.

HTTP  → không mã hóa → dữ liệu có thể bị đọc giữa chừng
HTTPS → mã hóa TLS  → an toàn, browser không hiển thị cảnh báo.

##### Bước 1: Tạo SSL Certificate trên ACM

> Bắt buộc tạo ở region **us-east-1 (N. Virginia)** — đây là lỗi phổ biến nhất khi dùng CloudFront.

- Vào **ACM Console** (chuyển region sang us-east-1) → **Request certificate** → **Request a public certificate**
- Domain name: `myapp.com` và `*.myapp.com` (wildcard để dùng cho subdomain sau này)
- Validation method: **DNS validation**
- Nhấn **Request** → copy CNAME record được tạo ra → thêm vào Route 53
- Chờ status chuyển sang **Issued** (thường 1–5 phút)

##### Bước 2: Tạo CloudFront Distribution

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

##### Bước 3: Tạo Route 53 Hosted Zone

- **Route 53 Console** → **Hosted zones** → **Create hosted zone**
- Domain name: `myapp.com` → **Create**
- Copy 4 NS (Name Server) records → cập nhật vào nhà đăng ký domain (nếu mua ở nơi khác như Namecheap, GoDaddy...)

##### Bước 4: Tạo A Record trỏ về CloudFront

Trong hosted zone `myapp.com` → **Create record**:

| Tham số | Giá trị |
| :--- | :--- |
| Record name | (để trống — root domain) |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |
| Distribution | chọn distribution vừa tạo |

##### Bước 5: Cập nhật React frontend và deploy

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

##### Kết quả sau bài tập 1

| Trước | Sau |
| :--- | :--- |
| `http://15.135.21.123:8080/api` | `https://myapp.com/api` |
| `http://simple-ecommerce-fe.s3-website.amazonaws.com` | `https://myapp.com` |
| Load ~200ms từ Việt Nam | Load ~30ms nhờ edge server Singapore |
| HTTP không mã hóa | HTTPS với SSL certificate miễn phí |

> **Screenshot:** ![CloudFront distribution](/images/evidence/week-12/01-cloudfront-distribution.png)
>
> **Screenshot:** ![Route 53 records](/images/evidence/week-12/02-route53-records.png)

---

#### Tổng kết 12 tuần học

| Tuần | Chủ đề | Kết quả chính |
| :---: | :--- | :--- |
| 1 | IAM + Billing | Tạo AWS account, cấu hình IAM users/groups, thiết lập Budget alerts |
| 2 | S3 + Static Hosting | Tạo S3 bucket, upload object, deploy static website |
| 3 | EC2 + Linux | Launch EC2, SSH, cài đặt Java/MySQL, quản lý Security Group |
| 4 | VPC + Networking | Thiết kế VPC, public/private subnet, Internet Gateway, NAT Gateway |
| 5 | RDS + MySQL | Launch RDS trong private subnet, kết nối từ EC2, backup |
| 6 | CloudWatch + CLI | Cấu hình metrics, alarms, SNS, thành thạo AWS CLI |
| 7 | Spring Boot Backend | Xây dựng REST API hoàn chỉnh với CRUD và S3 upload |
| 8 | React Frontend | Vite project, Axios, React Router, deploy lên S3 |
| 9 | Docker | Dockerfile, multi-stage build, Docker Compose, Docker Hub |
| 10 | GitHub Actions CI/CD | Workflow tự động build → push → SSH deploy lên EC2 |
| 11 | Optimization + Docs | Cost Explorer, Security Audit, Architecture Diagram, README |
| 12 | CloudFront + Route 53 + Final Submission | CDN, HTTPS, custom domain, testing, nộp project |

**Kết quả đạt được sau 12 tuần học AWS:**

- Hiểu và thực hành được về các dịch vụ cloud của AWS.
- Từ những thứ đã học được trong 12 tuần qua đã hoàn thành 1 project cá nhân nhỏ để từ đó có thể làm 1 project nhóm dễ dàng hơn.
- Xây dựng được 1 project nhóm để hoàn thành thực tập.

---

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| ACM certificate không được cấp (pending) | Đảm bảo đã thêm đúng CNAME record vào Route 53 — thường mất 1–5 phút |
| CloudFront trả về 403 khi truy cập S3 | Cấu hình OAC và cập nhật Bucket Policy cho phép CloudFront đọc S3 |
| React Router bị 404 khi refresh trang | Thêm custom error page: HTTP 403/404 → redirect về `/index.html` với HTTP 200 |
| API bị CORS error sau khi đổi sang domain mới | Cập nhật `@CrossOrigin(origins = "https://myapp.com")` trong Spring Boot controller |
| CloudFront hiển thị nội dung cũ sau khi deploy | Chạy `aws cloudfront create-invalidation --paths "/*"` sau mỗi lần deploy React |
| App chạy local nhưng lỗi trên EC2 | Kiểm tra Security Group port 8080, kiểm tra environment variables DB_URL trên EC2 |
| Demo video quay lại nhiều lần vì quên kịch bản | Viết kịch bản chi tiết từng phần, chạy thử 1 lần trước khi quay thật |
| GitHub repo chứa file `.env` bị push nhầm | Thêm `.env` vào `.gitignore`, dùng `git rm --cached .env` để xóa khỏi history |
| Quên xóa tài nguyên AWS sau khi nộp bài | Dùng AWS Cost Explorer sau 1 tuần để verify không còn phát sinh chi phí |
