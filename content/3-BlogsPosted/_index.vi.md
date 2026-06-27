---
title: "Các bài blogs đã đăng"
date: 2026-05-14
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

## [Blog 1 - CloudFront ra mắt gói giá cố định (Flat-rate): Chấm dứt nỗi lo "sập ví" khi traffic tăng vọt](3.1-Blog1/)

Bài viết cập nhật bước đi đột phá của AWS khi chuyển đổi từ mô hình tính phí "dùng bao nhiêu trả bấy nhiêu" rủi ro sang các gói cước cố định (All-in-one) hàng tháng cho CloudFront. Bạn sẽ khám phá chi tiết 4 gói cước (bao gồm cả gói Free lý tưởng cho startup), cơ chế không tính phụ phí khi vượt hạn mức, và đặc quyền miễn trừ phí cho các luồng traffic bẩn (DDoS), giúp tối ưu chi phí hạ tầng mạng một cách an toàn và dễ dự đoán.

## [Blog 2 - [AWS Security] Bảo mật Serverless không nằm ở một lớp duy nhất](3.2-Blog2/)

Bài viết giải quyết lầm tưởng phổ biến: "Serverless là tự động an toàn". Tác giả đi sâu phân tích kiến trúc bảo vệ chiều sâu với 7 lớp phòng thủ độc lập (từ Edge, Identity, API đến Data và Monitoring). Qua đó, người đọc sẽ hiểu cách thiết kế một hệ thống vi dịch vụ (microservices) kiên cố, đảm bảo rằng nếu một chốt chặn bị xuyên thủng, các rào chắn phía sau vẫn đứng vững để thu hẹp tối đa rủi ro thiệt hại.

## [Blog 3 - ...](3.3-Blog3/)

Blog này giới thiệu Amazon EKS Pod Identity vừa bổ sung tính năng session policies, cho phép bạn thu hẹp quyền IAM một cách linh hoạt và chính xác cho từng pod mà không cần tạo thêm nhiều IAM roles riêng biệt. Đây là bước tiến quan trọng giúp áp dụng nguyên tắc least privilege hiệu quả hơn trong môi trường Kubernetes quy mô lớn.
