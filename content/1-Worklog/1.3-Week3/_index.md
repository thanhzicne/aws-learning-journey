---
title: "Week 3 Worklog"
date: 2026-05-04
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

## Week 3 Objectives

- Understand EC2: instance types, AMI, key pair.
- Launch an EC2 instance (Ubuntu t3.micro Free Tier).
- Configure Security Group (SSH, HTTP, HTTPS).
- SSH into EC2 from local machine.
- Install Nginx and run a web server.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Study EC2: instance types, AMI, key pair. Launch Ubuntu t3.micro Free Tier instance | 04/05/2026 | 04/05/2026 | [Launch Linux Instance – Lab 000004](https://000004.awsstudygroup.com/4-launchlinuxinstance/4.1-createlinuxinstance/) |
| Tue | Create and configure Security Group `web-server-sg` (SSH, HTTP, HTTPS) | 05/05/2026 | 05/05/2026 | [Create Security Group for Linux – Lab 000004](https://000004.awsstudygroup.com/2-prerequiste/2.3-createsecuritygrouplinux/) |
| Wed | **SSH hands-on:** Connect to EC2 from local machine using `.pem` key pair | 06/05/2026 | 06/05/2026 | [Connect to Linux Instance – Lab 000004](https://000004.awsstudygroup.com/4-launchlinuxinstance/4.2-connectlinuxinstance/) |
| Thu | Install Nginx, start the web server, verify access via browser | 07/05/2026 | 07/05/2026 | [Introduction to Amazon EC2](https://000004.awsstudygroup.com) |
| Fri | Review and consolidate Week 3 knowledge. Write worklog report. Plan Week 4 | 08/05/2026 | 08/05/2026 | |

### Week 3 Results

- EC2 instance running and accessible via SSH.
- Nginx running and accessible via browser at `http://3.26.104.170`.
- Clear understanding of Security Group inbound/outbound rules.
- Clear understanding of the difference between Security Group and NACL.

#### Exercise 1: Launch EC2 Instance

Instance configuration:

- AMI: Ubuntu Server 22.04 LTS (Free Tier)
- Instance type: `t3.micro` (2 vCPU, 1 GB RAM)
- Key pair: Created new `aws-learning-key.pem`
- Storage: 8 GB gp2

Mastered the EC2 instance type naming convention:

```bash
t3.micro
│ │  └─── Size: nano/micro/small/medium/large/xlarge
│ └────── Generation: higher number = newer generation
└──────── Family:
          t = General Purpose (Burstable)
          m = General Purpose (Fixed)
          c = Compute Optimized
          r = Memory Optimized
          g = GPU
```

> **Screenshot:** ![EC2 launch config](/images/evidence/week-03/01-ec2-launch-config.png)

#### Exercise 2: Configure Security Group

Created Security Group `web-server-sg` with the following inbound rules:

| Type | Protocol | Port | Source | Reason |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

> **Security note:** SSH is restricted to My IP only — never open port 22 to 0.0.0.0/0.

Understood the difference between Security Group and NACL:

| | Security Group | NACL |
| :--- | :--- | :--- |
| Protection level | Instance (per machine) | Subnet (entire group) |
| Rule type | Allow only | Allow + Deny |
| Stateful | Yes | No |

> **Screenshot:** ![Security group](/images/evidence/week-03/02-security-group.png)

#### Exercise 3: SSH into EC2

```bash
# Set correct permissions for key file
chmod 400 aws-learning-key.pem

# SSH into EC2
ssh -i "aws-learning-key.pem" ubuntu@3.26.104.170

# Expected output:
# Welcome to Ubuntu 24.04.4 LTS (GNU/Linux 6.17.0-1012-aws x86_64)
# ubuntu@ip-172-31-24-73:~$
```

> **Screenshot:** ![SSH connected](/images/evidence/week-03/03-ssh-connected.png)

#### Exercise 4: Install Nginx Web Server

```bash
# Update packages
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Check status
sudo systemctl status nginx
```

Navigating to `http://3.26.104.170` displayed the "Welcome to Nginx" page successfully.

Understood the difference between EBS and Instance Store:

| | EBS | Instance Store |
| :--- | :--- | :--- |
| Data after stopping instance | Persists | Lost entirely |
| Speed | Slower | Faster |
| Use case | OS, databases | Cache, temporary data |

> **Screenshot:** ![Nginx running](/images/evidence/week-03/04-nginx-running.png)
>
> **Screenshot:** ![Nginx browser](/images/evidence/week-03/05-nginx-browser.png)

#### Challenges Encountered

| Issue | Resolution |
| :--- | :--- |
| Security Group had an MSSQL port 1433 rule open to 0.0.0.0/0 | Deleted the MSSQL rule — not needed for this exercise |
| SSH port 22 source set to 0.0.0.0/0 (open to entire internet) | Changed source type to "My IP" so only my machine can SSH in |
| HTTP/HTTPS source set to "My IP" instead of 0.0.0.0/0 | Changed to "Anywhere" — a public web server must be accessible to everyone |
| Instance launch failed: "Microsoft SQL Server is not supported for t3.micro" | Selected the wrong AMI (SQL Server instead of Ubuntu 22.04 LTS) — went back and selected the correct Ubuntu Free Tier AMI |

### Plan for Week 4

- Study VPC: subnets, route tables, internet gateway.
- Create a VPC with public/private subnets.
- Configure NAT Gateway.
- Move EC2 into the new VPC.
