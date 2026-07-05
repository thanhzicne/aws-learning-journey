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
| 4 | Thực hành Security: Audit Security Groups (SSH, RDS, ports). Audit S3 (public access, versioning, lifecycle) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| 5 | Vẽ Architecture Diagram bằng draw.io. Xác định đầy đủ các thành phần: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| 6 | Ôn tập, viết báo cáo worklog. Tiếp tục hoàn thiện và test lại từng chức năng dự án nhóm, viết Propoasl, Workshop dự án. Lên kế hoạch tuần 12 | 03/07/2026 | 03/07/2026 | |

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

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

---

#### Bài tập 3: Security Audit — Security Groups và S3

**Security Groups — nguyên tắc tối thiểu hóa bề mặt tấn công:**

- **SSH (port 22):** Chỉ mở cho IP cụ thể của máy dev, không mở `0.0.0.0/0` — nếu mở rộng rãi, bot sẽ brute-force liên tục.
- **RDS (port 3306):** Chỉ cho phép inbound từ Security Group của EC2, không gán Public IP cho RDS.
- **Application (port 8080):** Chỉ mở khi cần, hoặc đặt sau Load Balancer — expose cổng ứng dụng trực tiếp ra internet là anti-pattern.

> **Screenshot:** ![Security Group audit](/images/evidence/week-11/03-security-group-audit.png)
>
> **Screenshot:** ![S3 security settings](/images/evidence/week-11/04-s3-security.png)

---

#### Bài tập 4: Architecture Diagram

**Tại sao cần Architecture Diagram:**

Architecture Diagram không chỉ là tài liệu đẹp — đây là công cụ tư duy giúp phát hiện điểm yếu trong thiết kế (single point of failure, bottleneck, security gap) trước khi code. Khi onboard thành viên mới hoặc trình bày với stakeholder, diagram thay thế hàng chục trang văn bản.

**Công cụ vẽ:** [draw.io](https://draw.io) — miễn phí, có sẵn AWS icon library, export được PNG/SVG/PDF.

> **Screenshot:** ![Architecture diagram](/images/evidence/week-11/05-architecture-diagram.png)

---

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| NAT Gateway chiếm phần lớn chi phí | Chuyển traffic S3 sang VPC Gateway Endpoint (miễn phí), không đi qua NAT |
| Cost Explorer không hiển thị chi tiết theo tag | Bật Cost Allocation Tags trong Billing settings, đợi 24h để data hiện |
| RDS vẫn tính phí khi "stopped" sau 7 ngày | AWS tự động start lại RDS sau 7 ngày stopped — cần snapshot rồi xóa hẳn nếu không dùng lâu dài |

---

## Kế hoạch tuần 12

- Tìm hiểu và triển khai CloudFront CDN và Route 53 DNS để hoàn thiện kiến trúc với HTTPS và custom domain.
- Kiểm thử toàn bộ hệ thống end-to-end lần cuối trên domain thật.
- Dọn dẹp tài nguyên AWS.
- Hoàn thiện báo cáo thực tập.
