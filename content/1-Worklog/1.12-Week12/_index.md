---
title: "Worklog Week 12"
date: 2026-05-14
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

## Week 12 Objectives

- Learn CloudFront and Route 53 — finalize the architecture with CDN and a custom domain.
- Perform final end-to-end system testing.
- Complete all documentation: README, Deployment Guide, Architecture Diagram.
- Record the demo video and submit the project to the mentor.
- Clean up AWS resources and finalize the internship report.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Learn CloudFront and Route 53 — finalize the architecture with CDN and a custom domain, enable HTTPS with ACM | 06/07/2026 | 06/07/2026 | [Content Delivery with Amazon CloudFront](https://000094.awsstudygroup.com), [Hybrid DNS Management with Amazon Route 53](https://000010.awsstudygroup.com), [Custom Domains and SSL for Serverless Applications](https://000082.awsstudygroup.com) |
| Tue | Final end-to-end system testing: product CRUD, S3 image upload, CI/CD pipeline, CloudWatch alerts | 07/07/2026 | 07/07/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| Wed | Complete README, Deployment Guide, Architecture Diagram (updated with CloudFront & Route 53). Record demo video (3–5 min): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
| Thu | Clean up unnecessary AWS resources. Final cost review with Cost Explorer | 09/07/2026 | 09/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Fri | Submit project: GitHub repo, live app link. Write Week 12 worklog and finalize internship report | 10/07/2026 | 10/07/2026 | |

### Week 12 Outcomes

Summary of all knowledge accumulated over 12 weeks of AWS study:

- **Cloud Infrastructure:** Solid understanding of the AWS global model (Region, AZ, Edge Location), VPC design with public/private subnets, Security Group configuration following Least Privilege, IAM user/group/role/policy management, and Billing.
- **Storage & Database:** Used S3 for object storage and static hosting, RDS MySQL in a private subnet, understood S3 storage classes and Lifecycle Rule strategies.
- **Compute & Networking:** Deployed applications on EC2, configured VPCs, understood traffic flow between public and private subnets via NAT Gateway, and used AWS CLI to interact with services.
- **Application Development:** Built a REST API with Spring Boot, a React SPA with Vite and Axios, and connected Frontend → Backend → RDS → S3 into a complete system.
- **Containerization:** Wrote Dockerfiles (single-stage and multi-stage), configured Docker Compose for local development, pushed images to Docker Hub, and ran containers on EC2.
- **CI/CD:** Set up a GitHub Actions workflow for automation: build JAR → build Docker image → push to Docker Hub → SSH deploy to EC2. Understood the difference between GitHub Actions and AWS CodePipeline.
- **Monitoring & Security:** Configured CloudWatch metrics and SNS alerts, performed security audits for IAM/Security Groups/S3, and optimized costs with Cost Explorer.
- **CDN & DNS:** Deployed CloudFront with 400+ global edge servers, configured Route 53 to point a custom domain, and enabled free HTTPS with ACM.
- **Documentation:** Wrote a professional README, drew an Architecture Diagram with draw.io, and produced a Deployment Guide and Lessons Learned section.

---

#### Exercise 1: CloudFront & Route 53 — Finalizing the Architecture

##### Why CloudFront & Route 53?

After 11 weeks, the system still had 3 unresolved issues:

| Problem | Symptom | Solution |
| :--- | :--- | :--- |
| Ugly, hard-to-remember URL | `http://15.135.21.123:8080/api/products` | Route 53 + real domain |
| No HTTPS | Browser warns "Not Secure" | CloudFront + ACM certificate |
| Slow loading for distant users | Users in Vietnam connecting directly to Sydney | CloudFront CDN caches at the nearest edge server |

##### What is CloudFront?

CloudFront is AWS's CDN (Content Delivery Network) — with 400+ edge servers worldwide. Instead of users connecting directly to S3/EC2 in Sydney, CloudFront serves content from the nearest edge location.

CloudFront has 2 types of origins in this project:

| Origin | Path | Used For |
| :--- | :--- | :--- |
| S3 frontend bucket | `/*` | Serves the React app (HTML/CSS/JS) |
| EC2 IP:8080 | `/api/*` | Proxies API calls, adds HTTPS |

##### What is Route 53?

Route 53 is AWS's DNS service — it translates a domain (`myapp.com`) into the CloudFront address.

**Without Route 53:** <https://d1234abc.cloudfront.net>   ← default URL, ugly

**With Route 53:** <https://myapp.com> → Route 53 → CloudFront → S3 / EC2

##### What is ACM (AWS Certificate Manager)?

ACM issues **free** SSL certificates to enable HTTPS. CloudFront requires the certificate to be created in **region us-east-1** (N. Virginia), not ap-southeast-2.

HTTP  → unencrypted → data can be read in transit
HTTPS → TLS encrypted → secure, browser shows no warnings

##### Step 1: Create an SSL Certificate in ACM

> Must be created in region **us-east-1 (N. Virginia)** — this is the most common mistake when using CloudFront.

- Go to **ACM Console** (switch region to us-east-1) → **Request certificate** → **Request a public certificate**
- Domain name: `myapp.com` and `*.myapp.com` (wildcard for future subdomains)
- Validation method: **DNS validation**
- Click **Request** → copy the generated CNAME record → add it to Route 53
- Wait for status to change to **Issued** (usually 1–5 minutes)

##### Step 2: Create a CloudFront Distribution

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
| Cache policy | **CachingDisabled** — API responses must never be cached; always forward to EC2 |
| Allowed HTTP methods | GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE |

*Default behavior (`/*`):*

| Parameter | Value |
| :--- | :--- |
| Path pattern | `/*` (default) |
| Origin | S3 |
| Cache policy | **CachingOptimized** — cache HTML/CSS/JS at the edge |

*General settings:*

- Alternate domain name: `myapp.com`
- SSL Certificate: select the certificate just created in ACM (us-east-1)
- Custom error response: HTTP 403 → `/index.html` → HTTP 200 *(so React Router works correctly on page refresh)*

##### Step 3: Create a Route 53 Hosted Zone

- **Route 53 Console** → **Hosted zones** → **Create hosted zone**
- Domain name: `myapp.com` → **Create**
- Copy the 4 NS (Name Server) records → update them at your domain registrar (if purchased elsewhere, e.g. Namecheap, GoDaddy)

##### Step 4: Create an A Record Pointing to CloudFront

Inside the `myapp.com` hosted zone → **Create record**:

| Parameter | Value |
| :--- | :--- |
| Record name | (leave blank — root domain) |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |
| Distribution | select the distribution just created |

##### Step 5: Update the React Frontend and Deploy

Now that a domain exists, update `API_URL` in React:

```javascript
// services/productService.js — before
const API_URL = 'http://15.135.21.123:8080/api';

// After CloudFront + Route 53
const API_URL = 'https://myapp.com/api';
```

Rebuild and deploy to S3:

```bash
# Build React app
npm run build

# Sync to S3
aws s3 sync dist/ s3://simple-ecommerce-fe-yourname/ --delete

# Invalidate CloudFront cache so users see the new version immediately
aws cloudfront create-invalidation \
  --distribution-id <DISTRIBUTION-ID> \
  --paths "/*"
```

##### Results After Exercise 1

| Before | After |
| :--- | :--- |
| `http://15.135.21.123:8080/api` | `https://myapp.com/api` |
| `http://simple-ecommerce-fe.s3-website.amazonaws.com` | `https://myapp.com` |
| ~200ms load time from Vietnam | ~30ms thanks to Singapore edge server |
| Unencrypted HTTP | HTTPS with free SSL certificate |

> **Screenshot:** ![CloudFront distribution](/images/evidence/week-12/01-cloudfront-distribution.png)
>
> **Screenshot:** ![Route 53 records](/images/evidence/week-12/02-route53-records.png)

---

#### 12-Week Summary

| Week | Topic | Key Outcome |
| :---: | :--- | :--- |
| 1 | IAM + Billing | Created AWS account, configured IAM users/groups, set up Budget alerts |
| 2 | S3 + Static Hosting | Created S3 bucket, uploaded objects, deployed static website |
| 3 | EC2 + Linux | Launched EC2, SSH, installed Java/MySQL, managed Security Groups |
| 4 | VPC + Networking | Designed VPC, public/private subnets, Internet Gateway, NAT Gateway |
| 5 | RDS + MySQL | Launched RDS in private subnet, connected from EC2, configured backups |
| 6 | CloudWatch + CLI | Configured metrics, alarms, SNS, became proficient with AWS CLI |
| 7 | Spring Boot Backend | Built complete REST API with CRUD and S3 upload |
| 8 | React Frontend | Vite project, Axios, React Router, deployed to S3 |
| 9 | Docker | Dockerfile, multi-stage build, Docker Compose, Docker Hub |
| 10 | GitHub Actions CI/CD | Automated workflow: build → push → SSH deploy to EC2 |
| 11 | Optimization + Docs | Cost Explorer, Security Audit, Architecture Diagram, README |
| 12 | CloudFront + Route 53 + Final Submission | CDN, HTTPS, custom domain, testing, demo video, project submission |

**Achievements after 12 weeks of AWS training:**

- Understand and practice AWS cloud services.
- Complete a small personal project based on what was learned over the past 12 weeks, making it easier to work on a group project.
- Develop a group project to complete the internship.

---

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| ACM certificate stuck in pending state | Ensured the correct CNAME record was added to Route 53 — usually resolves within 1–5 minutes |
| CloudFront returning 403 when accessing S3 | Configured OAC and updated the Bucket Policy to allow CloudFront to read from S3 |
| React Router returning 404 on page refresh | Added custom error response: HTTP 403/404 → redirect to `/index.html` with HTTP 200 |
| API CORS error after switching to the new domain | Updated `@CrossOrigin(origins = "https://myapp.com")` in the Spring Boot controller |
| CloudFront serving stale content after deployment | Ran `aws cloudfront create-invalidation --paths "/*"` after each React deployment |
| App works locally but fails on EC2 | Checked Security Group port 8080 and verified DB_URL environment variable on EC2 |
| Demo video required multiple retakes due to forgetting the script | Wrote a detailed script for each section and did a dry run before the real recording |
| `.env` file accidentally pushed to GitHub repo | Added `.env` to `.gitignore` and used `git rm --cached .env` to remove it from history |
| Forgot to clean up AWS resources after submission | Used AWS Cost Explorer one week later to verify no further charges were incurred |
