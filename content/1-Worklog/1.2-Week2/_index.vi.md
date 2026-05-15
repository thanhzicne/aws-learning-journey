---
title: "Worklog Tuần 2"
date: 2026-04-27
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

## Mục tiêu tuần 2

- Nắm vững S3: bucket, object, storage classes.
- Hiểu ACL, Bucket Policy, Public Access settings.
- Triển khai Static Website Hosting trên S3.
- Quản lý object versioning & lifecycle.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tạo S3 Bucket, tìm hiểu các khái niệm cơ bản: object, storage class, ACL | 27/04/2026 | 27/04/2026 | [Starting with Amazon S3](https://000057.awsstudygroup.com) |
| 3 | Cấu hình Static Website Hosting. Upload file HTML tĩnh lên S3 | 28/04/2026 | 28/04/2026 | [Enable Static Website – Lab 000057](https://000057.awsstudygroup.com/3-staticwebsite/) |
| 4 | **Thực hành Bucket Policy:** Cấu hình Public Read, tìm hiểu sự khác biệt giữa ACL và Bucket Policy | 29/04/2026 | 29/04/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| 5 | Bật Versioning. Upload lại file và restore version cũ. Tìm hiểu Lifecycle rules | 30/04/2026 | 30/04/2026 | [Bucket Versioning – Lab 000057](https://000057.awsstudygroup.com/8-versioning/) |
| 6 | Ôn tập, tổng hợp kiến thức tuần 2. Viết báo cáo worklog. Lên kế hoạch tuần 3 | 01/05/2026 | 01/05/2026 | |

### Kết quả đạt được tuần 2

- Static website chạy live trên S3: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`
- Bucket versioning được bật thành công.
- Ảnh sản phẩm accessible qua URL công khai.
- Hiểu rõ sự khác biệt giữa ACL và Bucket Policy.

#### Bài tập 1: Tạo S3 Bucket

Tạo bucket với tên `demo-bucket-phamducthanh` (bucket name phải unique toàn cầu):

- Region: `ap-southeast-2`
- Block all public access: **OFF** (để host static site)
- Versioning: **Enabled**

```bash
# Hoặc tạo bằng AWS CLI:
aws s3 mb s3://demo-bucket-phamducthanh --region ap-southeast-2
```

> **Screenshot:** ![S3 bucket created](/images/evidence/week-02/01-s3-bucket-created.png)

#### Bài tập 2: Upload file HTML tĩnh & cấu hình Static Website Hosting

Tạo 2 file HTML cơ bản và upload lên S3 bucket qua Console:

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

Vào bucket → Properties → Static website hosting:

- Enable: ✅
- Index document: `index.html`
- Error document: `error.html`

Endpoint URL: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`

> **Screenshot:** ![Files uploaded](/images/evidence/week-02/02-files-uploaded.png)
>
> **Screenshot:** ![Static hosting config](/images/evidence/week-02/03-static-hosting-config.png)

#### Bài tập 3: Cấu hình Bucket Policy (Public Read)

Thêm policy cho phép public đọc toàn bộ object trong bucket:

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

Nắm vững các khái niệm S3 quan trọng:

- **Bucket:** Container chứa objects (unique name toàn cầu)
- **Object:** File + metadata, key là đường dẫn đầy đủ
- **ACL:** Access Control List — kiểm soát ai đọc/ghi được
- **Bucket Policy:** JSON policy áp dụng cho toàn bucket
- **Presigned URL:** URL tạm thời để share private object

> **Screenshot:** ![Bucket policy](/images/evidence/week-02/04-bucket-policy.png)

#### Bài tập 4: Upload ảnh sản phẩm, bật Versioning & test access

Upload 3 ảnh sản phẩm vào folder `images/`. Test URL trực tiếp:

```text
https://demo-bucket-phamducthanh.s3.ap-southeast-2.amazonaws.com/images/avt.jpg
```

Khi bật versioning, mỗi lần upload lại file cũ sẽ **không ghi đè** mà tạo version mới. Có thể restore về version trước.

> **Screenshot:** ![Website live](/images/evidence/week-02/05-website-live.png)
>
> **Screenshot:** ![Product images accessible](/images/evidence/week-02/06-product-images-accessible.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Website hiện "403 Forbidden" dù đã public | Quên không bật "Block Public Access" → OFF trước khi add Policy |
| Ảnh upload nhưng URL trả về 403 | Bucket Policy chỉ áp dụng cho `/*`, ảnh trong folder `images/` vẫn được cover |
| Bucket name bị từ chối | Name phải lowercase, không dấu, unique toàn cầu → thêm tên/số vào cuối |

### Kế hoạch tuần 3

- Học EC2: launch instance, AMI, instance types.
- Cấu hình Security Group (inbound/outbound rules).
- SSH vào EC2 từ máy local.
- Cài Nginx web server trên EC2.
  