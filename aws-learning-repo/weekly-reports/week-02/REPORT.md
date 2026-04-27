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

Tạo bucket name: demo-bucket-phamducthanh (bucket name phải unique toàn cầu):

- Region: `ap-southeast-2`
- Block all public access: **OFF** (để host static site)
- Versioning: **Enabled**

```bash
# Hoặc tạo bằng AWS CLI:
aws s3 mb s3://demo-bucket-phamducthanh --region ap-southeast-2
```

> 📸 **Screenshot:** [01-s3-bucket-created](../../screenshots/week-02/01-s3-bucket-created.png)

---

### ✅ Bước 2: Upload file HTML tĩnh

Tạo 2 file HTML cơ bản:

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head><title>E-Commerce Mini</title></head>
<body>
  <h1>Pham Duc Thanh</h1>
  <p>Hosted on AWS S3</p>
  <a href="products.html">View Products</a>
</body>
</html>
```

Upload lên S3 bucket qua Console.

> 📸 **Screenshot:** [02-files-uploaded](../../screenshots/week-02/002-files-uploaded.png)
---

### ✅ Bước 3: Cấu hình Static Website Hosting

Vào bucket → Properties → Static website hosting:

- Enable: ✅
- Index document: `index.html`
- Error document: `error.html`

Endpoint URL: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`

> 📸 **Screenshot:** [03-static-hosting-config](../../screenshots/week-02/03-static-hosting-config.png)
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
      "Resource": "arn:aws:s3:::demo-bucket-phamducthanh/*"
    }
  ]
}
```

> 📸 **Screenshot:** [04-bucket-policy](../../screenshots/week-02/04-bucket-policy.png)
---

### ✅ Bước 5: Upload ảnh sản phẩm & test access

Upload 3 ảnh sản phẩm vào folder `images/`. Test URL trực tiếp:

```text
https://demo-bucket-phamducthanh.s3.ap-southeast-2.amazonaws.com/images/avt.jpg
```

> 📸 **Screenshot:** [05-website-live](../../screenshots/week-02/05-website-live.png)
> 📸 **Screenshot:** [06-product-images-accessible](../../screenshots/week-02/06-product-images-accessible.png)

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

- ✅ Static website chạy live trên S3: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`
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

*Cập nhật: 27/04/2026 | [Pham Đuc Thanh]*
