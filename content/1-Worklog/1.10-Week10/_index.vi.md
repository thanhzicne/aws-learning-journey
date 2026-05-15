---
title: "Worklog Tuần 10"
date: 2026-05-14
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

## Mục tiêu tuần 10

- Thiết lập GitHub Actions workflow cho CI/CD pipeline.
- Tự động build Docker image và push lên Docker Hub khi có code push.
- Tự động deploy lên EC2 qua SSH.
- Kiểm thử toàn bộ pipeline end-to-end.

### Các công việc cần triển khai trong tuần này

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | Tìm hiểu CI/CD: khái niệm, lợi ích, so sánh CI vs CD. Tổng quan GitHub Actions: workflow, job, step, runner | 22/06/2026 | 22/06/2026 | [Deploying CI/CD with ECS Container](https://000017.awsstudygroup.com) |
| 3 | Viết GitHub Actions workflow: build JAR (Maven), build & push Docker image lên Docker Hub | 23/06/2026 | 23/06/2026 | [Deploying CI/CD with ECS Container – CI/CD with GitHub Actions](https://000017.awsstudygroup.com/4-cicd-github/) |
| 4 | **Thực hành CI/CD:** Thêm bước SSH deploy lên EC2. Cấu hình GitHub Secrets cho toàn bộ pipeline | 24/06/2026 | 24/06/2026 | [Deploying CI/CD with ECS Container – CI/CD with GitHub Actions](https://000017.awsstudygroup.com/4-cicd-github/2-new-project-push-code/) |
| 5 | Kiểm thử pipeline end-to-end: push code → trigger workflow → container mới chạy trên EC2 | 25/06/2026 | 25/06/2026 | [Deploying CI/CD with ECS Container – Check Results](https://000017.awsstudygroup.com/4-cicd-github/4-result/) |
| 6 | Ôn tập, xem thêm AWS CodePipeline. Viết báo cáo worklog. Lên kế hoạch tuần 11 | 26/06/2026 | 26/06/2026 | [Deploy applications to EC2 with AWS CodePipeline](https://000023.awsstudygroup.com) |

### Kết quả đạt được tuần 10

Nắm vững các khái niệm nền tảng của CI/CD và GitHub Actions:

- **CI (Continuous Integration):** Thực hành tự động hóa việc build và test code mỗi khi có thay đổi được push lên repository. Mục tiêu là phát hiện lỗi sớm, tránh tích lũy conflict.
- **CD (Continuous Deployment):** Tiếp nối CI, tự động đẩy artifact (Docker image) lên registry và deploy lên môi trường production sau khi CI pass.
- **GitHub Actions:** Nền tảng CI/CD tích hợp sẵn trong GitHub. Workflow được định nghĩa bằng file YAML trong thư mục `.github/workflows/`.
- **Workflow:** Một tiến trình tự động hóa, được kích hoạt bởi event (push, pull request…). Mỗi workflow gồm nhiều **job**.
- **Job:** Tập hợp các **step** chạy tuần tự trên cùng một runner. Các job mặc định chạy song song với nhau.
- **Step:** Đơn vị nhỏ nhất trong workflow — có thể là một lệnh shell (`run`) hoặc một **Action** có sẵn (`uses`).
- **Runner:** Máy chủ thực thi job. GitHub cung cấp runner miễn phí (`ubuntu-latest`, `windows-latest`, `macos-latest`).
- **GitHub Secrets:** Kho lưu trữ thông tin nhạy cảm (password, API key, SSH key) được mã hóa. Workflow truy cập qua cú pháp `${{ secrets.TEN_SECRET }}`, không bao giờ lộ trong log.
- **SSH Deploy:** Kỹ thuật dùng SSH để kết nối vào EC2 từ runner và chạy lệnh `docker pull` + `docker run` để cập nhật container.

```text
CI/CD Pipeline tuần 10:

  Developer push code lên branch main
          ↓
  GitHub Actions triggered (on: push)
          ↓
  Job: build-and-deploy (ubuntu-latest runner)
    ├── Checkout code
    ├── Set up JDK 17
    ├── Build JAR (Maven)          ← CI
    ├── Login Docker Hub
    ├── Build & Push Docker image  ← CI
    └── SSH vào EC2                ← CD
          ├── docker pull image mới
          ├── docker stop/rm container cũ
          └── docker run container mới
```

#### Bài tập 1: Tổng quan GitHub Actions Workflow

**Cấu trúc file workflow và ý nghĩa từng phần:**

| Thành phần | Ý nghĩa |
| :--- | :--- |
| `on: push: branches: [main]` | Trigger workflow khi có push lên branch `main` |
| `runs-on: ubuntu-latest` | Runner là máy Ubuntu do GitHub cung cấp miễn phí |
| `actions/checkout@v3` | Action clone source code của repo vào runner |
| `actions/setup-java@v3` | Action cài JDK 17 (Temurin distribution) lên runner |
| `docker/login-action@v2` | Action đăng nhập Docker Hub bằng credentials từ Secrets |
| `appleboy/ssh-action@master` | Action SSH vào EC2 và chạy script deploy |

File đặt tại: `.github/workflows/deploy.yml`

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

> **Screenshot:** ![Workflow file created](/images/evidence/week-10/01-workflow-file.png)

#### Bài tập 2: Cấu hình GitHub Secrets

**Tại sao phải dùng Secrets thay vì hardcode:**

Nếu viết trực tiếp password hay SSH key vào file YAML, toàn bộ thông tin nhạy cảm sẽ bị lộ công khai trên GitHub. GitHub Secrets mã hóa giá trị và chỉ inject vào môi trường runner khi workflow chạy — không bao giờ hiện trong log hay diff.

Cách thêm Secret: **Repository → Settings → Secrets and variables → Actions → New repository secret**

| Secret | Giá trị |
| :--- | :--- |
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token (tạo tại Account Settings → Security) |
| `EC2_HOST` | EC2 Public IP address |
| `EC2_SSH_KEY` | Nội dung file `.pem` (private key), copy toàn bộ kể cả header `-----BEGIN RSA PRIVATE KEY-----` |
| `DB_PASSWORD` | Mật khẩu RDS database |

> **Screenshot:** ![GitHub Secrets configured](/images/evidence/week-10/02-github-secrets.png)

#### Bài tập 3: Kiểm thử Pipeline End-to-End

**Luồng kiểm thử:**

Push một thay đổi nhỏ lên branch `main` và theo dõi toàn bộ pipeline:

```bash
# Thay đổi code và push
git add .
git commit -m "feat: update product list endpoint"
git push origin main
```

Quan sát từng bước trên tab **Actions** của GitHub repository:

```text
 Checkout code           ~5s
 Set up JDK 17           ~20s
 Build with Maven        ~60s
 Login to Docker Hub     ~5s
 Build & Push image      ~45s
 Deploy to EC2           ~15s
─────────────────────────────
Tổng thời gian pipeline: ~2.5 phút
```

> **Screenshot:** ![GitHub Actions success](/images/evidence/week-10/03-github-actions-success.png)
>
> **Screenshot:** ![Pipeline green](/images/evidence/week-10/04-pipeline-green.png)

#### Bài tập 4: Tìm hiểu thêm AWS CodePipeline

**So sánh GitHub Actions và AWS CodePipeline:**

| Tiêu chí | GitHub Actions | AWS CodePipeline |
| :--- | :--- | :--- |
| Nơi lưu trữ | GitHub repository | AWS (CodeCommit / GitHub / S3) |
| Chi phí | Miễn phí (2000 phút/tháng với tài khoản free) | Trả theo pipeline ($1/pipeline/tháng) |
| Tích hợp AWS | Cần cấu hình credentials thủ công | Native, dùng IAM Role trực tiếp |
| Độ phức tạp | Đơn giản, YAML trực tiếp trong repo | Nhiều service liên kết: CodeBuild, CodeDeploy |
| Phù hợp | Project cá nhân, startup, open source | Enterprise, tích hợp sâu hệ sinh thái AWS |

> **Screenshot:** ![CodePipeline overview](/images/evidence/week-10/05-codepipeline-overview.png)

#### Khó khăn gặp phải

| Vấn đề | Cách giải quyết |
| :--- | :--- |
| `docker stop backend` lỗi khi container chưa tồn tại | Thêm `\|\| true` vào cuối lệnh để bỏ qua lỗi nếu container không tồn tại |
| SSH Action thất bại: `Permission denied` | Đảm bảo copy toàn bộ nội dung file `.pem` vào Secret `EC2_SSH_KEY`, kể cả dòng header/footer |
| Maven build chậm do không cache dependencies | Thêm `actions/cache@v3` để cache thư mục `~/.m2/repository` giữa các lần chạy |
| Workflow trigger khi push lên cả branch khác | Chỉ định rõ `branches: [ main ]` trong phần `on: push` |

## Kế hoạch tuần 11

- Tìm hiểu Amazon CloudFront: distribution, origin, cache behavior, TTL.
- Gắn CloudFront vào S3 frontend và EC2 backend (API).
- Cấu hình Custom Domain với Route 53 và SSL certificate với ACM.
- So sánh hiệu năng trước và sau khi dùng CloudFront (latency, cache hit rate).
