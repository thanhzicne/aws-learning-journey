---
title: "Proposal"
date: 2026-05-14
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## AI Content Generator Platform - AI-Powered Marketing Content Creation Platform on AWS

### 1. Project Overview

**AI Content Generator Platform** is a next-generation SaaS platform that helps small and medium businesses (SMBs) automate their marketing content creation process using Generative AI. The platform combines **AWS Cloud** and the **Gemini API (Google AI)** to deliver a scalable, secure, and versatile content generation solution.

| Criteria | Value |
| --- | --- |
| Business model | SaaS — monthly/annual subscription |
| Target customers | Small and medium businesses (SMBs), marketing agencies |
| AI technology | Gemini API (Google AI) via AWS Lambda |
| AWS Region | ap-southeast-1 (Singapore) |
| Availability Zones | ap-southeast-1a and ap-southeast-1b |
| Scalability | Auto Scaling Group (10–10,000+ users) |
| Availability | Multi-AZ deployment, RDS Multi-AZ failover (99.9% uptime) |

## 2. Objectives

### 2.1 Project objectives

| # | Objective | Success metric |
| --- | --- | --- |
| 1 | Build a complete MVP in 4 weeks (Week 9–12) | Go-live by end of Week 12 |
| 2 | Achieve high availability for the production system | Uptime ≥ 99.9% |
| 3 | Automate the end-to-end AI content generation flow | < 60 seconds per content piece |
| 4 | Deliver an architecture aligned with the AWS Well-Architected Framework | All 6 pillars covered |
| 5 | Comprehensive security under the Least Privilege principle | No wildcard `*` permissions |

### 2.2 Value delivered

- **Time savings:** Content creation cycle shortened from 3–5 days to **under 30 minutes**.
- **Cost savings:** 60–80% reduction versus hiring copywriters/agencies (from $500–3,000/month down to $50–150/month).
- **Brand consistency:** Brand Persona ensures the correct tone of voice whether generating 10 or 1,000 pieces of content.
- **Easy scaling:** Scale across multiple products, markets, and languages without linear headcount growth.

### 3. Problem Statement

#### 3.1 Market context

The digital marketing market in Southeast Asia has grown rapidly since the COVID-19 pandemic. SMBs face constant pressure to produce multi-channel content, while creative resources remain limited and copywriter/agency costs continue to rise.

#### 3.2 Core problems

**Problem 1 — High labor cost**
An average SMB spends $500–$3,000/month on marketing content. High-quality creative talent is scarce and expensive.

**Problem 2 — Inconsistent branding**
When multiple people or agencies produce content, tone of voice and brand imagery easily diverge, eroding end-customer trust.

**Problem 3 — Slow content production**
The traditional workflow of brief → write → review → revise → publish takes an average of **3–7 business days**, which cannot keep up with the pace of real-time marketing.

**Problem 4 — Difficult to scale**
As a business expands into new products or markets, content demand multiplies, but headcount cannot scale linearly to match.

#### 3.3 Opportunity

The rise of LLMs and their API-accessibility creates an opportunity to build a **content automation platform** capable of understanding brand context, adapting to target audiences, and exporting to multiple formats — all through a simple interface that requires no technical skills.

### 4. Solution Architecture

#### 4.1 Overview

The system is deployed on Amazon Web Services (AWS) using a multi-tier architecture aligned with the AWS Well-Architected Framework. The entire infrastructure runs inside a single Amazon VPC (10.0.0.0/16) in the ap-southeast-1 (Singapore) Region, spanning two Availability Zones (ap-southeast-1a and ap-southeast-1b) to ensure high availability and fault tolerance.

The React SPA frontend is hosted on Amazon S3 Static Website and distributed through Amazon CloudFront. CloudFront uses two origins:

- Amazon S3 Static Website (React SPA)
- Amazon API Gateway (REST API)

Every API request passes through AWS WAF, Amazon API Gateway, and the Amazon Cognito Authorizer before being forwarded via a VPC Link to an internal Application Load Balancer. The Application Load Balancer performs health checks and distributes requests to the Amazon EC2 Auto Scaling Group deployed across two Availability Zones.

**Architecture diagram:**

![AI Content Generator Platform architecture](/images/proposal/proposal-architecture1.png)

#### 4.2 Architecture components

