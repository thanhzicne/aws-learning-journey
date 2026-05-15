---
title: "Week 12 Worklog"
date: 2026-05-14
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

## Week 12 Objectives

- Final end-to-end testing of the entire system.
- Complete all documentation: README, Deployment Guide, Architecture Diagram.
- Record the demo video and submit the project to the mentor.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Final system testing: product CRUD, S3 image upload, CI/CD pipeline, CloudWatch alerts | 06/07/2026 | 06/07/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| Tue | Complete README, Deployment Guide, Architecture Diagram. Review all documentation one final time | 07/07/2026 | 07/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
| Wed | **Practice Final:** Record demo video (3–5 min): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | |
| Thu | Clean up unused AWS resources. Run a final cost check with Cost Explorer | 09/07/2026 | 09/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Fri | Submit project: GitHub repo + demo video + live app link. Write Week 12 worklog and 12-week wrap-up | 10/07/2026 | 10/07/2026 | |

### Week 12 Results

Summary of all knowledge accumulated over 12 weeks of AWS learning:

- **Cloud Infrastructure:** Solid understanding of the AWS global model (Region, AZ, Edge Location), VPC design with public/private subnets, Security Group configuration following the Least Privilege Principle, and IAM user/group/role/policy management with Billing.
- **Storage & Database:** Using S3 for object storage and static hosting, RDS MySQL in a private subnet, understanding S3 storage classes and Lifecycle Rule strategies.
- **Compute & Networking:** Deploying applications on EC2, configuring VPCs, understanding traffic flow between public and private subnets via NAT Gateway, and using AWS CLI to interact with services.
- **Application Development:** Building REST APIs with Spring Boot, React SPAs with Vite and Axios, connecting Frontend → Backend → RDS → S3 into a complete working system.
- **Containerization:** Writing Dockerfiles (single-stage and multi-stage), configuring Docker Compose for local dev, pushing images to Docker Hub, and running containers on EC2.
- **CI/CD:** Setting up a GitHub Actions workflow for full automation: build JAR → build Docker image → push to Docker Hub → SSH deploy to EC2. Understanding the difference between GitHub Actions and AWS CodePipeline.
- **Monitoring & Security:** Configuring CloudWatch metrics and SNS alerts, performing security audits on IAM/Security Groups/S3, and optimizing costs with Cost Explorer.
- **Documentation:** Writing a professional README, drawing an Architecture Diagram in draw.io, and completing a Deployment Guide and Lessons Learned section.

#### Final Checklist — Cloud Infrastructure

Full infrastructure review before submission:

| Item | Description | Status |
| :--- | :--- | :---: |
| VPC with public/private subnets | `10.0.0.0/16`, public subnet for EC2, private subnet for RDS | ✅ |
| EC2 Ubuntu instance | Running Spring Boot backend on port 8080 | ✅ |
| RDS MySQL | Connected from EC2 only, no public access | ✅ |
| S3 product image bucket | Object storage, presigned URL or public read for images | ✅ |
| S3 frontend bucket | Static Website Hosting with React app deployed | ✅ |
| IAM roles & policies | EC2 has an S3-access role; dev-user has PowerUserAccess | ✅ |
| Security Groups | SSH open to specific IP only; RDS accessible from EC2 SG only | ✅ |

> **Screenshot:** ![AWS Console overview](/images/evidence/week-12/01-aws-console-overview.png)

#### Final Checklist — Application

| Item | Description | Status |
| :--- | :--- | :---: |
| Responsive React frontend | Displays product list, image upload, add/edit/delete | ✅ |
| Spring Boot REST API | Full CRUD endpoints with multipart upload support | ✅ |
| End-to-end connection | Frontend (S3) → Backend (EC2) → Database (RDS) → Storage (S3) | ✅ |

> **Screenshot:** ![App final demo](/images/evidence/week-12/02-app-final-demo.png)

#### Final Checklist — DevOps

| Item | Description | Status |
| :--- | :--- | :---: |
| Backend Dockerfile | `openjdk:17-jre-slim`, exposes port 8080 | ✅ |
| Frontend Dockerfile | Multi-stage: `node:18-alpine` build + `nginx:alpine` serve | ✅ |
| docker-compose.yml | Runs full local stack (backend + frontend + MySQL) | ✅ |
| GitHub Actions pipeline | Push code → build → push Docker Hub → auto deploy to EC2 | ✅ |

