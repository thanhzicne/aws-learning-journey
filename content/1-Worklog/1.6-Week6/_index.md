---
title: "Week 6 Worklog"
date: 2026-05-14
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

## Week 6 Objectives

- Create CloudWatch alarms (CPU, Network).
- Set up an SNS topic to send email alerts.
- Get comfortable with AWS CLI (install + configure).
- Practice CLI commands: list S3, describe EC2, query RDS.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Study CloudWatch: Metrics, Logs, Logs Insights. View EC2 and RDS metrics | 25/05/2026 | 25/05/2026 | [CloudWatch Metrics – Lab 000008](https://000008.awsstudygroup.com/3-cloud-watch-metric/) |
| Tue | Create CloudWatch Alarm for CPU > 80%. Set up SNS Topic + Email Subscription | 26/05/2026 | 26/05/2026 | [CloudWatch Alarms – Lab 000008](https://000008.awsstudygroup.com/5-cloud-watch-alarm/) |
| Wed | **Dashboard hands-on:** Create a CloudWatch Dashboard aggregating EC2, RDS, and S3 metrics | 27/05/2026 | 27/05/2026 | [CloudWatch Dashboard – Lab 000008](https://000008.awsstudygroup.com/6-cloud-watch-dashboard/) |
| Thu | Install AWS CLI, run `aws configure`, create multiple profiles (dev, prod) | 28/05/2026 | 28/05/2026 | [Install AWS CLI – Lab 000011](https://000011.awsstudygroup.com/3-installcli/) |
| Fri | Practice CLI commands: S3, EC2, RDS, CloudWatch. Review, write worklog report. Plan Week 7 | 29/05/2026 | 29/05/2026 | [Getting Started with the AWS CLI](https://000011.awsstudygroup.com/) |

### Week 6 Results

- CloudWatch Alarm `cpu-high-alarm` working correctly, triggers when CPU > 80%.
- SNS Topic `aws-learning-alerts` created, email notifications received successfully.
- CloudWatch Dashboard `ecommerce-monitoring` displaying EC2 and RDS metrics.
- AWS CLI installed and configured with `default` and `dev` profiles.
- Practiced essential CLI commands for S3, EC2, RDS, and CloudWatch.

#### Exercise 1: CloudWatch Metrics & Logs

Navigate to CloudWatch Console → Metrics → All metrics to view metrics by namespace:

- `AWS/EC2`: CPUUtilization, NetworkIn, NetworkOut, StatusCheckFailed
- `AWS/RDS`: CPUUtilization, DatabaseConnections, FreeStorageSpace
- `AWS/S3`: BucketSizeBytes, NumberOfObjects

Viewed CloudWatch Logs from the VPC Flow Logs enabled in Week 4: Log group `/aws/vpc/ecommerce-vpc`.

Overall CloudWatch architecture:

```text
EC2 / RDS / S3 → Metrics → CloudWatch
                                ↓
                             Alarms
                                ↓
                         SNS Topic → Email / SMS / Lambda
```

> **Screenshot:** ![CloudWatch metrics](/screenshots/week-06/01-cloudwatch-metrics.png)

#### Exercise 2: Create CloudWatch Alarm & SNS Topic

Created SNS Topic `aws-learning-alerts`:

```text
SNS Topic: aws-learning-alerts
  └── Subscription: Email → your@email.com
```

Confirmed the subscription by clicking the link in the confirmation email from `no-reply@sns.amazonaws.com`.

Created CloudWatch Alarm for CPU utilization:

- Metric: `CPUUtilization` (namespace `AWS/EC2`)
- Instance: EC2 `web-server` in `ecommerce-vpc`
- Threshold: > 80%
- Period: 5 consecutive minutes
- Action: send notification to SNS Topic `aws-learning-alerts`

**Note:** The alarm remains in `INSUFFICIENT_DATA` state until the SNS subscription is confirmed and the metric has enough data points.

> **Screenshot:** ![CloudWatch alarm](/screenshots/week-06/01-cloudwatch-alarm.png)
>
> **Screenshot:** ![SNS email received](/screenshots/week-06/02-sns-email-received.png)

#### Exercise 3: Create CloudWatch Dashboard

Navigate to CloudWatch → Dashboards → Create dashboard `ecommerce-monitoring`.

Added the following widgets:

- Line chart: `CPUUtilization` for EC2
- Line chart: `DatabaseConnections` for RDS
- Number widget: `FreeStorageSpace` for RDS
- Alarm status widget: displays the state of all alarms

> **Screenshot:** ![CloudWatch dashboard](/screenshots/week-06/03-cloudwatch-dashboard.png)

#### Exercise 4: Install & Configure AWS CLI

```bash
# macOS
brew install awscli

# Ubuntu/Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip && sudo ./aws/install

# Verify installation
aws --version

# Configure default profile
aws configure
# AWS Access Key ID: [IAM User access key]
# AWS Secret Access Key: [IAM User secret key]
# Default region: ap-southeast-1
# Default output format: json
```

Created multiple profiles to manage different environments:

```bash
# Create per-environment profiles
aws configure --profile dev
aws configure --profile prod

# Use a specific profile
aws s3 ls --profile dev
aws ec2 describe-instances --profile prod
```

> **Screenshot:** ![CLI configured](/screenshots/week-06/03-cli-commands.png)

#### Exercise 5: Practice CLI Commands

```bash
# S3
aws s3 ls                                          # List all buckets
aws s3 ls s3://demo-bucket-phamducthanh            # List files in a bucket
aws s3 cp file.txt s3://demo-bucket-phamducthanh/  # Upload a file

# EC2
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]' \
  --output table

# RDS
aws rds describe-db-instances \
  --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Endpoint.Address]' \
  --output table

# CloudWatch
aws cloudwatch list-metrics --namespace AWS/EC2
aws cloudwatch describe-alarms --output table
```

> **Screenshot:** ![CLI commands output](/screenshots/week-06/04-cli-output.png)

#### Challenges Encountered

| Issue | Resolution |
| :--- | :--- |
| Alarm stuck in `INSUFFICIENT_DATA` state | Must confirm the SNS subscription email first, then wait for metric data points to accumulate |
| SNS not sending emails | Check the spam folder — emails from `no-reply@sns.amazonaws.com` are often filtered |
| `aws: command not found` after installation | Add AWS CLI to PATH: `export PATH=$PATH:/usr/local/bin` |
| `An error occurred (AuthFailure)` when running CLI | Access key incorrect or `aws configure` not run — check `~/.aws/credentials` |

### Plan for Week 7

- Study Application Load Balancer (ALB) and Target Groups.
- Launch a second EC2 instance into `public-subnet-1b`.
- Configure ALB to distribute traffic across 2 EC2 instances.
- Create a Launch Template and Auto Scaling Group.
- Test scale-out behaviour when CPU exceeds the threshold.