| Tier | Service | Role |
| --- | --- | --- |
| Edge & Security | Amazon CloudFront | Global content delivery (CDN), caches static content, and routes requests to two origins: Amazon S3 Static Website and Amazon API Gateway. |
| | AWS WAF | Protects the application from SQL Injection, Cross-Site Scripting (XSS), Layer 7 DDoS, and malicious bots before requests reach API Gateway. |
| API | Amazon API Gateway | Performs JWT validation via the Amazon Cognito User Pool Authorizer before forwarding requests to the Application Load Balancer. |
| | Amazon Cognito | Manages the User Pool, authenticates users via JWT tokens, and acts as the Authorizer for Amazon API Gateway. |
| Compute | Application Load Balancer | Deployed across two Availability Zones; receives requests from Amazon API Gateway, performs health checks, and distributes load to the Amazon EC2 Auto Scaling Group. |
| | Amazon EC2 (Express API) | Handles all core business logic: user authentication, building prompts from Brand Persona, querying Amazon RDS PostgreSQL, and enqueueing AI jobs to Amazon SQS. EC2 uses an IAM Role to retrieve database credentials from AWS Secrets Manager. EC2 runs in Application Private Subnets with no public IP. |
| | Auto Scaling Group | Automatically scales the number of EC2 instances based on real load. |
| Queue & AI Worker | Amazon SQS (Main Queue) | Receives AI jobs from EC2 for asynchronous processing. |
| | Amazon SQS (Dead Letter Queue) | Captures failed messages via a redrive policy. |
| | AWS Lambda (Node.js) | The Lambda worker runs inside the VPC (VPC-attached), **polls AI jobs from the Amazon SQS Main Queue via Event Source Mapping**, uses an IAM Role to retrieve the Gemini API key from AWS Secrets Manager, reaches the internet through the NAT Gateway and Internet Gateway to call the Gemini API, and stores results in both Amazon S3 and Amazon RDS. |
| Networking | NAT Gateway | One NAT Gateway per AZ in the public subnet, allowing **both Amazon EC2 and AWS Lambda (deployed in private subnets)** to initiate outbound internet connections without a public IP. |
| | Internet Gateway | The VPC's internet entry/exit point, allowing the NAT Gateways to forward traffic from EC2/Lambda to the internet to reach external services (Gemini API, AWS public endpoints). |
| | VPC Endpoint for S3 | A dedicated Gateway Endpoint for Amazon S3, allowing AWS Lambda to write AI output to the S3 export bucket over the AWS private network, without traversing the public internet. |
| AI | Gemini API (Google AI) | The LLM that generates marketing content. |
| Data | Amazon RDS PostgreSQL (Multi-AZ) | Deployed in Database Private Subnets with a DB Subnet Group spanning two Availability Zones. The application connects only to the **RDS Primary** endpoint; data is automatically synchronized to the **RDS Standby** for high availability — the standby is never accessed directly by the application. |
| | Amazon S3 (Static Website) | Hosts the React Single Page Application (SPA) and serves as the origin for Amazon CloudFront. |
| | Amazon S3 (Export Bucket) | Stores generated PDF, DOCX, image files, and other AI-generated assets. |
| Observability | CloudWatch | Collects logs, metrics, and alarms from Amazon EC2, AWS Lambda, and Amazon API Gateway for monitoring, alerting, and operational visibility. |
| Security | AWS Secrets Manager | Stores the Gemini API key and database credentials. Amazon EC2 and AWS Lambda access secrets via IAM Roles under the Least Privilege principle. |
| | AWS KMS | Manages encryption keys for Amazon RDS, Amazon S3, and AWS Secrets Manager to protect data at rest. |
| | AWS IAM | Enforces the Least Privilege principle. EC2 and Lambda use separate IAM Roles; no static access keys are used. |

#### 4.3 Main processing flow

1. The user accesses the application through Amazon CloudFront.
2. CloudFront serves the React SPA from Amazon S3 Static Website.
3. CloudFront forwards API requests to Amazon API Gateway.
4. Amazon API Gateway authenticates the JWT via the Amazon Cognito Authorizer.
5. Amazon API Gateway forwards the request over a VPC Link to the internal Application Load Balancer.
6. The Application Load Balancer performs health checks and distributes the request to the Amazon EC2 Auto Scaling Group.
7. Amazon EC2 handles business authentication, queries Amazon RDS PostgreSQL, retrieves database credentials from AWS Secrets Manager via an IAM Role, and enqueues the AI job into the Amazon SQS Main Queue.
8. The AWS Lambda worker polls the AI job from the Amazon SQS Main Queue via Event Source Mapping (Lambda actively pulls the job; SQS does not push it to Lambda).
9. AWS Lambda retrieves the Gemini API key from AWS Secrets Manager and initiates an outbound connection through the NAT Gateway.
10. AWS Lambda stores the AI output in the Amazon S3 export bucket via the Amazon VPC Endpoint for S3.
11. AWS Lambda updates the job status in Amazon RDS PostgreSQL (**Primary**); data is automatically synchronized to the RDS Standby (the application never connects to the standby directly).
12. The NAT Gateway forwards traffic through the Internet Gateway to the internet, allowing AWS Lambda to send the prompt to the Gemini API (Google AI) and receive the generated content.
13. Amazon EC2 retrieves the result from Amazon RDS and returns the response through Amazon API Gateway, CloudFront, and the React SPA.

#### 4.4 AWS Well-Architected Framework

| Pillar | Applied solution |
| --- | --- |
| Operational Excellence | CloudWatch, CI/CD |
| Security | AWS WAF, IAM Least Privilege, Secrets Manager, KMS, private subnets |
| Reliability | Application Load Balancer, Auto Scaling Group, Multi-AZ RDS, NAT Gateway, SQS DLQ, VPC Endpoint for S3 |
| Performance Efficiency | CloudFront, Lambda, RDS optimization |
| Cost Optimization | Auto Scaling, Lambda pay-per-use, S3 lifecycle policies |
| Sustainability | Scale on demand, shut down Dev environments outside business hours |