> **Screenshot:** ![GitHub Actions green](/images/evidence/week-12/03-github-actions-green.png)

#### Final Checklist — Monitoring & Docs

| Item | Description | Status |
| :--- | :--- | :---: |
| CloudWatch monitoring | CPU, Memory, Disk metrics for EC2; Storage metrics for RDS | ✅ |
| SNS alerts | Alerts when CPU > 80% or Free Tier usage is near the limit | ✅ |
| Architecture diagram | Drawn in draw.io, covers VPC/Subnet/EC2/RDS/S3/CI-CD | ✅ |
| Professional README | Table of Contents, Tech Stack, Setup guide, API docs, Lessons Learned | ✅ |
| Demo video | 3–5 minutes, recorded with Loom/OBS | ✅ |

> **Screenshot:** ![Architecture diagram final](/images/evidence/week-12/04-architecture-diagram-final.png)

#### Demo Video — Recording Script

**4-minute 30-second video structure:**

| Timestamp | Content | Key Points to Emphasize |
| :--- | :--- | :--- |
| 0:00 – 0:30 | Introduce yourself and the project goal | Name, program, the problem being solved |
| 0:30 – 1:30 | Show and explain the Architecture Diagram | Data flow from User → React → EC2 → RDS/S3, role of CI/CD |
| 1:30 – 2:30 | Frontend demo: browse products, upload image, add/edit/delete | Run live on the S3 Static Hosting URL |
| 2:30 – 3:30 | Show AWS Console: EC2 running, RDS connected, S3 objects, CloudWatch | Prove it's a real system, not just local |
| 3:30 – 4:00 | Show GitHub Actions: pipeline running or recently passed | Push a small commit and show the pipeline trigger |
| 4:00 – 4:30 | Summarize Lessons Learned and what to study next | Be honest and specific — reviewers remember this part longest |

> **Screenshot:** ![Demo video recording](/images/evidence/week-12/05-demo-video.png)

#### 12-Week Summary

| Week | Topic | Key Outcome |
| :---: | :--- | :--- |
| 1 | IAM + Billing | Created AWS account, configured IAM users/groups, set up Budget alerts |
| 2 | S3 + Static Hosting | Created S3 bucket, uploaded objects, deployed a static website |
| 3 | EC2 + Linux | Launched EC2, SSH access, installed Java/MySQL, managed Security Groups |
| 4 | VPC + Networking | Designed VPC, public/private subnets, Internet Gateway, NAT Gateway |
| 5 | RDS + MySQL | Launched RDS in a private subnet, connected from EC2, configured backups |
| 6 | CloudWatch + CLI | Configured metrics, alarms, SNS notifications, and mastered AWS CLI |
| 7 | Spring Boot Backend | Built a complete REST API with CRUD and S3 image upload |
| 8 | React Frontend | Vite project, Axios, React Router, deployed to S3 Static Hosting |
| 9 | Docker | Dockerfile, multi-stage builds, Docker Compose, Docker Hub |
| 10 | GitHub Actions CI/CD | Automated workflow: build → push → SSH deploy to EC2 |
| 11 | Optimization + Docs | Cost Explorer, Security Audit, Architecture Diagram, README |
| 12 | Final Submission | Testing, demo video, project submitted |

#### Reflection — Looking Back on the Journey

**What I am most proud of:**
> ✏️ *Write your honest thoughts here*

**The biggest challenge I overcame:**
> ✏️ *Record this so you never forget it*

**What I want to learn next:**
> ✏️ *EKS? Lambda? Terraform? AWS Solutions Architect Associate?*

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| App worked locally but failed on EC2 | Checked Security Group port 8080 and verified `DB_URL` environment variable on EC2 |
| Had to re-record the demo video multiple times | Wrote a detailed script for each section and did a full dry run before recording |
| `.env` file accidentally pushed to GitHub | Added `.env` to `.gitignore` and removed it from history with `git rm --cached .env` |
| Forgot to clean up AWS resources after submission | Used Cost Explorer one week later to verify no ongoing charges remained |
