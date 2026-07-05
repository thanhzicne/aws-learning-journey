---
title: "Blog 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

## CloudFront ra mắt gói giá cố định (Flat-rate): Chấm dứt nỗi lo "sập ví" khi traffic tăng vọt

Amazon Web Services (AWS) chính thức công bố các gói flat-rate pricing cho Amazon CloudFront. Đây là một bước đi cực kỳ đột phá, thay đổi hoàn toàn cách tính phí dịch vụ CDN vốn dĩ gắn liền với mô hình pay-as-you-go (dùng bao nhiêu trả bấy nhiêu) đầy rủi ro suốt từ năm 2008.

1. Nỗi ám ảnh mang tên "Mô hình trả theo nhu cầu"
Dự toán chi phí cực kỳ "đau đầu": Trước đây, để tính xem một tháng hết bao nhiêu tiền Cloud, bạn phải ngồi cộng gộp biểu phí phức tạp từ hàng loạt dịch vụ đi kèm: CDN, WAF, DNS, Route 53 cho đến CloudWatch Logs...
Rủi ro hóa đơn "tăng phi mã": Chỉ cần một bài viết bất ngờ viral, hoặc đen đủi hơn là dính một đợt tấn công DDoS, sáng ngủ dậy nhận cái hóa đơn AWS hàng ngàn USD là chuyện hoàn toàn có thể xảy ra.

2. Giải pháp: 4 gói giá cố định, KHÔNG PHỤ PHÍ
Gói CloudFront flat-rate mới sẽ gộp tất cả trong một (All-in-one) với một mức phí cố định hàng tháng. Đăng ký gói này, bạn có ngay: CloudFront CDN, AWS WAF & Anti-DDoS, Bot Management, Route 53 DNS, CloudWatch Logs, Serverless Edge Compute (CloudFront Functions/Lambda@Edge), và cả credit lưu trữ cho S3.
Đặc biệt, không yêu cầu cam kết theo năm, tùy biến theo quy mô:
Free ($0/tháng): 1 triệu request + 100GB data transfer. (Quá ngon cho dự án cá nhân, đồ án sinh viên).
Pro ($15/tháng): 10 triệu request + 50TB data transfer.
Business ($200/tháng): 125 triệu request + 50TB data transfer.
Premium ($1,000/tháng): 500 triệu request + 50TB data transfer. (Mỗi tài khoản AWS được đăng ký tối đa 3 gói Free và tổng cộng 100 gói các loại).

3. Điểm khác biệt cốt lõi: Vượt hạn mức thì sao?
Không tính thêm tiền: Nếu traffic vượt quá allowance (hạn mức) của gói, AWS không tự động trừ thêm tiền của bạn. Thay vào đó, hiệu suất hệ thống có thể giảm nhẹ một chút (ví dụ: điều hướng phục vụ từ ít Edge Location hơn).
Cảnh báo chủ động: AWS sẽ gửi alert khi bạn xài hết 50%, 80%, và 100% hạn mức để bạn chủ động nâng cấp gói nếu cần.
Miễn trừ Traffic bẩn: Toàn bộ request bị block bởi AWS WAF hoặc traffic từ các đợt tấn công DDoS sẽ không bị tính vào hạn mức. Gặp DDoS thì WAF lo, ví tiền của bạn vẫn an toàn!
4. Điểm cộng: Tối ưu cho cả nội dung động (Dynamic Content)
Nhiều người nghĩ CDN chỉ ngon khi làm việc với static files (hình ảnh, video, asset). Nhưng CloudFront đứng trước API hoặc Web App vẫn giúp tăng tốc đáng kể nhờ:
Rút ngắn thời gian bắt tay (TLS handshake) tại các điểm PoP gần user nhất.
Duy trì kết nối thường trực (Persistent Connection) về Origin Server để giảm độ trễ tạo connection mới.
Định tuyến traffic chạy qua mạng đường trục (Backbone) riêng siêu tốc của AWS thay vì Internet công cộng.

5. Góc nhìn cho các dự án và AE Developer
Đối với anh em đang làm dự án cá nhân, đồ án tốt nghiệp, hoặc các startup làm MVP đang trong giai đoạn chạy thử nghiệm: Hãy chọn ngay gói Free ($0/tháng).
Bạn vừa tận dụng được hệ sinh thái xịn mịn (CDN + Route 53 + S3 credit), vừa có thể tự tin quăng link demo cho bạn bè, cộng đồng vào test thoải mái mà không lo kịch bản "bỗng dưng mất tiền triệu" sau một đêm.

**Nguồn tham khảo:** <https://aws.amazon.com/vi/blogs/security/building-an-ai-powered-defense-in-depth-security-architecture-for-serverless-microservices/>

**Hình ảnh:**
> ![poot1](/images/blogs/blog1/post1.png)

**Link bài viết:** <https://www.facebook.com/groups/awsstudygroupfcj/posts/2182560955842198/?comment_id=2183278822437078&notif_id=1781333970622892&notif_t=group_comment>
