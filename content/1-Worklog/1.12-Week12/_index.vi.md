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
| 4 | Hoàn thiện Deployment Guide, Architecture Diagram (cập nhật CloudFront & Route 53). Quay demo video (3–5 phút): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
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

#### Bài tập: CloudFront & Route 53

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
**Không có Route 53:** `https://d1234abc.cloudfront.net` ← URL mặc định, xấu
**Có Route 53:** `https://myapp.com` → Route 53 → CloudFront → S3 / EC2
> **Lưu ý:** Trong bài thực hành này, Route 53 chỉ được tìm hiểu ở mức lý thuyết vì không sở hữu domain thật. Các bước thực hành bên dưới sẽ dùng CloudFront URL mặc định thay thế.

##### ACM (AWS Certificate Manager) là gì?

ACM cấp SSL certificate **miễn phí** để bật HTTPS. CloudFront yêu cầu certificate phải tạo ở **region us-east-1** (N. Virginia), không phải ap-southeast-2.
HTTP  → không mã hóa → dữ liệu có thể bị đọc giữa chừng
HTTPS → mã hóa TLS  → an toàn, browser không hiển thị cảnh báo
> **Lưu ý:** ACM chỉ validate được certificate khi sở hữu domain thật. Trong bài này bỏ qua bước ACM, sử dụng HTTPS mặc định do CloudFront cung cấp qua URL `*.cloudfront.net`.

---

##### Bước 1: Tạo CloudFront Distribution

Vào **CloudFront Console** → **Create distribution**

*Origin 1 — S3 frontend:*

| Tham số | Giá trị |
| :--- | :--- |
| Origin domain | `simple-ecommerce-phamducthanh.s3.ap-southeast-2.amazonaws.com` |
| Origin access | **Origin Access Control (OAC)** |
| Viewer protocol policy | Redirect HTTP to HTTPS |
| Default root object | `index.html` |

*Origin 2 — EC2 backend (thêm sau khi tạo xong distribution):*

| Tham số | Giá trị |
| :--- | :--- |
| Origin domain | `ec2-52-65-5-156.ap-southeast-2.compute.amazonaws.com` |
| Protocol | **HTTP only** |
| HTTP port | `8080` |

> **Lưu ý:** CloudFront không chấp nhận IP trực tiếp (`52.65.5.156`) vào ô Origin domain — phải dùng EC2 Public DNS thay thế.

*Cache behavior cho `/api/*` (thêm sau khi tạo xong distribution):*

| Tham số | Giá trị |
| :--- | :--- |
| Path pattern | `/api/*` |
| Origin | EC2 origin |
| Viewer protocol policy | HTTPS only |
| Allowed HTTP methods | GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE |
| Cache policy | **CachingDisabled** |
| Origin request policy | **AllViewer** |

*Custom error response (để React Router hoạt động khi refresh):*

| HTTP error code | Response page | HTTP Response code |
| :--- | :--- | :--- |
| 403 | `/index.html` | 200 |
| 404 | `/index.html` | 200 |

> **Screenshot:** ![Create a CloudFront Distribution](/images/evidence/week-12/01-Create-CloudFront-Distribution.png)

##### Bước 2: Cập nhật S3 Bucket Policy

