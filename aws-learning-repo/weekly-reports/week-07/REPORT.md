# 📅 Báo cáo Tuần 7 — Backend Project (Spring Boot API)

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (08/06/2026 – 14/06/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Tạo Spring Boot project (Maven/Gradle)
- [ ] Implement REST API: CRUD sản phẩm
- [ ] Kết nối MySQL RDS
- [ ] Implement upload ảnh lên S3
- [ ] Deploy lên EC2

---

## 🔧 Bài tập thực hành

### Bước 1: Khởi tạo Spring Boot Project

```
Spring Initializr (start.spring.io):
- Project: Maven
- Language: Java 17
- Dependencies:
  ✓ Spring Web
  ✓ Spring Data JPA
  ✓ MySQL Driver
  ✓ AWS SDK S3
  ✓ Lombok
```

### Bước 2: Cấu hình application.properties

```properties
# Database (RDS)
spring.datasource.url=jdbc:mysql://<RDS-ENDPOINT>:3306/ecommerce
spring.datasource.username=admin
spring.datasource.password=${DB_PASSWORD}

# AWS S3
aws.s3.bucket=simple-ecommerce-fe-yourname
aws.region=ap-southeast-1
```

### Bước 3: Product API Endpoints

| Method | Endpoint | Mô tả |
|---|---|---|
| GET | `/api/products` | Lấy danh sách sản phẩm |
| GET | `/api/products/{id}` | Lấy 1 sản phẩm |
| POST | `/api/products` | Tạo sản phẩm mới |
| PUT | `/api/products/{id}` | Cập nhật sản phẩm |
| DELETE | `/api/products/{id}` | Xóa sản phẩm |
| POST | `/api/products/{id}/image` | Upload ảnh lên S3 |

> 📸 Screenshot: `01-api-postman-test.png`

### Bước 4: Build & Deploy lên EC2

```bash
# Build JAR
./mvnw clean package -DskipTests

# Copy lên EC2
scp -i key.pem target/ecommerce-0.0.1-SNAPSHOT.jar ubuntu@<EC2-IP>:~/

# SSH & chạy
ssh -i key.pem ubuntu@<EC2-IP>
sudo apt install openjdk-17-jre -y
java -jar ecommerce-0.0.1-SNAPSHOT.jar
```

> 📸 Screenshot: `02-api-running-ec2.png`

---

## 💡 Kiến thức quan trọng đã học

> ✏️ *Điền khi học xong*

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
