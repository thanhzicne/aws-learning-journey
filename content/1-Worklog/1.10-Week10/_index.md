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

    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'

    - name: Build backend with Maven
      run: |
        cd backend
        mvn clean package -DskipTests

    - name: Build frontend
      run: |
        cd frontend
        npm install
        npm run build
      env:
        VITE_API_URL: http://${{ secrets.EC2_HOST }}:8080/api

    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_TOKEN }}

    - name: Build and push backend image
      run: |
        docker build -t ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest ./backend
        docker push ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest

    - name: Build and push frontend image
      run: |
        docker build \
          --build-arg VITE_API_URL=http://${{ secrets.EC2_HOST }}:8080/api \
          -t ${{ secrets.DOCKER_USERNAME }}/ecommerce-frontend:latest \
          ./frontend
        docker push ${{ secrets.DOCKER_USERNAME }}/ecommerce-frontend:latest

    - name: Deploy to EC2
      uses: appleboy/ssh-action@master
      with:
        host: ${{ secrets.EC2_HOST }}
        username: ubuntu
        key: ${{ secrets.EC2_SSH_KEY }}
        script: |
          docker pull ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest
          docker pull ${{ secrets.DOCKER_USERNAME }}/ecommerce-frontend:latest

          docker stop backend frontend || true
          docker rm backend frontend || true

          docker run -d \
            --name backend \
            -p 8080:8080 \
            -e DB_PASSWORD=${{ secrets.DB_PASSWORD }} \
            --restart unless-stopped \
            ${{ secrets.DOCKER_USERNAME }}/ecommerce-backend:latest

          docker run -d \
            --name frontend \
            -p 3000:80 \
            --restart unless-stopped \
            ${{ secrets.DOCKER_USERNAME }}/ecommerce-frontend:latest

          docker image prune -f
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

```yaml
# Make a change and push
git add .
git commit -m "feat: update product list endpoint"
git push origin main
```

> **Screenshot:** ![GitHub Actions success](/images/evidence/week-10/03-github-actions-success.png)
>
> **Screenshot:** ![Pipeline green](/images/evidence/week-10/04-pipeline-green.png)

#### Exercise 4: Explore AWS CodePipeline

##### 1. Overview of AWS CodePipeline

AWS CodePipeline is a fully managed CI/CD (Continuous Integration / Continuous Deployment) service provided by AWS that automates the process of building, testing, and deploying applications quickly and reliably.

**Pipeline Architecture**
A pipeline is a workflow consisting of multiple stages and actions.
**Pipeline**
Represents the overall workflow that manages the entire CI/CD process from source code to production deployment.
**Stage**
Logical phases in the pipeline such as:

- Source
- Build
- Deploy

Stages are executed sequentially based on the configured order.

**Action**
A specific task within a stage, for example:

- Pull source code
- Build project
- Deploy Docker container

**Artifact Store (Amazon S3)**
Used to store source code and build artifacts for transferring data between stages.

###### 2. Main Components of AWS CodePipeline

| Component | Role |
| :--- | :--- |
| **Source** | Retrieves source code from GitHub, CodeCommit, or S3 and triggers the pipeline when changes occur |
| **Build (AWS CodeBuild)** | Builds the project, runs tests, and creates artifacts (JAR files, Docker images, etc.) |
| **Deploy (AWS CodeDeploy)** | Automatically deploys applications to EC2, ECS, or Lambda |
| **IAM Role** | Manages permissions and access between AWS services |
| **CloudWatch** | Monitors logs, build/deployment status, and pipeline metrics |

---

##### 3. Comparison Between GitHub Actions and AWS CodePipeline

| Criteria | GitHub Actions | AWS CodePipeline |
| :--- | :--- | :--- |
| **Location** | Workflow is stored inside the GitHub repository | Managed through the AWS Console |
| **Security** | Uses GitHub Secrets | Uses AWS IAM Roles |
| **Operation Mechanism** | Event-driven (push, pull request, etc.) | Pipeline orchestration |
| **AWS Integration** | Requires manual credential configuration | Native integration with AWS services |
| **Complexity** | Simple and easy to use | More complex but more powerful |
| **Best For** | Individuals, startups, open-source projects | Enterprises and cloud-native systems |

---

##### 4. Why Use AWS CodePipeline?

- **Automates the entire deployment process:**
  Reduces manual operations and minimizes deployment errors.

- **Provides better control:**
  Supports adding a **Manual Approval** step before deploying to production.

- **Deep integration with the AWS ecosystem:**
  Works seamlessly with IAM, CloudWatch, ECS, EC2, Lambda, and other AWS services.

- **Logging & Auditing:**
  Keeps a complete history of builds and deployments for monitoring and troubleshooting.

- **Scalability:**
  Easily extends pipelines for multiple environments such as Development, Staging, and Production.

**Note:** In practice, AWS CodeBuild commonly uses a `buildspec.yml` file to define build steps. This file is similar to GitHub Actions workflow YAML files but focuses specifically on the build process within AWS.
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
