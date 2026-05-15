---
title: "Worklog Tuần 12"
date: 2026-05-14
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

## Mục tiêu tuần 12

- Kiểm thử toàn bộ hệ thống end-to-end lần cuối.
- Hoàn thiện tất cả documentation: README, Deployment Guide, Architecture Diagram.
- Quay demo video và nộp project cho mentor.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Final testing toàn bộ hệ thống: CRUD sản phẩm, upload ảnh S3, CI/CD pipeline, CloudWatch alerts | 06/07/2026 | 06/07/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| 3 | Hoàn thiện README, Deployment Guide, Architecture Diagram. Rà soát lại toàn bộ documentation | 07/07/2026 | 07/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
| 4 | **Thực hành Final:** Quay demo video (3–5 phút): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | |
| 5 | Dọn dẹp tài nguyên AWS không cần thiết. Kiểm tra lại chi phí lần cuối với Cost Explorer | 09/07/2026 | 09/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 6 | Nộp project: GitHub repo + demo video + live app link. Viết báo cáo worklog tuần 12 và tổng kết 12 tuần | 10/07/2026 | 10/07/2026 | |

### Kết quả đạt được tuần 12

Tổng hợp toàn bộ kiến thức tích lũy qua 12 tuần học AWS:

- **Cloud Infrastructure:** Nắm vững mô hình global AWS (Region, AZ, Edge Location), thiết kế VPC với public/private subnet, cấu hình Security Group theo nguyên tắc Least Privilege, quản lý IAM user/group/role/policy và Billing.
- **Storage & Database:** Sử dụng S3 cho object storage và static hosting, RDS MySQL trong private subnet, hiểu các storage class của S3 và chiến lược Lifecycle Rule.
- **Compute & Networking:** Triển khai ứng dụng trên EC2, cấu hình VPC, hiểu luồng traffic giữa public và private subnet qua NAT Gateway, dùng AWS CLI để tương tác với các service.
- **Application Development:** Xây dựng REST API với Spring Boot, React SPA với Vite và Axios, kết nối Frontend → Backend → RDS → S3 thành một hệ thống hoàn chỉnh.
- **Containerization:** Viết Dockerfile (single-stage và multi-stage), cấu hình Docker Compose cho local dev, push image lên Docker Hub, chạy container trên EC2.
- **CI/CD:** Thiết lập GitHub Actions workflow tự động: build JAR → build Docker image → push Docker Hub → SSH deploy lên EC2. Hiểu sự khác biệt giữa GitHub Actions và AWS CodePipeline.
- **Monitoring & Security:** Cấu hình CloudWatch metrics và SNS alerts, thực hiện security audit cho IAM/Security Group/S3, tối ưu chi phí với Cost Explorer.
- **Documentation:** Viết README chuyên nghiệp, vẽ Architecture Diagram bằng draw.io, ghi Deployment Guide và Lessons Learned.

#### Final Checklist — Hạ tầng Cloud

Kiểm tra toàn bộ thành phần infrastructure trước khi nộp bài:

| Hạng mục | Mô tả | Trạng thái |
| :--- | :--- | :---: |
| VPC với public/private subnet | `10.0.0.0/16`, public subnet cho EC2, private subnet cho RDS | ✅ |
| EC2 Ubuntu instance | Chạy Spring Boot backend trên port 8080 | ✅ |
| RDS MySQL | Kết nối từ EC2, không có public access | ✅ |
| S3 bucket ảnh sản phẩm | Object storage, presigned URL hoặc public read cho ảnh | ✅ |
| S3 bucket frontend | Static Website Hosting, deploy React app | ✅ |
| IAM roles & policies | EC2 có role truy cập S3, dev-user có PowerUserAccess | ✅ |
| Security Groups | SSH chỉ mở cho IP cụ thể, RDS chỉ từ EC2 SG | ✅ |

> **Screenshot:** ![AWS Console overview](/images/evidence/week-12/01-aws-console-overview.png)

#### Final Checklist — Application

| Hạng mục | Mô tả | Trạng thái |
| :--- | :--- | :---: |
| React frontend responsive | Hiển thị danh sách sản phẩm, upload ảnh, thêm/sửa/xóa | ✅ |
| Spring Boot REST API | Đầy đủ CRUD endpoints, xử lý multipart upload | ✅ |
| Kết nối end-to-end | Frontend (S3) → Backend (EC2) → Database (RDS) → Storage (S3) | ✅ |

