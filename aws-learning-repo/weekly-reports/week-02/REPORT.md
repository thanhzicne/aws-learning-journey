# 📅 Báo cáo Tuần 2 — Amazon S3 + Static Website Hosting

> **Thời gian học:**  (27/04/2026 – 03/05/2026)

---

## 🎯 Mục tiêu tuần này

- [x] Nắm vững S3: bucket, object, storage classes
- [x] Hiểu ACL, Bucket Policy, Public Access settings
- [x] Triển khai Static Website Hosting trên S3
- [x] Quản lý object versioning & lifecycle

---

## 🔧 Bài tập thực hành

### ✅ Bước 1: Tạo S3 Bucket

Tạo bucket `simple-ecommerce-fe-[tên-bạn]` (bucket name phải unique toàn cầu):

- Region: `ap-southeast-1`
- Block all public access: **OFF** (để host static site)
- Versioning: **Enabled**

```bash
# Hoặc tạo bằng AWS CLI:
aws s3 mb s3://simple-ecommerce-fe-yourname --region ap-southeast-1
```

> 📸 **Screenshot:** [`01-s3-bucket-created.png`](./screenshots/01-s3-bucket-created.png)

---

### ✅ Bước 2: Upload file HTML tĩnh

Tạo 2 file HTML cơ bản:

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head><title>E-Commerce Mini</title></head>
<body>
  <h1>Welcome to E-Commerce Mini Cloud! ☁️</h1>
  <p>Hosted on AWS S3</p>
  <a href="products.html">View Products</a>
</body>
</html>
```

Upload lên S3 bucket qua Console.

> 📸 **Screenshot:** [`02-files-uploaded.png`](./screenshots/02-files-uploaded.png)

---

### ✅ Bước 3: Cấu hình Static Website Hosting

Vào bucket → Properties → Static website hosting:

- Enable: ✅
- Index document: `index.html`
- Error document: `error.html`

Endpoint URL: `http://simple-ecommerce-fe-yourname.s3-website-ap-southeast-1.amazonaws.com`

> 📸 **Screenshot:** [`03-static-hosting-config.png`](./screenshots/03-static-hosting-config.png)

---

### ✅ Bước 4: Cấu hình Bucket Policy (Public Read)

Thêm policy cho phép public đọc file:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::simple-ecommerce-fe-yourname/*"
    }
  ]
}
```

> 📸 **Screenshot:** [`04-bucket-policy.png`](./screenshots/04-bucket-policy.png)

---

### ✅ Bước 5: Upload ảnh sản phẩm & test access

Upload 3 ảnh sản phẩm vào folder `images/`. Test URL trực tiếp:

```text
https://simple-ecommerce-fe-yourname.s3.ap-southeast-1.amazonaws.com/images/product1.jpg
```

> 📸 **Screenshot:** [`05-website-live.png`](./screenshots/05-website-live.png)  
> 📸 **Screenshot:** [`06-product-images-accessible.png`](./screenshots/06-product-images-accessible.png)

---

## 💡 Kiến thức quan trọng đã học

### S3 Core Concepts

| Khái niệm | Mô tả |
| :--- | :--- |
| **Bucket** | Container chứa objects (unique name toàn cầu) |
| **Object** | File + metadata, key là đường dẫn đầy đủ |
| **ACL** | Access Control List — kiểm soát ai đọc/ghi được |
| **Bucket Policy** | JSON policy áp dụng cho toàn bucket |
| **Presigned URL** | URL tạm thời để share private object |

### S3 Storage Classes (Chi phí giảm dần)

``` text
S3 Standard        → Truy cập thường xuyên
S3 Standard-IA     → Truy cập không thường xuyên
S3 One Zone-IA     → Giống Standard-IA, 1 AZ (rẻ hơn)
S3 Glacier         → Archive, lấy lại mất vài giờ
S3 Glacier Deep    → Archive lâu dài, rẻ nhất
```

### Versioning

Khi bật versioning, mỗi lần upload lại file cũ sẽ **không ghi đè** mà tạo version mới. Có thể restore về version trước.

---

## ❌ Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Website hiện "403 Forbidden" dù đã public | Quên không bật "Block Public Access" → OFF trước khi add Policy |
| Ảnh upload nhưng URL trả về 403 | Bucket Policy chỉ áp dụng cho `/*`, ảnh trong folder `images/` vẫn được cover |
| Bucket name bị từ chối | Name phải lowercase, không dấu, unique toàn cầu → thêm tên/số vào cuối |

---

## 📊 Kết quả đạt được

- ✅ Static website chạy live trên S3: `http://simple-ecommerce-fe-yourname.s3-website-ap-southeast-1.amazonaws.com`
- ✅ Bucket versioning enabled
- ✅ Ảnh sản phẩm accessible qua URL công khai
- ✅ Hiểu rõ sự khác biệt giữa ACL và Bucket Policy

---

## 🔜 Kế hoạch tuần 3

- [ ] Học EC2: launch instance, AMI, instance types
- [ ] Cấu hình Security Group (inbound/outbound rules)
- [ ] SSH vào EC2 từ máy local
- [ ] Cài Nginx web server trên EC2

---

*Cập nhật: 03/05/2026 | [Pham Đuc Thanh]*
