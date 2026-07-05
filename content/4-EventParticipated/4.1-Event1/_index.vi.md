---
title: "Event 1"
date: 2026-06-08
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

## Bài thu hoạch "FCAJ Community Day"

### Tổng Quan Sự Kiện

**FCAJ Community Day** là sự kiện cộng đồng do nhóm **First Cloud A Journey (FCAJ)** tổ chức, quy tụ gần 400 người tham dự tại tầng 26, **Bitexco Financial Tower**, TP. Hồ Chí Minh. Đây là một buổi sáng học hỏi và kết nối chuyên sâu, nơi các diễn giả đến từ chính cộng đồng – những sinh viên và người đi trước – chia sẻ kiến thức thực chiến về AI, Cloud, và công nghệ hiện đại.

Điểm đặc biệt của sự kiện nằm ở tinh thần **"by the community, for the community"**: người nói chuyện không phải các chuyên gia xa vời, mà là những người đang cùng hành trình với người nghe – điều đó làm cho nội dung gần gũi, thực tế và có chiều sâu hơn nhiều.

---

### Mục Đích Của Sự Kiện

- Kết nối cộng đồng First Cloud Journey – những người đang học và thực hành AWS tại Việt Nam
- Chia sẻ kiến thức thực tiễn về AI, Cloud và các công nghệ hiện đại từ người có kinh nghiệm thực chiến
- Truyền cảm hứng và định hướng nghề nghiệp cho sinh viên và lập trình viên trẻ đang bước vào lĩnh vực cloud
- Tạo không gian học hỏi peer-to-peer, nơi kiến thức được chia sẻ ngang hàng thay vì từ trên xuống
- Xây dựng và củng cố hệ sinh thái cộng đồng AWS Việt Nam ngày càng lớn mạnh

---

### Thông Tin Sự Kiện

| Thông tin | Chi tiết |
| --- | --- |
| **Tên sự kiện** | FCAJ Community Day |
| **Tổ chức bởi** | Huỳnh Hoàng Long, Thiện Lữ & Trần Đại Vĩ |
| **Địa điểm** | Tầng 26, Bitexco Financial Tower, 2 Hải Triều, Quận 1, TP. HCM |
| **Số lượng tham dự** | ~399 người |
| **Thời gian** | 9:00 – 12:00 ngày 23/05/2026 |
| **Ngôn ngữ** | Tiếng Việt |

---

### Danh Sách Các Session

| Thời gian | Chủ đề | Nội dung chính |
| --- | --- | --- |
| 08:30 – 09:00 | Check-in | Ổn định chỗ ngồi tại tầng 26 |
| 09:00 – 09:30 | Context Is Everything | Making AI Actually Work for You |
| 09:30 – 09:45 | Friendly AI Assistant | Amazon QuickSight Q |
| 09:45 – 10:25 | From Edge To Origin | CloudFront as Your Foundation |
| 10:25 – 10:55 | 36 hrs with LotusHacks | Building UTMorpho from Idea to Reality |
| 10:55 – 11:00 | Break | Nghỉ giải lao |
| 11:00 – 11:30 | Non-Determinism of LLM | "Deterministic" Settings |
| 11:30 – 12:00 | Multi-Agent System | Enterprise Credit Scoring Case Study |

---

### Nội Dung Chi Tiết Các Session

#### Session 1: Context Is Everything – Making AI Actually Work for You (09:00 – 09:30)

Diễn giả đặt thẳng vấn đề: **tại sao AI thường cho kết quả tệ**, và câu trả lời không nằm ở AI mà nằm ở **người dùng thiếu context**.

**Tại sao AI thất bại:**

- Prompt ngắn, chung chung → câu trả lời chung chung, không có giá trị thực tế
- Thiếu background, thiếu mục tiêu, thiếu ràng buộc → AI không thể tối ưu cho use case cụ thể

**"Context" thực sự là gì:**

