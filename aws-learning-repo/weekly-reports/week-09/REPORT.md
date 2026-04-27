# 📅 Báo cáo Tuần 9 — Docker + Containerization

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (22/06/2026 – 28/06/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Viết Dockerfile cho Spring Boot backend
- [ ] Viết Dockerfile cho React frontend (Nginx)
- [ ] Cấu hình docker-compose.yml cho local dev
- [ ] Push images lên Docker Hub
- [ ] Chạy containers trên EC2

---

## 🔧 Bài tập thực hành

### Bước 1: Dockerfile cho Backend

```dockerfile
# Backend Dockerfile
FROM openjdk:17-jre-slim
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

### Bước 2: Dockerfile cho Frontend

```dockerfile
# Frontend Dockerfile
FROM node:18-alpine AS build
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

### Bước 3: Docker Compose

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

```bash
docker-compose up -d
docker-compose ps
docker-compose logs -f backend
```

### Bước 4: Push lên Docker Hub

```bash
docker build -t yourusername/ecommerce-backend:latest ./backend
docker push yourusername/ecommerce-backend:latest
```

> 📸 Screenshot: `01-docker-hub-images.png`
> 📸 Screenshot: `02-containers-running.png`

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
