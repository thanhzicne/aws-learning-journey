---
title: "Worklog Tuần 9"
date: 2026-05-14
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

## Mục tiêu tuần 9

- Viết Dockerfile cho Spring Boot backend và React frontend (Nginx).
- Cấu hình `docker-compose.yml` để chạy toàn bộ stack trên local.
- Push Docker images lên Docker Hub.
- Chạy containers trên EC2.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu Docker cơ bản: image, container, Dockerfile, layer caching. Cài Docker trên máy local | 15/06/2026 | 15/06/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| 3 | Viết Dockerfile cho Spring Boot backend. Build và chạy thử container backend local | 16/06/2026 | 16/06/2026 | [Deploy Application on Docker – Deploy on Local](https://000015.awsstudygroup.com/2-deploy-local/) |
| 4 | **Thực hành Docker:** Viết Dockerfile multi-stage cho React frontend (Nginx). Cấu hình `docker-compose.yml` cho cả stack | 17/06/2026 | 17/06/2026 | [Deploy Application on Docker – Docker Compose](https://000015.awsstudygroup.com/7-docker-compose/) |
| 5 | Push images lên Docker Hub. Cấu hình EC2 để pull và chạy containers từ Docker Hub | 18/06/2026 | 18/06/2026 | [Deploy Application on Docker – Push Image](https://000015.awsstudygroup.com/8-push-image/2-use-docker-hub/) |
| 6 | Ôn tập, kiểm thử toàn bộ stack trên EC2. Viết báo cáo worklog. Lên kế hoạch tuần 10 | 19/06/2026 | 19/06/2026 | [Deploy Application on Docker – Configure EC2](https://000015.awsstudygroup.com/5-configure-ec2/) |

### Kết quả đạt được tuần 9

Nắm vững các khái niệm nền tảng của Docker và Containerization:

- **Image:** Template read-only chứa mọi thứ cần thiết để chạy ứng dụng (OS, runtime, code, dependencies). Được xây dựng từ Dockerfile theo từng layer.
- **Container:** Instance đang chạy của một image. Cô lập với host và các container khác, nhưng dùng chung kernel OS.
- **Dockerfile:** File kịch bản định nghĩa cách build image. Mỗi lệnh (`FROM`, `COPY`, `RUN`…) tạo ra một layer mới.
- **Layer Caching:** Docker cache từng layer. Nếu layer không thay đổi, Docker tái sử dụng cache → build nhanh hơn. Vì vậy nên COPY `package.json` trước, `RUN npm install`, rồi mới COPY source code.
- **Multi-stage Build:** Kỹ thuật dùng nhiều `FROM` trong một Dockerfile. Stage đầu build app, stage sau chỉ copy artifact cần thiết → image production nhỏ gọn, không chứa build tool.
- **Docker Compose:** Công cụ định nghĩa và chạy nhiều container cùng lúc qua file `docker-compose.yml`. Tự động tạo network nội bộ để các service gọi nhau qua tên service.
- **Docker Hub:** Registry công khai để lưu trữ và chia sẻ Docker images. Tương tự GitHub nhưng dành cho container images.

```text
Docker Architecture:
  Dockerfile  →  docker build  →  Image  →  docker run  →  Container
                                    ↓
                               Docker Hub
                                    ↓
                             EC2: docker pull → Container
```

#### Bài tập 1: Dockerfile cho Backend (Spring Boot)

**Cấu trúc Dockerfile và ý nghĩa từng lệnh:**

| Lệnh | Ý nghĩa |
| :--- | :--- |
| `FROM eclipse-temurin:17-jre-alpine` | Base image: chỉ dùng JRE (runtime), không cần JDK để giảm kích thước |
| `WORKDIR /app` | Đặt thư mục làm việc mặc định bên trong container |
| `COPY target/*.jar app.jar` | Copy file JAR đã build vào image |
| `EXPOSE 8080` | Khai báo port container lắng nghe (metadata, không tự mở port) |
| `ENTRYPOINT` | Lệnh chạy khi container khởi động, cho phép truyền `JAVA_OPTS` từ ngoài |

```dockerfile
# Backend Dockerfile
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

> **Screenshot:** ![Backend Dockerfile build](/images/evidence/week-09/01-backend-dockerfile-build.png)

#### Bài tập 2: Dockerfile Multi-stage cho Frontend (React + Nginx)

**Tại sao dùng Multi-stage Build:**

- **Stage 1 (build):** Dùng `node:18-alpine` để compile React app. Image Node khá nặng (~300MB) nhưng chỉ cần trong bước build.
- **Stage 2 (serve):** Dùng `nginx:alpine` (~25MB) để serve file tĩnh. Chỉ copy thư mục `dist/` từ stage 1 sang — không mang theo Node, npm hay source code.

Kết quả: image production chỉ ~30MB thay vì ~350MB nếu dùng một stage.

```dockerfile
# Frontend Dockerfile (Multi-stage)
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

**Lưu ý `nginx.conf`:** Cần cấu hình `try_files $uri /index.html` để React Router hoạt động đúng — tránh lỗi 404 khi reload trang.

> **Screenshot:** ![Frontend image build](/images/evidence/week-09/02-frontend-image-build.png)

#### Bài tập 3: Docker Compose cho local dev

**Docker Compose và các khái niệm quan trọng:**

- **`depends_on`:** Kiểm soát thứ tự khởi động service, nhưng không đảm bảo service đã sẵn sàng nhận request (chỉ đảm bảo container đã start).
- **`environment`:** Truyền biến môi trường vào container. Dùng `${DB_PASSWORD}` để đọc từ file `.env` thay vì hardcode mật khẩu.
- **`volumes`:** Mount thư mục hoặc named volume. `mysql_data:/var/lib/mysql` giúp data MySQL tồn tại sau khi container restart.
- **Network nội bộ:** Compose tự tạo network riêng. Các service gọi nhau qua tên service (vd: backend kết nối DB qua hostname `db`).

```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_URL=jdbc:mysql://db:3306/ecommerce
      - DB_PASSWORD=${DB_PASSWORD}
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: ecommerce
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

Các lệnh thường dùng khi làm việc với Compose:

```bash
docker-compose up -d        # Khởi động toàn bộ stack (detached mode)
docker-compose ps           # Kiểm tra trạng thái các container
docker-compose logs -f backend  # Xem log realtime của service backend
docker-compose down         # Dừng và xóa containers (giữ volumes)
docker-compose down -v      # Dừng và xóa cả volumes
```

> **Screenshot:** ![Docker Compose running](/images/evidence/week-09/03-docker-compose-running.png)

#### Bài tập 4: Push Images lên Docker Hub & chạy trên EC2

**Quy trình tag và push image:**

Docker Hub yêu cầu image phải được tag theo format `username/repository:tag` trước khi push:

```bash
# Build và tag image
docker build -t yourusername/ecommerce-backend:latest ./backend
docker build -t yourusername/ecommerce-frontend:latest ./frontend

# Login Docker Hub
docker login

# Push lên Docker Hub
docker push yourusername/ecommerce-backend:latest
docker push yourusername/ecommerce-frontend:latest
```

Trên EC2, pull image từ Docker Hub và chạy:

```bash
# Pull images từ Docker Hub
docker pull yourusername/ecommerce-backend:latest
docker pull yourusername/ecommerce-frontend:latest

# Chạy bằng Docker Compose (EC2 cần cài docker-compose)
docker-compose up -d
```

> **Screenshot:** ![Docker Hub images](/images/evidence/week-09/04-docker-hub-images.png)
>
> **Screenshot:** ![Containers running on EC2](/images/evidence/week-09/05-deploy-web-on-ec2.png)
>
> **Screenshot:** ![Containers running on EC2](/images/evidence/week-09/06-web-running-on-ec2.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| Backend crash ngay khi chạy container một mình | Spring Boot cần kết nối database khi khởi động — phải có RDS running hoặc dùng Docker Compose |
| `Communications link failure` khi kết nối RDS | Security Group RDS chưa mở port 3306 cho IP máy local — thêm inbound rule MySQL/Aurora port 3306 source My IP |
| `docker-compose` not found trên EC2 Ubuntu | Cài bằng lệnh `sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose` |
| `push access denied` khi push lên Docker Hub | Chưa đăng nhập hoặc tag sai username — chạy `docker login` trước, tag đúng format `username/repo:tag` rồi mới push |
| Trang trắng với lỗi `e.map is not a function` trên EC2 | `productService.js` gọi API sai URL — thiếu port 8080, sửa thành `http://13.210.73.163:8080/api` |

## Kế hoạch tuần 10

- Tìm hiểu Amazon ECS (Elastic Container Service): Cluster, Task Definition, Service.
- Push images lên Amazon ECR thay vì Docker Hub.
- Deploy backend và frontend containers lên ECS Fargate.
- Cấu hình Application Load Balancer cho ECS Service.
