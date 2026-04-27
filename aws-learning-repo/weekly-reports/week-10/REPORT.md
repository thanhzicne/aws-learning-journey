# 📅 Báo cáo Tuần 10 — GitHub Actions + CI/CD

> **Trạng thái:** ⏳ Chưa bắt đầu  
> **Thời gian học:** — (29/06/2026 – 05/07/2026)

---

## 🎯 Mục tiêu tuần này

- [ ] Thiết lập GitHub Actions workflow
- [ ] Auto build Docker image khi push code
- [ ] Auto push lên Docker Hub
- [ ] Auto deploy lên EC2 (SSH deploy)
- [ ] Test toàn bộ pipeline end-to-end

---

## 🔧 Bài tập thực hành

### GitHub Actions Workflow

File: `.github/workflows/deploy.yml`

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'

    - name: Build with Maven
      run: |
        cd backend
        ./mvnw clean package -DskipTests

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}

    - name: Build & Push Docker image
      run: |
        docker build -t ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest ./backend
        docker push ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest

    - name: Deploy to EC2
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ubuntu
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          docker pull ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest
          docker stop backend || true
          docker rm backend || true
          docker run -d \
            --name backend \
            -p 8080:8080 \
            -e DB_PASSWORD=${{ secrets.DB_PASSWORD }} \
            ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest
          echo "Deploy successful!"
```

### GitHub Secrets cần thiết

| Secret | Giá trị |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token |
| `EC2_HOST` | EC2 Public IP |
| `EC2_SSH_KEY` | Private key (.pem content) |
| `DB_PASSWORD` | RDS password |

> 📸 Screenshot: `01-github-actions-success.png`
> 📸 Screenshot: `02-pipeline-green.png`

---

## 💡 Kiến thức quan trọng đã học

### CI vs CD

```
CI (Continuous Integration):
  Code push → Build → Test → Docker image

CD (Continuous Deployment):  
  Docker image → Push to registry → Deploy to EC2
```

### Pipeline thực tế của project

```
Developer push code
       ↓
GitHub Actions triggered
       ↓
Build JAR (Maven)
       ↓
Build Docker image
       ↓
Push to Docker Hub
       ↓
SSH into EC2
       ↓
Pull new image
       ↓
Restart container
       ↓
App running với code mới ✅
```

---

## ⏱️ Worklog giờ học

| Ngày | Thời gian | Hoạt động |
|---|---|---|
| **Tổng** | **... giờ** | |

---

*Cập nhật: [Ngày] | [Tên học viên]*
