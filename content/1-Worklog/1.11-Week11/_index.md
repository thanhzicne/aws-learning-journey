---
title: "Week 11 Worklog"
date: 2026-05-14
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

## Week 11 Objectives

- Review and optimize AWS costs using Cost Explorer.
- Perform Security Audit for IAM, Security Groups, and S3.
- Draw an Architecture Diagram for the entire system.
- Write a professional README and Deployment Guide for the project repo.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Review AWS costs with Cost Explorer: analyze each service, identify expensive areas, plan optimization | 29/06/2026 | 29/06/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Tue | Security Audit IAM: check root user, MFA, access key rotation, Least Privilege Principle | 30/06/2026 | 30/06/2026 | [Security Compliance with AWS Security Hub](https://000018.awsstudygroup.com) |
| Wed | Security Practice: Audit Security Groups (SSH, RDS, ports). Audit S3 (public access, versioning, lifecycle) | 01/07/2026 | 01/07/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| Thu | Draw Architecture Diagram with draw.io. Include all components: VPC, Subnets, EC2, RDS, S3, CloudWatch, IAM | 02/07/2026 | 02/07/2026 | [Cost and Usage Management](https://000064.awsstudygroup.com) |
| Fri | Review and write worklog report. Continuing to refine and re-test each feature of the group project, and writing the project Proposal and Workshop. Plan Week 12 | 03/07/2026 | 03/07/2026 | |

### Week 11 Outcomes

Gained a solid understanding of AWS Optimization and Documentation fundamentals:

- **AWS Cost Explorer:** A tool for visualizing AWS costs by service, region, tag, and time. Supports identifying spending trends and forecasting next month's costs.
- **Savings Plans / Reserved Instances:** Commit to hourly resource usage for 1–3 years in exchange for discounts of up to 72% compared to On-Demand pricing.
- **Spot Instance:** Purchase AWS's surplus EC2 capacity at up to 90% cheaper, but instances can be reclaimed at any time — suitable for non-production environments.
- **Least Privilege Principle:** An IAM security principle — each user/role is granted only the permissions they need, nothing more. Minimizes the attack surface if credentials are compromised.
- **MFA (Multi-Factor Authentication):** Protects accounts with 2 layers of authentication: password + physical device/OTP app. Mandatory for root accounts and high-privilege IAM users.
- **Security Group:** A virtual firewall at the instance level, controlling inbound/outbound traffic by IP and port. Operates as a whitelist — only allows what is explicitly declared.
- **S3 Block Public Access:** A protection mechanism at the account/bucket level, preventing accidental public exposure of objects via ACL or Bucket Policy.
- **Architecture Diagram:** A visual document representing the entire system: AWS services, how they connect, and data flow. An essential artifact for handovers or onboarding new team members.

---

#### Exercise 1: Cost Optimization Review with Cost Explorer

**AWS cost optimization strategies:**

| Service | Problem | Optimization Solution |
| :--- | :--- | :--- |
| **EC2** | On-Demand is expensive when running 24/7 | Use Spot Instances for dev/test environments |
| **RDS** | Running even when unused (weekends, nights) | Stop manually or use RDS Scheduler outside business hours |
| **NAT Gateway** | Charged per hour + per GB of data ($0.045/GB) | Consider replacing with VPC Endpoint if traffic only goes to S3/DynamoDB |
| **S3** | Old objects stored unnecessarily | Configure Lifecycle Rules: move to S3-IA after 30 days, delete after 90 days |

View cost per service in Cost Explorer:

> **Screenshot:** ![Cost Explorer dashboard](/images/evidence/week-11/01-cost-explorer.png)

---

#### Exercise 2: Security Audit — IAM

**IAM Security Checklist and rationale:**

| Item | Why It Matters |
| :--- | :--- |
| Root user not used daily | Root has full permissions and cannot be restricted by IAM Policy — if compromised, the entire account is lost |
| MFA enabled for root and admin users | Even if a password is leaked, attackers still need a physical device to log in |
| Access keys rotated periodically (90 days) | Limits the window attackers can use a leaked key without detection |
| No hardcoded credentials in code | Code is often pushed to GitHub — public credentials = account compromised within minutes |
| Apply Least Privilege Principle | Dev users don't need IAM or Billing permissions — over-provisioning is unnecessary risk |

> **Screenshot:** ![IAM security audit](/images/evidence/week-11/02-iam-security-audit.png)

---

#### Exercise 3: Security Audit — Security Groups and S3

**Security Groups — minimizing the attack surface:**

- **SSH (port 22):** Only open to the dev machine's specific IP, never `0.0.0.0/0` — if left open, bots will continuously attempt brute-force attacks.
- **RDS (port 3306):** Only allow inbound traffic from the EC2 Security Group; never assign a Public IP to RDS.
- **Application (port 8080):** Only open when needed, or place behind a Load Balancer — directly exposing an application port to the internet is an anti-pattern.

> **Screenshot:** ![Security Group audit](/images/evidence/week-11/03-security-group-audit.png)
>
> **Screenshot:** ![S3 security settings](/images/evidence/week-11/04-s3-security.png)

---

#### Exercise 4: Architecture Diagram

**Why an Architecture Diagram is necessary:**

An Architecture Diagram is not just a pretty document — it is a thinking tool that helps identify weaknesses in the design (single points of failure, bottlenecks, security gaps) before writing any code. When onboarding new team members or presenting to stakeholders, a diagram replaces dozens of pages of text.

**Drawing tool:** [draw.io](https://draw.io) — free, includes an AWS icon library, and supports export to PNG/SVG/PDF.

> **Screenshot:** ![Architecture diagram](/images/evidence/week-11/05-architecture-diagram.png)

---

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| NAT Gateway consuming the majority of costs | Routed S3 traffic through a VPC Gateway Endpoint (free), bypassing the NAT |
| Cost Explorer not showing detailed breakdown by tag | Enabled Cost Allocation Tags in Billing settings; waited 24 hours for data to appear |
| RDS still incurring charges when "stopped" after 7 days | AWS automatically restarts RDS after 7 days — must snapshot and delete if not needed long-term |

---

## Week 12 Plan

- Learn and deploy CloudFront CDN and Route 53 DNS to finalize the architecture with HTTPS and a custom domain.
- Perform final end-to-end system testing on the real domain.
- Clean up AWS resources.
- Finalize the internship report.
