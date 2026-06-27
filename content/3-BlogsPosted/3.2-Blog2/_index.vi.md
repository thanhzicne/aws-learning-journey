---
title: "Blog 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

## [AWS Security] Bảo mật Serverless không nằm ở một lớp duy nhất

Serverless giúp chúng ta giải phóng hoàn toàn gánh nặng quản lý hạ tầng (server), nhưng điều đó không đồng nghĩa với việc hệ thống sẽ "tự động" an toàn. Trong kiến trúc serverless microservices, bất kỳ thành phần nào – từ API, Lambda function, secret key cho đến database – đều có thể trở thành lỗ hổng chí mạng nếu bị cấu hình sai.

Do đó, chiến lược bảo mật không bao giờ nên phó mặc vào một chốt chặn duy nhất như WAF hay API Gateway. Một kiến trúc chuẩn mực cần áp dụng nguyên tắc Defense-in-Depth (Bảo vệ chiều sâu): xây dựng nhiều lớp phòng thủ nối tiếp nhau. Nếu một rào chắn bị vượt qua, các lớp tiếp theo sẽ chặn đứng hoặc thu hẹp tối đa thiệt hại.

7 Lớp Bảo Vệ Cốt Lõi Trong Kiến Trúc AWS:

Edge Protection (Bảo vệ vùng biên): Đánh chặn các mối đe dọa ngay từ cổng vào của traffic bằng cách sử dụng kết hợp Amazon CloudFront, AWS WAF và AWS Shield.

Identity Protection (Bảo vệ danh tính): Quản lý xác thực người dùng và kiểm soát quyền truy cập chặt chẽ thông qua Amazon Cognito.

API Protection (Bảo vệ API): Che chắn API, xác thực token hợp lệ, giới hạn tần suất gọi (rate-limiting) và mã hóa kết nối thông qua Amazon API Gateway.

Network Isolation (Cô lập mạng): Đảm bảo tính riêng tư cho các tài nguyên nhạy cảm bằng hệ thống VPC, Security Group, Network ACL và VPC Endpoint.

Compute Security (Bảo mật tính toán): Thiết lập ranh giới an toàn cho Lambda function thông qua nguyên tắc đặc quyền tối thiểu (IAM least privilege), mã hóa KMS, resource-based policy và code signing.

Secrets Protection (Bảo vệ thông tin nhạy cảm): Quản lý tập trung và an toàn các thông tin như credential, API key, mật khẩu database bằng AWS Secrets Manager.

Data Protection (Bảo vệ dữ liệu): An toàn hóa kho dữ liệu bằng cơ chế mã hóa của DynamoDB, kiểm soát truy cập nghiêm ngặt và sao lưu (backup) định kỳ.

Giám Sát Liên Tục (Continuous Monitoring)

Vượt ra ngoài 7 lớp phòng thủ tĩnh, hệ thống cần được theo dõi 24/7 bằng các công cụ như Amazon GuardDuty, AWS CloudTrail, Amazon CloudWatch, AWS Security Hub và Amazon Bedrock. Lớp này đóng vai trò sống còn trong việc phát hiện các dấu hiệu bất thường, theo dõi hành vi và hỗ trợ phân tích bảo mật chuyên sâu.

Điểm Sáng Của Kiến Trúc

Sức mạnh của kiến trúc này nằm ở chỗ nó không phụ thuộc vào bất kỳ một "điểm kẹt" (single point of failure) nào. Giả sử hacker vượt qua được WAF, hệ thống vẫn còn đó API Gateway, Cognito, IAM, Secrets Manager và dàn monitoring phía sau để lập tức cản bước, giúp giảm thiểu tối đa phạm vi ảnh hưởng (blast radius).

Kết Luận

Serverless giúp giảm bớt công sức vận hành server, nhưng hoàn toàn không làm giảm đi trách nhiệm bảo mật của bạn. Với một hệ thống production, tính an toàn phải được "nhúng" vào ngay từ khâu thiết kế ban đầu – bao phủ toàn diện từ luồng traffic, xác thực, API, network, tính toán, secrets, dữ liệu cho đến quá trình giám sát liên tục.

**Nguồn tham khảo:** <https://aws.amazon.com/vi/blogs/security/building-an-ai-powered-defense-in-depth-security-architecture-for-serverless-microservices/>

**Hình ảnh:**
> ![poot2](/images/blogs/blog2/post2.png)

**Link bài viết:** <https://www.facebook.com/groups/awsstudygroupfcj/permalink/2189122901852670/?rdid=Lp3uW8qDC4gJGOC1#>
