---
title: "Worklog Tuần 7"
date: 2026-05-14
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

## Mục tiêu tuần 7

- Tạo Spring Boot project (Maven/Gradle).
- Implement REST API: CRUD sản phẩm.
- Kết nối MySQL RDS.
- Implement upload ảnh lên S3.
- Deploy lên EC2.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Khởi tạo Spring Boot project qua Spring Initializr. Cấu hình `application.properties` kết nối RDS | 01/06/2026 | 01/06/2026 | [Spring Initializr](https://start.spring.io) · [AWS SDK for Java – S3](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/examples-s3.html) |
| 3 | Implement Product entity, JPA Repository, Service, Controller. Test CRUD API bằng Postman | 02/06/2026 | 02/06/2026 | [Application Deployment – Lab 000005](https://000005.awsstudygroup.com/5-deploy-app/) |
| 4 | **Thực hành S3 Upload:** Implement endpoint upload ảnh sản phẩm lên S3. Cấu hình IAM Role cho EC2 | 03/06/2026 | 03/06/2026 | [Starting with Amazon S3 – Lab 000057](https://000057.awsstudygroup.com) |
| 5 | Build JAR, copy lên EC2, cài Java 17, chạy ứng dụng. Test API từ Postman qua Public IP | 04/06/2026 | 04/06/2026 | [Configure EC2 Instance – Lab 000015](https://000015.awsstudygroup.com/5-configure-ec2/) |
| 6 | Test toàn bộ API endpoints. Ôn tập, viết báo cáo worklog. Lên kế hoạch tuần 8 | 05/06/2026 | 05/06/2026 | [Test Application – Lab 000015](https://000015.awsstudygroup.com/6-docker-image/2-test-app/) |

### Kết quả đạt được tuần 7

- Spring Boot project khởi tạo thành công, kết nối được RDS MySQL.
- REST API CRUD hoàn chỉnh: 6 endpoints cho resource `products`.
- Upload ảnh sản phẩm lên S3 hoạt động, trả về public URL.
- Ứng dụng deploy thành công trên EC2, accessible qua Public IP.

#### Bài tập 1: Khởi tạo Spring Boot Project

Tạo project tại [start.spring.io](https://start.spring.io) với cấu hình:

```text
Spring Initializr:
- Project: Maven
- Language: Java 25
- Dependencies:
    Spring Web
    Spring Data JPA
    MySQL Driver
    AWS SDK S3
    Lombok
```

Cấu hình `application.properties`:

```properties
# Database — RDS
spring.datasource.url=jdbc:mysql://<RDS-ENDPOINT>:3306/ecommerce
spring.datasource.username=admin
spring.datasource.password=${DB_PASSWORD}
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# AWS S3
aws.s3.bucket=simple-ecommerce-fe-yourname
aws.region=ap-southeast-1
```

**Lưu ý bảo mật:** Không hardcode password trong `application.properties` — dùng biến môi trường `${DB_PASSWORD}` hoặc AWS Secrets Manager.

> **Screenshot:** ![Spring Initializr setup](/images/evidence/week-07/00-spring-init.png)

#### Bài tập 2: Product CRUD API

Implement theo kiến trúc 3 lớp (Entity → Repository → Service → Controller).

Product entity kết nối trực tiếp với bảng `products` đã tạo ở tuần 5. Các endpoints REST API:

| Method | Endpoint | Mô tả |
| :--- | :--- | :--- |
| GET | `/api/products` | Lấy danh sách sản phẩm |
| GET | `/api/products/{id}` | Lấy 1 sản phẩm theo ID |
| POST | `/api/products` | Tạo sản phẩm mới |
| PUT | `/api/products/{id}` | Cập nhật sản phẩm |
| DELETE | `/api/products/{id}` | Xóa sản phẩm |
| POST | `/api/products/{id}/image` | Upload ảnh lên S3 |

Kiến thức quan trọng về luồng dữ liệu trong Spring Boot:

```text
HTTP Request
    ↓
Controller  (@RestController)     — nhận request, trả response JSON
    ↓
Service     (@Service)            — business logic
    ↓
Repository  (JpaRepository)       — tương tác với RDS MySQL
    ↓
RDS MySQL (private subnet)
```

>**GET**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-GET.png)
>**POST**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-POST.png)
>**GET ID**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-GETID.png)
>**PUT**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-PUT.png)
>**DELETE**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-DELETE.png)

#### Bài tập 3: Upload Ảnh Sản Phẩm lên S3

Thêm dependency AWS SDK vào `pom.xml`:

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
    <version>2.25.0</version>
</dependency>
```

Tạo IAM Role `ec2-s3-role` với policy `AmazonS3FullAccess`, gắn vào EC2 instance → không cần lưu access key trực tiếp trong code.

Endpoint upload ảnh (`POST /api/products/{id}/image`) nhận `MultipartFile`, upload lên S3 bucket, cập nhật `image_url` trong RDS, trả về URL công khai:

```text
https://simple-ecommerce-fe-yourname.s3.ap-southeast-1.amazonaws.com/images/<filename>
```

> **Screenshot:** ![S3 image upload](/images/evidence/week-07/02-s3-image-upload.png)
>
> **Screenshot:** ![S3 image upload](/images/evidence/week-07/03-s3-image-upload.png)
>
> **Screenshot:** ![S3 image upload](/images/evidence/week-07/04-s3-image-upload.png)

#### Bài tập 4: Build & Deploy lên EC2

```bash
# Build JAR trên máy local
./mvnw clean package -DskipTests

# Copy JAR lên EC2
scp -i "aws-learning-key.pem" \
    target/ecommerce-0.0.1-SNAPSHOT.jar \
    ubuntu@<EC2-PUBLIC-IP>:~/

# SSH vào EC2
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Cài Java 17 trên EC2
sudo apt update
sudo apt install openjdk-17-jre -y
java -version

# Thiết lập biến môi trường và chạy ứng dụng
export DB_PASSWORD=<your-rds-password>
java -jar ecommerce-0.0.1-SNAPSHOT.jar
```

Mở Security Group của EC2: thêm inbound rule TCP port `8080` → `0.0.0.0/0` để Postman truy cập được.

Test API từ Postman:

```text
GET http://<EC2-PUBLIC-IP>:8080/api/products
```

> **Screenshot:** ![API running on EC2](/images/evidence/week-07/02-api-running-ec2.png)
>
> **Screenshot:** ![API test from Postman via EC2 IP](/images/evidence/week-07/03-api-postman-ec2.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| `Communications link failure` khi connect RDS | EC2 và RDS phải cùng VPC; kiểm tra Security Group `db-server-sg` có cho phép port 3306 từ `web-server-sg` |
| `Access Denied` khi upload S3 từ EC2 | Gắn IAM Role `ec2-s3-role` vào EC2 instance thay vì dùng access key hardcode |
| Port 8080 không access được từ ngoài | Thêm inbound rule TCP 8080 vào Security Group của EC2 |
| `java: command not found` trên EC2 | Cài Java trước: `sudo apt install openjdk-17-jre -y` |
| Ứng dụng dừng khi đóng terminal SSH | Chạy nền với `nohup java -jar ecommerce-0.0.1-SNAPSHOT.jar &` |

### Kế hoạch tuần 8

- Dockerize Spring Boot application (viết Dockerfile).
- Build Docker image và push lên Amazon ECR.
- Chạy container trên EC2 thay vì JAR trực tiếp.
- Tìm hiểu Docker Compose để chạy app + MySQL cùng nhau ở local.