> **Screenshot:** ![App final demo](/images/evidence/week-12/02-app-final-demo.png)

#### Final Checklist — DevOps

| Hạng mục | Mô tả | Trạng thái |
| :--- | :--- | :---: |
| Dockerfile backend | `openjdk:17-jre-slim`, expose 8080 | ✅ |
| Dockerfile frontend | Multi-stage: `node:18-alpine` build + `nginx:alpine` serve | ✅ |
| docker-compose.yml | Chạy full stack (backend + frontend + MySQL) local | ✅ |
| GitHub Actions pipeline | Push code → build → push Docker Hub → deploy EC2 tự động | ✅ |

> **Screenshot:** ![GitHub Actions green](/images/evidence/week-12/03-github-actions-green.png)

#### Final Checklist — Monitoring & Docs

| Hạng mục | Mô tả | Trạng thái |
| :--- | :--- | :---: |
| CloudWatch monitoring | CPU, Memory, Disk metrics cho EC2; Storage metrics cho RDS | ✅ |
| SNS alerts | Cảnh báo khi CPU > 80% hoặc Free Tier gần hết | ✅ |
| Architecture diagram | Vẽ bằng draw.io, đầy đủ VPC/Subnet/EC2/RDS/S3/CI-CD | ✅ |
| README chuyên nghiệp | Table of Contents, Tech Stack, Setup guide, API docs, Lessons Learned | ✅ |
| Demo video | 3–5 phút, quay bằng Loom/OBS | ✅ |

> **Screenshot:** ![Architecture diagram final](/images/evidence/week-12/04-architecture-diagram-final.png)

#### Demo Video — Kịch bản quay

**Cấu trúc video 4 phút 30 giây:**

| Thời điểm | Nội dung | Điểm cần nhấn mạnh |
| :--- | :--- | :--- |
| 0:00 – 0:30 | Giới thiệu bản thân và mục tiêu project | Tên, chương trình học, bài toán giải quyết |
| 0:30 – 1:30 | Show và giải thích Architecture Diagram | Luồng dữ liệu từ User → React → EC2 → RDS/S3, vai trò CI/CD |
| 1:30 – 2:30 | Demo frontend: duyệt sản phẩm, upload ảnh, thêm/sửa/xóa | Chạy trực tiếp trên URL S3 Static Hosting |
| 2:30 – 3:30 | Show AWS Console: EC2 running, RDS connected, S3 objects, CloudWatch | Chứng minh hệ thống thật, không chỉ local |
| 3:30 – 4:00 | Show GitHub Actions: pipeline đang chạy hoặc vừa pass | Push một commit nhỏ, quay pipeline trigger |
| 4:00 – 4:30 | Tóm tắt Lessons Learned, điều muốn học tiếp theo | Thành thật, cụ thể — đây là phần reviewer nhớ lâu nhất |

> **Screenshot:** ![Demo video recording](/images/evidence/week-12/05-demo-video.png)

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
| 12 | Final Submission | Testing, demo video, nộp project |

#### Reflection — Nhìn lại hành trình

**Những gì tôi tự hào nhất:**
> ✏️ *Viết cảm nghĩ thật sự của bạn*

**Khó khăn lớn nhất đã vượt qua:**
> ✏️ *Ghi lại điều này để nhớ mãi*

**Điều tôi muốn học tiếp theo:**
> ✏️ *EKS? Lambda? Terraform? AWS Solutions Architect Associate?*

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| App chạy local nhưng lỗi trên EC2 | Kiểm tra Security Group port 8080, kiểm tra environment variables DB_URL trên EC2 |
| Demo video quay lại nhiều lần vì quên kịch bản | Viết kịch bản chi tiết từng phần, chạy thử 1 lần trước khi quay thật |
| GitHub repo chứa file `.env` bị push nhầm | Thêm `.env` vào `.gitignore`, dùng `git rm --cached .env` để xóa khỏi history |
| Quên xóa tài nguyên AWS sau khi nộp bài | Dùng AWS Cost Explorer sau 1 tuần để verify không còn phát sinh chi phí |
