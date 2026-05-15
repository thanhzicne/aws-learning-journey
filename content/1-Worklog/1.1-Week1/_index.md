---
title: "Week 1 Worklog"
date: 2026-04-17
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---

## Week 1 Objectives

- Understand AWS global structure (Regions, AZs, Edge Locations).
- Understand Billing and Cost Management.
- Understand IAM roles and the permission model.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Study AWS global structure (Regions, AZs, Edge Locations). Create an AWS Free Tier account | 20/04/2026 | 20/04/2026 | [AWS Free Tier 2025 – Create AWS Account](https://000001.awsstudygroup.com) |
| Tue | Study IAM: User, Group, Role, Policy. Study the Least Privilege Principle | 21/04/2026 | 21/04/2026 | [AWS IAM Access Control](https://000002.awsstudygroup.com) |
| Wed | **IAM Hands-on:** Create `admin-user` (AdministratorAccess), `dev-user` (PowerUserAccess), Group `Developers` | 22/04/2026 | 22/04/2026 | [AWS IAM Access Control – Create IAM Group and User](https://000002.awsstudygroup.com/2-create-admin-user-and-group/) |
| Thu | Study Billing and Cost Management: view costs, set up Free Tier alerts, create a Budget | 23/04/2026 | 23/04/2026 | [Cost Management with AWS Budgets](https://000007.awsstudygroup.com) |
| Fri | Review and consolidate Week 1 knowledge. Write worklog report. Plan Week 2 | 24/04/2026 | 24/04/2026 | |

### Week 1 Results

- Understood AWS global structure:
  - **Region:** A geographic area (e.g. `ap-southeast-1` = Singapore)
  - **Availability Zone:** A data center within a Region (typically 3 AZs per region)
  - **Edge Location:** Cache nodes for CloudFront CDN

#### Exercise 1: Create an AWS Account

Created an AWS account with a new email address and selected the Free Tier plan. Credit card verification completed successfully.

> **Screenshot:** ![AWS account created](/images/evidence/week-01/01-aws-account-created.png)

#### Exercise 2: Create IAM Users

Mastered key IAM concepts:

- **User:** A specific individual with their own credentials
- **Group:** A collection of users that share a common policy
- **Role:** Temporary permissions granted to a service or application
- **Policy:** A JSON document that defines permissions

Created 2 users:

- `admin-user`: Assigned the `AdministratorAccess` policy
- `dev-user`: Assigned the `PowerUserAccess` policy (no IAM management rights)

Both users were added to the `Developers` Group.

```text
IAM Structure:
├── Group: Developers
│   ├── Policy: PowerUserAccess
│   ├── User: dev-user
│   └── User: admin-user (also has AdministratorAccess)
```

> **Screenshot:** ![IAM dashboard](/images/evidence/week-01/02-iam-dashboard.png)
>
> **Screenshot:** ![IAM users created](/images/evidence/week-01/03-iam-users-created.png)

#### Exercise 3: Billing and Cost Management

Billing and Cost Management in Amazon Web Services (AWS) is the service used to track costs, control budgets, and manage payment for all AWS resources in use.

Billing and Cost Management allows you to:

- View total AWS costs by day / month
- Identify which services are incurring charges (EC2, RDS, S3, etc.)
- Set up alerts when approaching Free Tier limits
- Create spending limit budgets (Budget)
- Download payment invoices
- View payment history
- Manage payment methods (Visa/MasterCard)

> **Screenshot:** ![Billing and cost management](/images/evidence/week-01/04-billing-and-cost-management.png)

#### Challenges Encountered

| Issue | Resolution |
| :--- | :--- |
| Initially unsure which Region to choose | Chose `ap-southeast-1` (Singapore) — closest to Vietnam, lowest latency |
| Confused IAM User and IAM Role | Re-read the docs: User = a real person, Role = permissions for a service |

### Plan for Week 2

- Master S3 fundamentals: bucket, object, storage classes.
- Understand ACL, Bucket Policy, and Public Access settings.
- Deploy Static Website Hosting on S3.
- Manage object versioning & lifecycle.
