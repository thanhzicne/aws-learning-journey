---
title: "Week 11 Worklog"
date: 2026-05-14
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

## Week 11 Objectives

- Review and optimize AWS costs using Cost Explorer.
- Perform a security audit on IAM, Security Groups, and S3.
- Draw an Architecture Diagram for the full system.
- Write a professional README and Deployment Guide for the project repository.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Review AWS costs in Cost Explorer: analyze per-service spending, identify expensive areas, plan optimizations | 29/06/2026 | 29/06/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Tue | IAM Security Audit: check root user usage, MFA, access key rotation, and Least Privilege Principle | 30/06/2026 | 30/06/2026 | [Security Compliance with AWS Security Hub](https://000018.awsstudygroup.com) |
| Wed | **Practice Security:** Audit Security Groups (SSH, RDS, open ports). Audit S3 (public access, versioning, lifecycle rules) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| Thu | Draw the Architecture Diagram in draw.io covering all components: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Fri | Write a professional README and Deployment Guide for the project repository. Review and write worklog report | 03/07/2026 | 03/07/2026 | |

### Week 11 Results

Key concepts learned in AWS Optimization and Documentation:

- **AWS Cost Explorer:** A visualization tool for AWS spending by service, region, tag, and time period. Supports identifying spending trends and forecasting next-month costs.
- **Savings Plans / Reserved Instances:** A commitment to use resources at a fixed hourly rate for 1–3 years in exchange for discounts of up to 72% compared to On-Demand pricing.
- **Spot Instance:** EC2 spare capacity purchased at up to 90% off On-Demand pricing, but can be reclaimed by AWS at any time — best suited for non-production workloads.
- **Least Privilege Principle:** An IAM security principle — each user or role is granted only the permissions it actually needs, nothing more. Limits the blast radius if credentials are compromised.
- **MFA (Multi-Factor Authentication):** Protects accounts with two layers of verification: a password plus a physical device or OTP app. Mandatory for the root account and high-privilege IAM users.
- **Security Group:** A virtual firewall at the instance level that controls inbound and outbound traffic by IP and port. Works as a whitelist — only explicitly declared traffic is allowed.
- **S3 Block Public Access:** An account- or bucket-level safeguard that prevents accidental public exposure of objects through ACLs or Bucket Policies.
- **Architecture Diagram:** A visual document showing the full system — which AWS services are used, how they connect, and how data flows. Essential for handovers and onboarding new team members.

```text
System architecture overview after 11 weeks:

  Internet
     ↓
  GitHub Actions (CI/CD)
     ↓ SSH deploy
  ┌──────────────── VPC (10.0.0.0/16) ──────────────────┐
  │                                                      │
  │  Public Subnet              Private Subnet           │
  │  ┌──────────────┐          ┌──────────────────┐      │
  │  │  EC2 (8080)  │─────────►│  RDS MySQL       │      │
  │  │  Spring Boot │          │  (3306, private) │      │
  │  └──────────────┘          └──────────────────┘      │
  └──────────────────────────────────────────────────────┘
       ↑ image pull               ↑ object storage
  Docker Hub                   S3 (product images)
                               S3 (frontend static)
                               CloudWatch (monitoring)
```

#### Exercise 1: Cost Optimization Review with Cost Explorer

**AWS cost optimization strategies:**

| Service | Problem | Optimization |
| :--- | :--- | :--- |
| **EC2** | On-Demand is expensive when running 24/7 | Use Spot Instances for dev/test environments |
| **RDS** | Running even when not in use (weekends, nights) | Stop manually or use RDS Scheduler outside working hours |
| **NAT Gateway** | Charged per hour + per GB of data ($0.045/GB) | Replace with a VPC Endpoint if traffic only targets S3 or DynamoDB |
| **S3** | Old objects accumulate storage costs | Configure Lifecycle Rules: move to S3-IA after 30 days, delete after 90 days |

Reviewing per-service costs in Cost Explorer:

```text
AWS Console → Cost Explorer → Reports → Daily Costs by Service
  ├── EC2:          $X.XX/day
  ├── RDS:          $X.XX/day
  ├── NAT Gateway:  $X.XX/day
  └── S3:           $X.XX/day
```

> **Screenshot:** ![Cost Explorer dashboard](/images/evidence/week-11/01-cost-explorer.png)

#### Exercise 2: Security Audit — IAM

**IAM Security Checklist and rationale:**

| Item | Why It Matters |
| :--- | :--- |
| Root user not used for daily tasks | Root has unrestricted access and cannot be limited by IAM Policies — if compromised, the entire account is lost |
| MFA enabled for root and admin users | Even if a password is leaked, an attacker still needs the physical device to log in |
| Access keys rotated every 90 days | Limits the window an attacker can use a leaked key before it is discovered |
| No credentials hardcoded in code | Code is often pushed to GitHub — public credentials mean the account is compromised within minutes |
| Least Privilege Principle applied | Dev users don't need IAM or Billing permissions — over-provisioning is an unnecessary risk |

```text
Quick check in the AWS Console:
  IAM → Security recommendations
    ✅ / ❌ Root MFA
    ✅ / ❌ No root access keys
    ✅ / ❌ Users have MFA
    ✅ / ❌ Access key age < 90 days
```

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

#### Exercise 3: Security Audit — Security Groups and S3

**Security Groups — minimizing the attack surface:**

- **SSH (port 22):** Open only to the specific IP of the dev machine, never to `0.0.0.0/0` — leaving it wide open invites constant bot brute-force attempts.
- **RDS (port 3306):** Allow inbound only from the EC2 Security Group; never assign a public IP to RDS.
- **Application (port 8080):** Open only when necessary, or place behind a Load Balancer — exposing the application port directly to the internet is an anti-pattern.

**S3 Security Checklist:**

```text
S3 → Bucket → Permissions:
   Block all public access: ON
   Bucket Policy: no s3:GetObject from "*" except the frontend bucket
   Versioning: Enabled (for production buckets)
   Lifecycle Rule: Transition to S3-IA after 30 days
   Server-side Encryption: SSE-S3 (AES-256) or SSE-KMS
```

> **Screenshot:** ![Security Group audit](/images/evidence/week-11/03-security-group-audit.png)
>
> **Screenshot:** ![S3 security settings](/images/evidence/week-11/04-s3-security.png)

#### Exercise 4: Architecture Diagram

**Why an Architecture Diagram matters:**

An Architecture Diagram is not just a pretty document — it is a thinking tool that surfaces weaknesses in a design (single points of failure, bottlenecks, security gaps) before writing a single line of code. When onboarding a new team member or presenting to stakeholders, a diagram replaces dozens of pages of text.

**Tool:** [draw.io](https://draw.io) — free, includes the AWS icon library, and exports to PNG/SVG/PDF.

```text
┌──────────────────────────────────────────────────┐
│                   AWS Cloud                      │
│                                                  │
│  ┌─────────────────────────────────────────┐     │
│  │              VPC (10.0.0.0/16)          │     │
│  │                                         │     │
│  │  ┌─────────────┐   ┌─────────────────┐  │     │
│  │  │Public Subnet│   │ Private Subnet  │  │     │
│  │  │             │   │                 │  │     │
│  │  │  ┌───────┐  │   │  ┌──────────┐   │  │     │
│  │  │  │  EC2  │──┼───┼──►   RDS    │   │  │     │
│  │  │  │Spring │  │   │  │  MySQL   │   │  │     │
│  │  │  │ Boot  │  │   │  └──────────┘   │  │     │
│  │  │  └───────┘  │   │                 │  │     │
│  │  └─────────────┘   └─────────────────┘  │     │
│  └─────────────────────────────────────────┘     │
│                                                  │
│  ┌─────────┐  ┌───────────┐  ┌────────────────┐  │
│  │   S3    │  │CloudWatch │  │      IAM       │  │
│  │(Static) │  │ Monitoring│  │(Users/Policies)│  │
│  └─────────┘  └───────────┘  └────────────────┘  │
└──────────────────────────────────────────────────┘
          ↑ CI/CD: GitHub Actions
```

> **Screenshot:** ![Architecture diagram](/images/evidence/week-11/05-architecture-diagram.png)

#### Exercise 5: Write a Professional README

**Standard README structure for an AWS project:**

A good README answers three questions for a first-time reader — *What is this? What does it do? How do I run it?* — within the first 30 seconds.

| Section | Content |
| :--- | :--- |
| **Project Overview** | Brief description (2–3 sentences), demo screenshot or GIF |
| **Architecture Diagram** | Embed the diagram created in Exercise 4 |
| **Tech Stack** | Short list: Java 17, Spring Boot, React, MySQL, Docker, AWS (EC2, RDS, S3) |
| **Prerequisites** | Java 17, Docker, AWS CLI, Node 18 |
| **Setup & Installation** | Step-by-step: clone → configure env → build → run locally |
| **Environment Variables** | Table: variable name, description, sample value |
| **API Documentation** | Endpoint table: Method, Path, Description, sample Request/Response |
| **Deployment Guide** | Steps to deploy on AWS: EC2, RDS, S3, Docker Hub, GitHub Actions |
| **Lessons Learned** | 3–5 takeaways from 11 weeks — the most valuable section for reviewers |

> **Screenshot:** ![README preview](/images/evidence/week-11/06-readme-preview.png)

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| NAT Gateway accounted for the majority of costs | Moved S3 traffic to a VPC Gateway Endpoint (free) so it bypasses the NAT Gateway |
| Cost Explorer not showing detail by tag | Enabled Cost Allocation Tags in Billing settings; data appears after ~24 hours |
| RDS still billed after being "stopped" for 7 days | AWS automatically restarts RDS after 7 days of being stopped — take a snapshot and delete the instance for long-term cost savings |
| README too long — readers didn't scroll through it | Added a Table of Contents with anchor links at the top of the file |

## Week 12 Plan

- Wrap up all 12 weeks: review the full architecture and accumulated knowledge.
- Prepare the final demo presentation.
- Clean up all AWS resources to prevent ongoing charges after the program ends.
- Plan the next learning path: AWS Solutions Architect Associate certification.