- Gồm: role bạn muốn AI đóng, mục tiêu cụ thể, ràng buộc, ví dụ mẫu, và lịch sử tương tác
- Concept **Second AI Brain**: xây dựng một "bộ nhớ thứ hai" tích lũy theo thời gian thay vì hỏi AI từng lần một

**Sự tiến hóa của cách dùng AI:**

- Giai đoạn 1: Dùng prompt đơn lẻ, kết quả ngẫu nhiên
- Giai đoạn 2: Biết viết prompt có cấu trúc
- Giai đoạn 3: Xây dựng context system bền vững, AI hiểu bạn theo thời gian

---

#### Session 2: Friendly AI Assistant with Amazon QuickSight Q (09:30 – 09:45)

- **Quick Chat Agent:** Đặt câu hỏi bằng ngôn ngữ tự nhiên để khám phá dataset, không cần biết SQL.
- **Quick Flows:** Tạo intelligent workflows bằng cách mô tả bằng tiếng Việt/Anh, không cần code.
- **Quick Spaces:** Không gian cộng tác chia sẻ insight từ cá nhân ra cả team, giải quyết vấn đề "data silo".
- **QuickSight Dashboards:** Xây dựng dashboard từ raw data bằng ngôn ngữ tự nhiên, AI tự đề xuất loại biểu đồ phù hợp.

---

#### Session 3: From Edge To Origin – CloudFront as Your Foundation (09:45 – 10:25)

CloudFront không chỉ là CDN mà là **nền tảng toàn diện** cho mọi workload hiện đại.

**Cost Optimization:**

- **Price Class**: chọn edge locations phù hợp theo region người dùng
- **Cache hit ratio**: tăng tỷ lệ cache hit → giảm request đến origin → giảm chi phí
- **Origin Shield**: thêm lớp cache tập trung trước origin
- **Compression**: bật Gzip/Brotli tự động để giảm băng thông

**Security:**

- Tích hợp **AWS WAF**, **Shield Standard/Advanced**, **HTTPS/TLS 1.3**
- **Geo restriction**, **Signed URLs/Cookies** cho nội dung private
- **OAC**: bảo vệ S3 bucket chỉ cho phép CloudFront truy cập

**Performance & Reliability:**

- Hơn **600 edge locations** toàn cầu, **HTTP/2 và HTTP/3**, persistent connections
- Tự động failover, health check, retry logic tích hợp sẵn

---

#### Session 4: 36 hrs with LotusHacks – Building UTMorpho (10:25 – 10:55)

**UTMorpho** là platform AI-powered learning path cá nhân hóa cho sinh viên, được build trong 36 giờ hackathon.

**Key learnings:**

- Xác định MVP trong 2 giờ đầu là quyết định quan trọng nhất
- Biết cắt feature đúng lúc: bỏ 2 feature lớn ở giờ thứ 28 để có demo ổn định
- **Communication trong team quan trọng hơn technical skill** khi làm việc dưới áp lực
- Hackathon không phải về winning mà về **learning velocity**

---

#### Session 5: Non-Determinism of "Deterministic" LLM Settings (11:00 – 11:30)

**Misconception phổ biến:** Temperature=0 không đảm bảo kết quả luôn giống nhau.

**Nguyên nhân vẫn non-deterministic:**

- Floating point arithmetic không deterministic trên GPU
- Tensor parallelism khi model chia cho nhiều GPU
- Load balancer route request đến server instance khác nhau
- Quantization (int8, int4) làm mất một phần precision

**Mitigation strategies:**

- Seed control, output validation layer, caching layer
- Thiết kế hệ thống **chịu được** non-determinism thay vì chống lại nó

---

#### Session 6: Enterprise-Grade Multi-Agent System – Startup Credit Scoring (11:30 – 12:00)

**Vấn đề:** Startup bị underserved vì ngân hàng không thể đánh giá đúng do thiếu lịch sử tài chính, tài sản intangible, dòng tiền biến động.

**Tại sao Multi-Agent:** Single agent xử lý nhiều loại dữ liệu → context overflow, kém chính xác, khó maintain.

