---
title: "Blog 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---

## KHÁM PHÁ SỨC MẠNH CỦA KIẾN TRÚC ĐA ĐẶC VỤ (MULTI-AGENT) TRONG KIỂM THỬ BẢO MẬT

Trí tuệ nhân tạo (AI) đang phát triển với tốc độ chóng mặt, nhưng các AI Agent truyền thống vẫn thường gặp phải những giới hạn nhất định. Chúng khó lưu giữ thông tin lâu dài, khó hoạt động độc lập trong thời gian dài và thường cần đến sự giám sát liên tục của con người.

Để giải quyết bài toán này, kiến trúc Multi-Agent (Đa đặc vụ) đã ra đời và tạo nên một bước ngoặt lớn, đặc biệt là trong những lĩnh vực đòi hỏi tính chuyên môn cao như an toàn thông tin và kiểm thử xâm nhập (Penetration Testing).

Gần đây, AWS đã áp dụng kiến trúc này vào AWS Security Agent, cho thấy những lợi ích vượt trội sau:

### 1. Khả năng tự chủ và xử lý các bài toán phức tạp

Khác với AI thông thường, kiến trúc Multi-Agent sử dụng các "đặc vụ tiên phong" (frontier agents) có khả năng thực hiện các suy luận phức tạp, lập kế hoạch nhiều bước và hoạt động tự chủ hoàn toàn trong nhiều giờ, thậm chí nhiều ngày. Chúng không chỉ thực thi một lệnh đơn lẻ mà còn tự động điều chỉnh chiến lược dựa trên các phản hồi nhận được.

### 2. Tối ưu hóa nhờ sự phân công lao động chuyên sâu

Điểm mạnh nhất của kiến trúc Multi-Agent là sự hợp tác. Giống như một đội ngũ chuyên gia thực thụ, mỗi agent trong hệ thống được giao một nhiệm vụ chuyên biệt. Một agent có thể chịu trách nhiệm thu thập dữ liệu, agent khác phân tích lỗ hổng, trong khi các agent khác tiếp tục kiểm tra, xác minh và tổng hợp kết quả. Sự phân chia công việc này giúp tăng độ chính xác, tốc độ xử lý và khả năng mở rộng của hệ thống.

### 3. Khám phá được các lỗ hổng mang tính chuỗi (Chained Attacks)

Các công cụ quét lỗ hổng truyền thống thường chỉ tìm ra các lỗi đơn lẻ. Trong khi đó, hệ thống Multi-Agent có thể kết nối các điểm yếu nhỏ để tạo ra một kịch bản tấn công chuỗi phức tạp. Ví dụ, chúng có thể kết hợp một lỗi rò rỉ thông tin nhỏ với lỗ hổng leo thang đặc quyền để chỉ ra cách thức hacker có thể xâm nhập sâu vào hệ thống.

### 4. Tiết kiệm tối đa thời gian và nguồn lực

Kiểm thử bảo mật thủ công (Pentest) là một quá trình tốn kém và có thể kéo dài nhiều tuần. Bằng cách tự động hóa các khâu từ xác thực, quét cơ sở, lập kế hoạch khám phá cho đến tạo báo cáo chuẩn CVSS, hệ thống Multi-Agent giúp giảm tải đáng kể khối lượng công việc, cho phép các chuyên gia bảo mật tập trung vào việc khắc phục thay vì mất thời gian tìm kiếm.

### Tổng kết

Kiến trúc Multi-Agent chứng minh rằng: khi các AI chuyên biệt được kết nối và làm việc nhóm với nhau, chúng có thể giải quyết các quy trình công việc phức tạp vượt xa khả năng của một mô hình AI đơn lẻ. Trong tương lai, đây không chỉ là giải pháp cho ngành an ninh mạng mà còn là nền tảng cho việc tự động hóa các nghiệp vụ phức tạp trong nghiên cứu khoa học, phát triển phần mềm và hơn thế nữa.

**Nguồn tham khảo:** <https://aws.amazon.com/vi/blogs/security/inside-aws-security-agent-a-multi-agent-architecture-for-automated-penetration-testing/>

**Hình ảnh:**
> ![poot2](/images/blogs/blog3/post3.png)

**Link bài viết:** <https://www.facebook.com/groups/awsstudygroupfcj/permalink/2201822970582663/>
