---
title: "Week 10 Worklog"
date: 2026-05-14
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

## Week 10 Objectives

- Set up a GitHub Actions workflow for the CI/CD pipeline.
- Automatically build a Docker image and push it to Docker Hub on every code push.
- Automatically deploy to EC2 via SSH.
- Test the complete pipeline end-to-end.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Learn CI/CD concepts, benefits, and the difference between CI and CD. Overview of GitHub Actions: workflow, job, step, runner | 22/06/2026 | 22/06/2026 | [Deploying CI/CD with ECS Container](https://000017.awsstudygroup.com) |
| Tue | Write a GitHub Actions workflow: build JAR (Maven), build and push Docker image to Docker Hub | 23/06/2026 | 23/06/2026 | [Deploying CI/CD with ECS Container – CI/CD with GitHub Actions](https://000017.awsstudygroup.com/4-cicd-github/) |
| Wed | **Practice CI/CD:** Add an SSH deploy step to EC2. Configure GitHub Secrets for the full pipeline | 24/06/2026 | 24/06/2026 | [Deploying CI/CD with ECS Container – CI/CD with GitHub Actions](https://000017.awsstudygroup.com/4-cicd-github/2-new-project-push-code/) |
| Thu | Test the pipeline end-to-end: push code → trigger workflow → new container running on EC2 | 25/06/2026 | 25/06/2026 | [Deploying CI/CD with ECS Container – Check Results](https://000017.awsstudygroup.com/4-cicd-github/4-result/) |
| Fri | Review, explore AWS CodePipeline, write worklog report, plan Week 11 | 26/06/2026 | 26/06/2026 | [Deploy applications to EC2 with AWS CodePipeline](https://000023.awsstudygroup.com) |

### Week 10 Results

Key concepts learned in CI/CD and GitHub Actions:

- **CI (Continuous Integration):** The practice of automatically building and testing code every time a change is pushed to the repository. The goal is to catch errors early and prevent merge conflicts from accumulating.
- **CD (Continuous Deployment):** Extends CI by automatically pushing the artifact (Docker image) to a registry and deploying it to production once CI passes.
- **GitHub Actions:** A CI/CD platform built directly into GitHub. Workflows are defined as YAML files inside the `.github/workflows/` directory.
- **Workflow:** An automated process triggered by an event (push, pull request…). Each workflow contains one or more **jobs**.
- **Job:** A collection of **steps** that run sequentially on the same runner. By default, jobs run in parallel with each other.
- **Step:** The smallest unit in a workflow — either a shell command (`run`) or a pre-built **Action** (`uses`).
- **Runner:** The server that executes a job. GitHub provides free managed runners (`ubuntu-latest`, `windows-latest`, `macos-latest`).
- **GitHub Secrets:** An encrypted store for sensitive values (passwords, API keys, SSH keys). Workflows access them via `${{ secrets.SECRET_NAME }}` — the values are never exposed in logs.
- **SSH Deploy:** A technique that uses SSH to connect from the runner to EC2 and run `docker pull` + `docker run` to update the container with the new image.

```text
CI/CD Pipeline — Week 10:

  Developer pushes code to branch main
          ↓
  GitHub Actions triggered (on: push)
          ↓
  Job: build-and-deploy (ubuntu-latest runner)
    ├── Checkout code
    ├── Set up JDK 17
    ├── Build JAR (Maven)          ← CI
    ├── Login to Docker Hub
    ├── Build & Push Docker image  ← CI
    └── SSH into EC2               ← CD
          ├── docker pull new image
          ├── docker stop/rm old container
          └── docker run new container
```

#### Exercise 1: GitHub Actions Workflow Overview

**Workflow file structure and the meaning of each section:**

| Component | Meaning |
| :--- | :--- |
| `on: push: branches: [main]` | Triggers the workflow when code is pushed to the `main` branch |
| `runs-on: ubuntu-latest` | The runner is a GitHub-managed Ubuntu machine (free) |
| `actions/checkout@v3` | Clones the repository source code onto the runner |
| `actions/setup-java@v3` | Installs JDK 17 (Temurin distribution) on the runner |
| `docker/login-action@v2` | Logs into Docker Hub using credentials from Secrets |
| `appleboy/ssh-action@master` | SSHs into EC2 and runs the deploy script |

File location: `.github/workflows/deploy.yml`

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

#### Exercise 2: Configure GitHub Secrets

**Why use Secrets instead of hardcoding values:**

If passwords or SSH keys are written directly into the YAML file, all sensitive information will be exposed publicly on GitHub. GitHub Secrets encrypts values and only injects them into the runner environment at runtime — they are never visible in logs or diffs.

How to add a Secret: **Repository → Settings → Secrets and variables → Actions → New repository secret**

| Secret | Value |
| :--- | :--- |
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token (created at Account Settings → Security) |
| `EC2_HOST` | EC2 Public IP address |
| `EC2_SSH_KEY` | Full content of the `.pem` file (private key), including the `-----BEGIN RSA PRIVATE KEY-----` header and footer |
| `DB_PASSWORD` | RDS database password |

> **Screenshot:** ![GitHub Secrets configured](/images/evidence/week-10/02-github-secrets.png)

#### Exercise 3: Test the Pipeline End-to-End

**Testing flow:**

Push a small change to the `main` branch and monitor the full pipeline:

```bash
# Make a change and push
git add .
git commit -m "feat: update product list endpoint"
git push origin main
```

Watch each step in the **Actions** tab of the GitHub repository:

```text
 Checkout code           ~5s
 Set up JDK 17           ~20s
 Build with Maven        ~60s
 Login to Docker Hub     ~5s
 Build & Push image      ~45s
 Deploy to EC2           ~15s
─────────────────────────────
Total pipeline time: ~2.5 minutes
```

> **Screenshot:** ![GitHub Actions success](/images/evidence/week-10/03-github-actions-success.png)
>
> **Screenshot:** ![Pipeline green](/images/evidence/week-10/04-pipeline-green.png)

#### Exercise 4: Explore AWS CodePipeline

**GitHub Actions vs AWS CodePipeline comparison:**

| Criteria | GitHub Actions | AWS CodePipeline |
| :--- | :--- | :--- |
| Source storage | GitHub repository | AWS (CodeCommit / GitHub / S3) |
| Cost | Free (2,000 minutes/month on free tier) | Pay per pipeline ($1/pipeline/month) |
| AWS integration | Requires manual credential configuration | Native, uses IAM Roles directly |
| Complexity | Simple — YAML lives directly in the repo | Multiple linked services: CodeBuild, CodeDeploy |
| Best suited for | Personal projects, startups, open source | Enterprise, deep AWS ecosystem integration |

> **Screenshot:** ![CodePipeline overview](/images/evidence/week-10/05-codepipeline-overview.png)

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| `docker stop backend` fails when the container doesn't exist yet | Added `\|\| true` at the end of the command to suppress the error if no container is found |
| SSH Action fails with `Permission denied` | Ensure the entire `.pem` file content is copied into the `EC2_SSH_KEY` Secret, including the header and footer lines |
| Maven build slow due to no dependency caching | Added `actions/cache@v3` to cache the `~/.m2/repository` directory between runs |
| Workflow triggers on pushes to all branches | Explicitly set `branches: [ main ]` under `on: push` |

## Week 11 Plan

- Learn about Amazon CloudFront: distributions, origins, cache behaviors, and TTL.
- Attach CloudFront to the S3 frontend and the EC2 backend (API).
- Configure a custom domain with Route 53 and an SSL certificate with ACM.
- Compare performance before and after CloudFront (latency, cache hit rate).
