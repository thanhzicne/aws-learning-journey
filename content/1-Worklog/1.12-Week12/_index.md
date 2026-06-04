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
| Wed | Complete Deployment Guide, Architecture Diagram (updated with CloudFront & Route 53). Record demo video (3–5 min): architecture → frontend demo → AWS Console → CI/CD pipeline | 08/07/2026 | 08/07/2026 | [Static Website Hosting with Amazon S3](https://000057.awsstudygroup.com) |
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

#### Exercise : CloudFront & Route 53

##### Why Do We Need CloudFront & Route 53?

After 11 weeks, the system still has 3 unresolved issues:

| Problem | Symptom | Solution |
| :--- | :--- | :--- |
| Ugly, hard-to-remember URL | `http://15.135.21.123:8080/api/products` | Route 53 + real domain |
| No HTTPS | Browser shows "Not Secure" warning | CloudFront + ACM certificate |
| Slow load for distant users | Users in Vietnam connect directly to Sydney | CloudFront CDN caches at nearest edge location |

##### What is CloudFront?

CloudFront is AWS's CDN (Content Delivery Network) — with 400+ edge servers worldwide. Instead of users connecting directly to S3/EC2 in Sydney, CloudFront serves content from the nearest edge location.

CloudFront has 2 types of origins in this project:

| Origin | Path | Used for |
| :--- | :--- | :--- |
| S3 frontend bucket | `/*` | Serving the React app (HTML/CSS/JS) |
| EC2 IP:8080 | `/api/*` | Proxying API calls, adding HTTPS |

##### What is Route 53?

Route 53 is AWS's DNS service — it converts a domain name (`myapp.com`) into a CloudFront address.
**Without Route 53:** `https://d1234abc.cloudfront.net` ← default URL, ugly
**With Route 53:** `https://myapp.com` → Route 53 → CloudFront → S3 / EC2
> **Note:** In this lab, Route 53 is studied at a theoretical level only since we do not own a real domain. The hands-on steps below will use the default CloudFront URL instead.

##### What is ACM (AWS Certificate Manager)?

ACM issues **free** SSL certificates to enable HTTPS. CloudFront requires the certificate to be created in **region us-east-1** (N. Virginia), not ap-southeast-2.
HTTP  → no encryption → data can be read in transit
HTTPS → TLS encryption → secure, browser shows no warning
> **Note:** ACM can only validate a certificate when you own the domain. In this lab, the ACM step is skipped. We use the default HTTPS provided by CloudFront via the `*.cloudfront.net` URL.

---

##### Step 1: Create a CloudFront Distribution

Go to **CloudFront Console** → **Create distribution**
*Origin — S3 frontend:*

| Parameter | Value |
| :--- | :--- |
| Origin domain | `simple-ecommerce-phamducthanh.s3.ap-southeast-2.amazonaws.com` |
| Origin access | **Origin Access Control (OAC)** |
| Viewer protocol policy | Redirect HTTP to HTTPS |
| Default root object | `index.html` |

*Custom error responses (so React Router works on page refresh):*

| HTTP error code | Response page path | HTTP response code |
| :--- | :--- | :--- |
| 403 | `/index.html` | 200 |
| 404 | `/index.html` | 200 |

> **Screenshot:** ![Create a CloudFront Distribution](/images/evidence/week-12/01-Create-CloudFront-Distribution.png)

##### Step 2: Update the S3 Bucket Policy

After creating the distribution, update the Bucket Policy so that **only CloudFront** can read from S3 — blocking direct public access:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::simple-ecommerce-phamducthanh/*",
      "Condition": {
        "ArnLike": {
          "AWS:SourceArn": "arn:aws:cloudfront::551326095934:distribution/E4UZ9OCEJUVRN"
        }
      }
    }
  ]
}
```

> **Screenshot:** ![Update S3 Bucket Policy](/images/evidence/week-12/02-S3-Bucket-Policy.png)

##### Step 3: Update Frontend to Use the CloudFront URL

The frontend should call the API through CloudFront instead of connecting directly to the EC2 instance. Update the `frontend/.env` file:

```env
VITE_API_URL=https://d4k3yvu64phif.cloudfront.net/api
```

For GitHub Actions, update `deploy.yml` by removing port `:8080` and switching to HTTPS:

```yaml
# Before
--build-arg VITE_API_URL=http://${{ secrets.EC2_HOST }}:8080/api

# After
--build-arg VITE_API_URL=https://${{ secrets.EC2_HOST }}/api
```

Also update the `EC2_HOST` secret in GitHub:
**GitHub → Settings → Secrets and variables → Actions**

```text
EC2_HOST = d4k3yvu64phif.cloudfront.net
```

> **Note:** RDS will continue to operate normally. CloudFront sits in front of the EC2 instance and does not affect the internal connection between EC2 and RDS.

##### Step 4: Understanding Route 53 (Theory Only)

> This step is **not practiced hands-on** because we do not own a real domain. It is documented here to understand the full workflow when a real domain is available.

If a real domain were available, the steps would be as follows:
**4.1 Create a Hosted Zone**

Route 53 → Hosted zones → Create hosted zone
→ Domain name: myapp.com
→ Type: Public hosted zone
→ Create
**4.2 Create an A Record Pointing to CloudFront**

| Parameter | Value |
| :--- | :--- |
| Record name | *(leave blank — root domain)* |
| Record type | A |
| Alias | Yes |
| Route traffic to | Alias to CloudFront distribution |

**4.3 Traffic flow with Route 53:**

```bash
User types myapp.com
    ↓
Route 53 (DNS lookup)
    ↓
CloudFront (Edge server in Singapore)
    ↓
S3 Sydney (Origin)
```

**4.4 Route 53 Routing Policy types:**

| Policy | When to use |
| :--- | :--- |
| Simple | Single resource only |
| Weighted | A/B testing, split traffic by percentage |
| Latency | Multiple regions, auto-route to nearest region |
| Failover | Primary + Backup (High Availability) |
| Geolocation | Route by country or geographic region |

##### Step 5: Test the CloudFront URL

Once the distribution status changes to **Enabled**, test it:

```bash
# Test with curl
curl -I https://d4k3yvu64phif.cloudfront.net
 
# Expected result
HTTP/2 200
x-cache: Hit from cloudfront   ← cache is working
```

Or open in browser: `https://d4k3yvu64phif.cloudfront.net`

> **Screenshot:** ![Test CloudFront URL](/images/evidence/week-12/03-Test-CloudFront.png)

---

##### Results After Exercise

| Before | After |
| :--- | :--- |
| `http://simple-ecommerce-phamducthanh.s3-website.amazonaws.com` | `https://d4k3yvu64phif.cloudfront.net` |
| Unencrypted HTTP | **HTTPS** via default CloudFront certificate |
| ~200ms load time from Vietnam | ~30ms load time via Singapore edge server |
| S3 publicly accessible | S3 private — accessible by CloudFront only |

> **Screenshot:** ![CloudFront Distribution Enabled](/images/evidence/week-12/04-CloudFront-Enabled.png)

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
| Accessing the wrong CloudFront domain caused `DNS_PROBE_FINISHED_NXDOMAIN` | Checked the actual `Distribution domain name` in the CloudFront Console and updated it in `frontend/.env`, `.env.example`, and GitHub Actions |
| CloudFront domain was not available immediately after creation | Waited until the distribution status became `Enabled/Deployed`, then tested again using the browser and `curl -I` |
| CloudFront returned `AccessDenied` when opening the main website | Uploaded the React build output from `frontend/dist` to S3 and ensured the bucket contained `index.html` and `assets/` |
| GitHub Actions built the frontend but CloudFront still showed no website | Added an `aws s3 sync frontend/dist s3://simple-ecommerce-phamducthanh` step to deploy the frontend to S3 |
| CloudFront still showed old content after deployment | Added a CloudFront invalidation step using `aws cloudfront create-invalidation --distribution-id E3O2ME4OPGOUZ9 --paths "/*"` |
| Images uploaded to S3 did not display when testing locally | Since the S3 bucket is private and only CloudFront can read it through OAC, added `VITE_ASSET_BASE_URL` and converted S3 image URLs to CloudFront URLs before rendering |
| API requests through CloudFront returned `502` | The backend on EC2 runs on HTTP port `8080`, so the CloudFront origin had to be configured with `Protocol: HTTP only` and `HTTP port: 8080` |
| API worked directly through EC2 but failed through CloudFront | Checked that the `/api/*` behavior pointed to the correct EC2 origin and used `CachingDisabled` with the `AllViewer` origin request policy |
| API actions such as create, update, delete, and upload could fail if only `GET, HEAD` were allowed | Configured the `/api/*` behavior to allow `GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE` |
| Local frontend showed `Network Error` | Checked `VITE_API_URL`, tested the backend directly with `curl http://52.65.5.156:8080/api/products`, then restarted the Vite dev server |
| Updated `.env` but the local frontend still used the old value | Restarted the Vite dev server because Vite only loads `.env` variables when the server starts |
| VS Code showed `Context access might be invalid` for AWS secrets | Treated it as an editor warning and verified that `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` were correctly added to GitHub Actions Secrets |
| Did not know where to get `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` | Created an IAM user for GitHub Actions, generated an access key in the Security credentials tab, and saved the values as GitHub repository secrets |
| Risk of deleting uploaded product images when syncing frontend files to S3 | Avoided using `aws s3 sync ... --delete` because the same bucket also stores uploaded images in the `images/` folder |
| README was outdated after adding CloudFront | Rewrote the README to describe the new architecture: `CloudFront -> S3` for the frontend and `/api/* -> EC2 backend` |
