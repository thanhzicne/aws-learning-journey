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
- Complete the architecture with CloudFront CDN and Route 53 DNS.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Review AWS costs in Cost Explorer: analyze per-service spending, identify expensive areas, plan optimizations | 29/06/2026 | 29/06/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Tue | IAM Security Audit: check root user usage, MFA, access key rotation, and Least Privilege Principle | 30/06/2026 | 30/06/2026 | [Security Compliance with AWS Security Hub](https://000018.awsstudygroup.com) |
| Wed | Practice Security: Audit Security Groups (SSH, RDS, open ports). Audit S3 (public access, versioning, lifecycle rules) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| Thu | Draw the Architecture Diagram in draw.io covering all components: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Fri | Study CloudFront and Route 53 — complete the architecture with CDN and a custom domain. Write a professional README and Deployment Guide for the project repository. Review and write worklog report | 03/07/2026 | 03/07/2026 | [Content Delivery with Amazon CloudFront](https://000094.awsstudygroup.com), [Hybrid DNS Management with Amazon Route 53](https://000010.awsstudygroup.com), [Custom Domains and SSL for Serverless Applications](https://000082.awsstudygroup.com) |

### Week 11 Results

Key concepts learned in AWS Optimization, Documentation, and complete architecture:

- **AWS Cost Explorer:** A visualization tool for AWS spending by service, region, tag, and time period. Supports identifying spending trends and forecasting next-month costs.
- **Savings Plans / Reserved Instances:** A commitment to use resources at a fixed hourly rate for 1–3 years in exchange for discounts of up to 72% compared to On-Demand pricing.
- **Spot Instance:** EC2 spare capacity purchased at up to 90% off On-Demand pricing, but can be reclaimed by AWS at any time — best suited for non-production workloads.
- **Least Privilege Principle:** An IAM security principle — each user or role is granted only the permissions it actually needs, nothing more. Limits the blast radius if credentials are compromised.
- **MFA (Multi-Factor Authentication):** Protects accounts with two layers of verification: a password plus a physical device or OTP app. Mandatory for the root account and high-privilege IAM users.
- **Security Group:** A virtual firewall at the instance level that controls inbound and outbound traffic by IP and port. Works as a whitelist — only explicitly declared traffic is allowed.
- **S3 Block Public Access:** An account- or bucket-level safeguard that prevents accidental public exposure of objects through ACLs or Bucket Policies.
- **Architecture Diagram:** A visual document showing the full system — which AWS services are used, how they connect, and how data flows. Essential for handovers and onboarding new team members.
- **CloudFront:** AWS's global CDN with 400+ edge servers — reduces latency, adds HTTPS, and caches content close to users.
- **Route 53:** AWS's DNS service — points a real domain to CloudFront instead of using raw IPs or default URLs.
- **ACM (AWS Certificate Manager):** Issues free SSL certificates to enable HTTPS on CloudFront.

```text
Complete architecture after Week 11:

  User
   ↓
  myapp.com
   ↓
  Route 53 (DNS)
   ↓
  CloudFront (HTTPS + CDN)
  ├── /api/*  ──────────────────────────────► EC2:8080 (Spring Boot)
  │                                               ↓
  │                                         RDS MySQL (private subnet)
  └── /*  ──────────────────────────────────► S3 (React frontend)
                                                  ↑
                                          S3 (product images)

  GitHub Actions ──SSH──► EC2 (CI/CD deploy)
  CloudWatch ──────────── System monitoring
```

---

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

---

#### Exercise 2: Security Audit — IAM

**IAM Security Checklist and rationale:**

| Item | Why It Matters |
| :--- | :--- |
| Root user not used for daily tasks | Root has unrestricted access and cannot be limited by IAM Policies — if compromised, the entire account is lost |
| MFA enabled for root and admin users | Even if a password is leaked, an attacker still needs the physical device to log in |
| Access keys rotated every 90 days | Limits the window an attacker can use a leaked key before it is discovered |
| No credentials hardcoded in code | Code is often pushed to GitHub — public credentials mean the account is compromised within minutes |
| Least Privilege Principle applied | Dev users don't need IAM or Billing permissions — over-provisioning is an unnecessary risk |

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

---

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

---

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

---

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

---

#### Exercise 6: CloudFront & Route 53 — Completing the Architecture

##### Why CloudFront & Route 53?

After 11 weeks, the system still has 3 unresolved problems:

| Problem | Symptom | Solution |
| :--- | :--- | :--- |
| Ugly, hard-to-remember URLs | `http://15.135.21.123:8080/api/products` | Route 53 + real domain |
| No HTTPS | Browser shows "Not Secure" warning | CloudFront + ACM certificate |
| Slow load for distant users | Vietnamese users connect directly to Sydney | CloudFront CDN caches at the nearest edge |

##### What is CloudFront?

CloudFront is AWS's CDN (Content Delivery Network) — with 400+ edge servers worldwide. Instead of users connecting directly to S3/EC2 in Sydney, CloudFront serves content from the nearest edge server.

```text
Without CloudFront:
  User (Vietnam) ──────────────────────────► S3/EC2 (Sydney)   ~200ms

With CloudFront:
  User (Vietnam) ──► Edge (Singapore) ──► S3/EC2 (Sydney)      ~30ms
                     └─ cache hit → served instantly, no trip to Sydney
```

Two origins are used in this project:

| Origin | Path | Purpose |
| :--- | :--- | :--- |
| S3 frontend bucket | `/*` | Serve the React app (HTML/CSS/JS) |
| EC2 IP:8080 | `/api/*` | Proxy API calls and add HTTPS |

##### What is Route 53?

Route 53 is AWS's DNS service — it maps a domain name (`myapp.com`) to a CloudFront URL.

```text
Without Route 53:
  https://d1234abc.cloudfront.net   ← default URL, ugly

With Route 53:
  https://myapp.com → Route 53 → CloudFront → S3 / EC2
```

##### What is ACM (AWS Certificate Manager)?

ACM issues **free** SSL certificates to enable HTTPS. CloudFront requires the certificate to be created in **region us-east-1** (N. Virginia) — not ap-southeast-2.

```text
HTTP  → unencrypted → data can be intercepted in transit
HTTPS → TLS encrypted → secure, no browser warning
```

##### Complete Architecture after Exercise 6

```text
  User
   ↓
  myapp.com
   ↓
  Route 53 (DNS — points domain to CloudFront)
   ↓
  CloudFront Distribution (HTTPS + cache)
  ├── /api/*  ──────────────────────────────► EC2:8080 (Spring Boot)
  │                                               ↓
  │                                         RDS MySQL (private subnet)
  └── /*  ──────────────────────────────────► S3 (React frontend)
                                                  ↑
                                          S3 (product images)

  GitHub Actions ──SSH──► EC2 (CI/CD deploy)
  CloudWatch ──────────── System monitoring
```

##### Step-by-Step Guide

###### Step 1: Create an SSL Certificate in ACM

> Must be created in region **us-east-1 (N. Virginia)** — this is the most common mistake when using CloudFront.

- Go to **ACM Console** (switch region to us-east-1) → **Request certificate** → **Request a public certificate**
- Domain names: `myapp.com` and `*.myapp.com` (wildcard for future subdomains)
- Validation method: **DNS validation**
- Click **Request** → copy the CNAME record → add it to Route 53
- Wait for status to change to **Issued** (usually 1–5 minutes)

###### Step 2: Create a CloudFront Distribution

Go to **CloudFront Console** → **Create distribution**:

*Origin 1 — S3 frontend:*

| Parameter | Value |
| :--- | :--- |
| Origin domain | `simple-ecommerce-fe-yourname.s3.ap-southeast-2.amazonaws.com` |
| Origin access | Origin Access Control (OAC) — more secure than a public URL |
| Viewer protocol policy | Redirect HTTP to HTTPS |
| Default root object | `index.html` |

*Origin 2 — EC2 backend:*

| Parameter | Value |
| :--- | :--- |
| Origin domain | `http://<EC2-IP>:8080` |
| Protocol | HTTP only |

*Behavior for API (`/api/*`):*

| Parameter | Value |
| :--- | :--- |
| Path pattern | `/api/*` |
| Origin | EC2 |
| Cache policy | **CachingDisabled** — API responses must never be cached |
| Allowed HTTP methods | GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE |

*Default behavior (`/*`):*

| Parameter | Value |
| :--- | :--- |
| Path pattern | `/*` (default) |
| Origin | S3 |
| Cache policy | **CachingOptimized** — cache HTML/CSS/JS at the edge |

*General settings:*

- Alternate domain name: `myapp.com`
- SSL Certificate: select the certificate created in ACM (us-east-1)
- Custom error response: HTTP 403 → `/index.html` → HTTP 200 *(required for React Router to work on page refresh)*

###### Step 3: Create a Route 53 Hosted Zone

- **Route 53 Console** → **Hosted zones** → **Create hosted zone**
- Domain name: `myapp.com` → **Create**
- Copy the 4 NS (Name Server) records → update them at your domain registrar (e.g. Namecheap, GoDaddy) if the domain was purchased elsewhere

###### Step 4: Create an A Record Pointing to CloudFront

Inside the hosted zone `myapp.com` → **Create record**:

| Parameter | Value |
| :--- | :--- |
| Record name | (leave blank — root domain) |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |
| Distribution | select the distribution just created |

###### Step 5: Update the React Frontend and Redeploy

After the domain is live, update `API_URL` in React:

```javascript
// services/productService.js — before
const API_URL = 'http://15.135.21.123:8080/api';

// After CloudFront + Route 53
const API_URL = 'https://myapp.com/api';
```

Build and deploy to S3:

```bash
# Build the React app
npm run build

# Sync to S3
aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete

# Invalidate CloudFront cache so users see the new version immediately
aws cloudfront create-invalidation \
  --distribution-id <DISTRIBUTION-ID> \
  --paths "/*"
```

##### Results after Exercise 6

| Before | After |
| :--- | :--- |
| `http://15.135.21.123:8080/api` | `https://myapp.com/api` |
| `http://simple-ecommerce-fe.s3-website.amazonaws.com` | `https://myapp.com` |
| ~200ms load time from Vietnam | ~30ms via Singapore edge server |
| Unencrypted HTTP | HTTPS with a free SSL certificate |

> **Screenshot:** ![CloudFront distribution](/images/evidence/week-11/07-cloudfront-distribution.png)
>
> **Screenshot:** ![Route 53 records](/images/evidence/week-11/08-route53-records.png)

---

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| NAT Gateway accounted for the majority of costs | Moved S3 traffic to a VPC Gateway Endpoint (free) so it bypasses the NAT Gateway |
| Cost Explorer not showing detail by tag | Enabled Cost Allocation Tags in Billing settings; data appears after ~24 hours |
| RDS still billed after being "stopped" for 7 days | AWS automatically restarts RDS after 7 days — take a snapshot and delete the instance for long-term savings |
| README too long — readers didn't scroll through it | Added a Table of Contents with anchor links at the top of the file |
| ACM certificate stuck in pending validation | Ensure the correct CNAME record has been added to Route 53 — usually resolves within 1–5 minutes |
| CloudFront returns 403 when accessing S3 | Configure OAC and update the Bucket Policy to allow CloudFront to read the S3 bucket |
| React Router returns 404 on page refresh | Add a custom error response: HTTP 403/404 → redirect to `/index.html` with HTTP 200 |
| CORS error after switching to the new domain | Update `@CrossOrigin(origins = "https://myapp.com")` in the Spring Boot controller |
| CloudFront serves stale content after deploying | Run `aws cloudfront create-invalidation --paths "/*"` after every React deployment |

---

## Week 12 Plan

- Wrap up all 12 weeks: review the full architecture and accumulated knowledge.
- Prepare the final demo presentation.
- Clean up all AWS resources to prevent ongoing charges after the program ends.
- Plan the next learning path: AWS Solutions Architect Associate certification.