**Virtual Credit Committee:**

- Data Collection → Financial Analysis → Market Intelligence → Team Assessment → Risk Scoring
- Orchestrator điều phối toàn bộ pipeline

**Guardrails:** Explainability bắt buộc, human-in-the-loop cho quyết định lớn, audit trail đầy đủ, bias detection định kỳ.

---

### Những Gì Học Được

#### Tư Duy Về AI & Context

- **Context-first mindset**: Chất lượng output của AI phụ thuộc hoàn toàn vào chất lượng context đầu vào – không phải tìm AI mạnh hơn, mà cần học cách cung cấp context tốt hơn.
- **Second AI Brain concept**: Xây dựng hệ thống context tích lũy theo thời gian thay vì hỏi AI từng lần một.
- **LLM là probabilistic, không phải deterministic**: Dù set Temperature=0, kết quả vẫn có thể thay đổi do floating point arithmetic, tensor parallelism, và inference optimization.
- **Multi-Agent thinking**: Khi bài toán đủ phức tạp, phân tách thành các agent chuyên biệt giúp tăng chất lượng và khả năng maintain.

#### Kiến Trúc Kỹ Thuật AWS

- **CloudFront là nền tảng, không chỉ là CDN**: Bao gồm security (WAF, Shield), routing thông minh, edge computing (Lambda@Edge), và cost optimization.
- **OAC vs OAI**: OAC là phương pháp mới hơn, bảo mật hơn để giới hạn S3 chỉ cho phép CloudFront truy cập.
- **Cache strategy toàn diện**: Cần cân nhắc TTL theo từng loại content, invalidation strategy, Origin Shield, và cache hit ratio để tối ưu cả cost lẫn performance.

#### Tư Duy Sản Phẩm & Kỹ Năng Mềm

- **Done beats perfect**: Sản phẩm hoạt động 80% tính năng tốt hơn sản phẩm có đủ tính năng nhưng không ổn định.
- **Communication dưới áp lực**: Giao tiếp rõ ràng và thường xuyên quan trọng hơn technical skill khi deadline cận kề.
- **Scope management**: Biết nói "không" với feature mới và giữ vững MVP scope là kỹ năng cực kỳ quan trọng.

---

### Ứng Dụng Vào Công Việc

- **Cải thiện cách dùng AI**: Tạo system prompt đầy đủ, cung cấp context rõ ràng về codebase, tech stack, và constraints trước khi hỏi AI.
- **CloudFront production-ready**: Cấu hình OAC đúng cách, tối ưu cache behavior, bật compression, xem xét Origin Shield.
- **LLM integration awareness**: Temperature=0 không đảm bảo determinism, cần có validation layer và caching strategy.
- **Multi-Agent approach**: Với bài toán AI phức tạp, mỗi agent có scope rõ ràng sẽ dễ test và maintain hơn.

---

### Trải Nghiệm Trong Event

- Người chia sẻ chính là những người trong cộng đồng – kỹ sư đang đi làm, sinh viên vừa tốt nghiệp – tạo ra sự gần gũi và thực tế hơn so với các sự kiện thông thường.
- Giá trị lớn không chỉ đến từ nội dung session mà còn từ những người gặp được – cùng học AWS, cùng gặp vấn đề tương tự, cảm giác không học một mình.

---

### Một số hình ảnh khi tham gia sự kiện

> ![join_event2](/images/events/event1/join_event2.jpg)
>
> ![Session1](/images/events/event1/ss1.png)
>
> ![Session2](/images/events/event1/ss2.png)
>
> ![Session4](/images/events/event1/ss3.png)
>
> ![Session6](/images/events/event1/ss4.png)
>
> ![Session1](/images/events/event1/ss1.png)
>
> ![Session2](/images/events/event1/ss5.png)
>
> ![Session4](/images/events/event1/ss6.png)
>
> ![Session6](/images/events/event1/ss7.png)
>
> ![Session6](/images/events/event1/ss8.png)