Sau khi tạo distribution, cập nhật Bucket Policy để **chỉ CloudFront** được phép đọc S3 — không cho public truy cập trực tiếp:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::simple-ecommerce-phamducthanh/*",
      "Condition": {
        "ArnLike": {
          "AWS:SourceArn": "arn:aws:cloudfront::551326095934:distribution/E4UZ9OCEJUVRN"
        }
      }
    }
  ]
}
```

> **Screenshot:** ![Update S3 Bucket Policy](/images/evidence/week-12/02-S3-Bucket-Policy.png)

##### Bước 3: Cập nhật Frontend dùng CloudFront URL

Frontend cần gọi API qua CloudFront thay vì trực tiếp vào EC2. Sửa file `frontend/.env`:

```env
VITE_API_URL=https://d4k3yvu64phif.cloudfront.net/api
```

Với GitHub Actions, sửa `deploy.yml` — bỏ port `:8080` và đổi sang HTTPS:

```yaml
# Trước
--build-arg VITE_API_URL=http://${{ secrets.EC2_HOST }}:8080/api

# Sau
--build-arg VITE_API_URL=https://${{ secrets.EC2_HOST }}/api
```

Cập nhật secret `EC2_HOST` trong GitHub → Settings → Secrets thành CloudFront domain:

EC2_HOST = d4k3yvu64phif.cloudfront.net

> **Lưu ý:** RDS vẫn hoạt động bình thường — CloudFront chỉ đứng trước EC2, không ảnh hưởng kết nối EC2 ↔ RDS bên trong.

##### Bước 4: Tìm hiểu Route 53 (Lý thuyết)

> Bước này **không thực hành** vì không sở hữu domain thật. Ghi lại để hiểu luồng hoạt động khi có domain thực tế.

Nếu có domain thật, các bước sẽ thực hiện như sau:
**4.1 Tạo Hosted Zone**

Route 53 → Hosted zones → Create hosted zone
→ Domain name: myapp.com
→ Type: Public hosted zone
→ Create
**4.2 Tạo A Record trỏ về CloudFront**

| Tham số | Giá trị |
| :--- | :--- |
| Record name | *(để trống — root domain)* |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |

**4.3 Luồng hoạt động khi có Route 53:**

```bash
User gõ myapp.com
    ↓
Route 53 (DNS lookup)
    ↓
CloudFront (Edge server Singapore)
    ↓ /*                    ↓ /api/*
S3 Sydney             EC2 :8080 Sydney
                            ↓
                      RDS MySQL Sydney
```

**4.4 Các loại Routing Policy của Route 53:**

| Policy | Dùng khi |
| :--- | :--- |
| Simple | 1 resource duy nhất |
| Weighted | A/B testing, phân chia traffic theo % |
| Latency | Nhiều region, tự động chọn region gần nhất |
| Failover | Primary + Backup (High Availability) |
| Geolocation | Phân phối theo quốc gia/khu vực |

##### Bước 5: Test CloudFront URL

Sau khi distribution status chuyển sang **Enabled**, test thử:

```bash
# Test frontend
curl -I https://d1cbcva8jyj4q8.cloudfront.net

# Kết quả mong đợi
HTTP/2 200
x-cache: Hit from cloudfront   ← cache hoạt động

# Test API qua CloudFront
curl https://d1cbcva8jyj4q8.cloudfront.net/api/products

# Kết quả mong đợi: JSON danh sách sản phẩm từ RDS
```

Hoặc mở browser: `https://d4k3yvu64phif.cloudfront.net`

> **Screenshot:** ![Test CloudFront URL](/images/evidence/week-12/03-Test-CloudFront.png)

---

##### Kết quả sau bài tập

| Trước | Sau |
| :--- | :--- |
| `http://52.65.5.156:3000` (frontend) | `https://d4k3yvu64phif.cloudfront.net` |
| `http://52.65.5.156:8080/api` (backend) | `https://d4k3yvu64phif.cloudfront.net/api` |
| HTTP không mã hóa | **HTTPS** với CloudFront mặc định |
| Load ~200ms từ Việt Nam | Load ~30ms nhờ edge server Singapore |
| EC2 IP public trực tiếp | EC2 được ẩn sau CloudFront |

> **Screenshot:** ![CloudFront distribution Enabled](/images/evidence/week-12/04-CloudFront-Enabled.png)

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

#### Khó Khăn Gặp Phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Truy cập sai CloudFront domain nên bị `DNS_PROBE_FINISHED_NXDOMAIN` | Kiểm tra lại `Distribution domain name` trong CloudFront Console và cập nhật đúng domain vào `frontend/.env`, `.env.example`, GitHub Actions |
| CloudFront domain chưa dùng được ngay sau khi tạo | Đợi distribution chuyển sang trạng thái `Enabled/Deployed`, sau đó test lại bằng browser hoặc `curl -I` |
| CloudFront trả `AccessDenied` khi mở trang chính | Upload file build React trong `frontend/dist` lên S3, đảm bảo bucket có `index.html` và thư mục `assets/` |
| GitHub Actions build frontend nhưng CloudFront vẫn không có web mới | Thêm bước `aws s3 sync frontend/dist s3://simple-ecommerce-phamducthanh` vào workflow để deploy frontend lên S3 |
| CloudFront vẫn hiển thị nội dung cũ sau khi deploy | Thêm bước `aws cloudfront create-invalidation --distribution-id E3O2ME4OPGOUZ9 --paths "/*"` sau khi sync S3 |
| Ảnh upload lên S3 không hiển thị khi test local | Do bucket private và chỉ CloudFront được đọc qua OAC. Thêm `VITE_ASSET_BASE_URL` và chuyển URL ảnh S3 sang URL CloudFront trước khi render |
| API qua CloudFront bị lỗi `502` | Backend EC2 chạy HTTP port `8080`, nên CloudFront origin phải để `Protocol: HTTP only`, `HTTP port: 8080`, không dùng `HTTPS only` |
| API trực tiếp EC2 chạy được nhưng qua CloudFront lỗi | Kiểm tra behavior `/api/*` trỏ đúng EC2 origin, dùng cache policy `CachingDisabled`, origin request policy `AllViewer` |
| Chỉ cho phép `GET, HEAD` khiến API thêm/sửa/xóa/upload có thể lỗi | Cấu hình behavior `/api/*` cho phép đủ method: `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE` |
| Local frontend báo `Network Error` | Kiểm tra `VITE_API_URL` trong `frontend/.env`, test backend trực tiếp bằng `curl http://52.65.5.156:8080/api/products`, sau đó restart lại Vite dev server |
| Sửa `.env` nhưng frontend local vẫn dùng giá trị cũ | Tắt dev server và chạy lại `npm run dev` vì Vite chỉ đọc `.env` lúc khởi động |
| VS Code báo `Context access might be invalid` với AWS secrets | Đây là cảnh báo editor. Thêm đúng `AWS_ACCESS_KEY_ID` và `AWS_SECRET_ACCESS_KEY` trong GitHub Actions Secrets là workflow vẫn chạy được |
| Không biết lấy `AWS_ACCESS_KEY_ID` và `AWS_SECRET_ACCESS_KEY` ở đâu | Tạo IAM User cho GitHub Actions, tạo Access Key trong tab Security credentials, rồi lưu vào GitHub repo Secrets |
| Dễ xóa nhầm ảnh upload trong S3 khi sync frontend | Không dùng `aws s3 sync ... --delete` vì bucket đang chứa cả thư mục `images/` |
| README cũ chưa phản ánh kiến trúc CloudFront mới | Viết lại README với kiến trúc `CloudFront -> S3` cho frontend và `/api/* -> EC2 backend` |
