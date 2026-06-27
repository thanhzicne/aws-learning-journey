---
title: "Blog 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

## [AWS Security] Serverless Security Does Not Rely on a Single Layer

Serverless reduces server management, but it doesn't mean the system is automatically secure. With serverless microservices, every API, Lambda function, secret, or database can become a vulnerability if misconfigured.

Therefore, security should not rely solely on a single layer like a WAF or an API Gateway. The architecture should adopt a defense-in-depth approach, meaning multiple successive layers of protection so that if one layer is breached, the remaining layers still help mitigate the damage.

7 Key Protection Layers in AWS Architecture:

Edge Protection: Protect inbound traffic using Amazon CloudFront, AWS WAF, and AWS Shield.

Identity Protection: Authenticate users and control access using Amazon Cognito.

API Protection: Protect APIs, validate tokens, rate-limit requests, and encrypt connections using Amazon API Gateway.

Network Isolation: Isolate sensitive resources using Amazon VPC, Security Groups, Network ACLs, and VPC Endpoints.

Compute Security: Protect Lambda functions using IAM least privilege, AWS KMS, resource-based policies, and code signing.

Secrets Protection: Manage credentials, API keys, and sensitive information using AWS Secrets Manager.

Data Protection: Protect data using DynamoDB encryption, access controls, and backups.

Continuous Monitoring
In addition to the 7 layers above, the system requires continuous monitoring using Amazon GuardDuty, AWS CloudTrail, Amazon CloudWatch, AWS Security Hub, and Amazon Bedrock to detect anomalies, track behaviors, and support security analysis.

The Beauty of It
This architecture does not depend on a single layer of protection. If the WAF is bypassed, the system still has API Gateway, Cognito, IAM, Secrets Manager, and backend monitoring in place to reduce the blast radius (impact scope).

Conclusion
Serverless helps reduce server management overhead, but it doesn't eliminate security responsibilities. For a production system, security must be designed from the ground up—covering traffic, authentication, APIs, networking, Lambda, secrets, data, all the way to monitoring.

**References:** <https://aws.amazon.com/vi/blogs/security/building-an-ai-powered-defense-in-depth-security-architecture-for-serverless-microservices/>

**Image:**
> ![poot2](/images/blogs/blog2/post2.png)

**Link:** <https://www.facebook.com/groups/awsstudygroupfcj/permalink/2189122901852670/?rdid=Lp3uW8qDC4gJGOC1#>