### 5. Timeline

| Week | Goal | Key work | Milestone |
| --- | --- | --- | --- |
| 9 | Complete AWS infrastructure | Draw architecture diagram + VPC + subnets + IAM; RDS Multi-AZ + Secrets Manager; ALB + EC2 ASG; CloudFront + WAF + API Gateway + CI/CD | Ping test: CloudFront → API Gateway → Application Load Balancer → EC2 → RDS |
| 10 | Core backend + basic UI | Auth API (JWT + Cognito); Brand Persona CRUD; prompt engine from brief + persona; React dashboard (UI v1.0) | Log in, create a persona, submit a brief, receive an auto-generated prompt |
| 11 | End-to-end AI worker flow | SQS pipeline; Lambda → Gemini API → S3 + RDS; PDF/DOCX/HTML export; load testing & optimization | Brief → AI generates content → export to PDF in under 60 seconds |
| 12 | Hardening & production | Security audit (WAF, IAM, pentest); UAT + feedback collection; bug fixes + finalize docs/runbook; go-live + onboarding | Production live, 24/7 monitoring, first customer onboarded |

### 6. Budget

#### 6.1 Build cost

| Service | Configuration | Cost/month |
| --- | --- | --- |
| Amazon EC2 | t3.medium × 2 (On-Demand, Auto Scaling min=2, 1/AZ) | ~$60 |
| Amazon RDS PostgreSQL | db.t3.micro, Multi-AZ | ~$50 |
| NAT Gateway | Production: 2 NAT Gateways · Development: 1 NAT Gateway | ~$64 |
| CloudFront | 100 GB transfer | ~$8 |
| API Gateway | 1M requests | ~$3–4/month (depending on volume) |
| CloudWatch | Basic logs + metrics | ~$5 |
| AWS Lambda | ~100,000 invocations, 512MB | ~$1 |
| Amazon SQS | ~500,000 requests | ~$0.20 |
| Amazon S3 | 50 GB | ~$2 |
| AWS Secrets Manager | 2 secrets (Gemini API key, database credentials) | ~$2/month |
| AWS KMS | 1 customer-managed KMS key (used by RDS, S3, Secrets Manager) | ~$1 |
| Amazon Cognito | < 50,000 MAU (Free Tier) | $0 |
| **Total AWS/month** | | **~$196** |

#### Gemini API (Google AI)

| Stage | Request volume | Estimated cost |
| --- | --- | --- |
| Dev/Staging | ~1,000/month | ~$1–5/month |

#### 6.2 Cost optimization strategy

- **Reserved Instances:** 1-year commitment for EC2 and RDS → 30–40% savings.
- **Lambda serverless:** The AI worker is billed only per job, with no idle cost.
- **CloudFront caching:** Reduces the number of requests reaching EC2 and lowers bandwidth usage.
- **S3 Lifecycle Policy:** Automatically moves files older than 90 days to S3 Glacier.
- **Auto Scaling:** Scales down to minimum instances outside peak hours.
- **Spot Instances for Dev:** 60–70% savings versus On-Demand.

### 7. Risks

#### 7.1 Risk matrix

| Risk | Likelihood | Impact |
| --- | --- | --- |
| Gemini API downtime/throttling | Medium | High |
| Gemini API cost exceeding budget | High | Medium |
| User data security breach | Low | Very high |
| A single EC2 instance failure (not the whole system — mitigated by the multi-AZ Auto Scaling Group's automatic replacement) | Medium | Low |
| Slow RDS failover | Low | Medium |
| Lambda timeout when Gemini responds slowly | Medium | Medium |
| AWS cost exceeding estimates | Medium | Low |
| Phase 3 (AI Integration) schedule delay | Medium | Low |

#### 7.2 Mitigation measures

- AWS WAF protects the system from SQL Injection, XSS, and bots.
- Amazon API Gateway uses the Cognito Authorizer to validate JWTs.
- The Application Load Balancer receives requests from Amazon API Gateway and distributes traffic to the Amazon EC2 Auto Scaling Group across two Availability Zones — a single EC2 instance failure is automatically replaced by the ASG without affecting the whole system.
- Amazon EC2, AWS Lambda, and Amazon RDS all run in private subnets.
- AWS Secrets Manager stores database credentials and the Gemini API key.
- AWS KMS encrypts Amazon RDS, Amazon S3, and AWS Secrets Manager.
- The NAT Gateway and Internet Gateway restrict outbound internet access to only what EC2/Lambda need for external services (Gemini API, AWS public endpoints).
- The Amazon VPC Endpoint for S3 lets AWS Lambda write data to Amazon S3 over the AWS private network, without traversing the public internet.
- IAM Roles enforce the Least Privilege principle.
- All connections use TLS 1.2 or higher.

---

**References:**

- AWS Well-Architected — <https://aws.amazon.com/architecture/well-architected/>
- Gemini API Docs — <https://ai.google.dev/docs>
- Amazon SQS Best Practices — <https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/best-practices.html>
