---
title: "Week 4 Worklog"
date: 2026-05-11
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

## Week 4 Objectives

- Understand VPC: subnets, CIDR, route tables, internet gateway.
- Create a Custom VPC with public and private subnets.
- Configure a NAT Gateway for the private subnet.
- Move EC2 into the new VPC and verify connectivity.
- Enable VPC Flow Logs to monitor traffic.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Study VPC theory: CIDR, Subnet, Route Table. Create Custom VPC `ecommerce-vpc` | 11/05/2026 | 11/05/2026 | [Create VPC – Lab 000003](https://000003.awsstudygroup.com/3-prerequisite/3.1-createvpc/) |
| Tue | Create 4 subnets (2 public, 2 private, multi-AZ). Create Internet Gateway and Route Tables | 12/05/2026 | 12/05/2026 | [Create Subnet](https://000003.awsstudygroup.com/3-prerequisite/3.2-createsubnet/) · [Create IGW](https://000003.awsstudygroup.com/3-prerequisite/3.3-createigw/) · [Create Route Table](https://000003.awsstudygroup.com/3-prerequisite/3.4-createroutetable/) |
| Wed | **NAT Gateway hands-on:** Create NAT Gateway in public subnet, update private route table | 13/05/2026 | 13/05/2026 | [Create NAT Gateway – Lab 000003](https://000003.awsstudygroup.com/4-createec2server/4.3-natgateway/) |
| Thu | Create Security Groups for web server and database. Launch EC2 into new VPC, test SSH and internet connectivity | 14/05/2026 | 14/05/2026 | [Create Security Group](https://000003.awsstudygroup.com/3-prerequisite/3.5-createsecuritygroup/) · [Deploy EC2](https://000003.awsstudygroup.com/4-createec2server/4.1-createec2/) |
| Fri | Enable VPC Flow Logs → CloudWatch. Review, write worklog report. Plan Week 5 | 15/05/2026 | 15/05/2026 | [Enable VPC Flow Logs – Lab 000003](https://000003.awsstudygroup.com/3-prerequisite/3.6-enablevpcflowlogs/) |

### Week 4 Results

- VPC `ecommerce-vpc` (10.0.0.0/16) created successfully.
- 4 subnets: 2 public (1a, 1b), 2 private (1a, 1b) — multi-AZ.
- Internet Gateway attached and public route table working correctly.
- NAT Gateway deployed in public subnet; private route table pointing to it correctly.
- Security Groups `web-server-sg` and `db-server-sg` configured correctly.
- EC2 in public subnet accessible via SSH and able to ping the internet.
- VPC Flow Logs enabled — logs writing to CloudWatch.

#### Exercise 1: Create VPC

Navigate to VPC Console → Your VPCs → Create VPC:

| Parameter | Value |
| :--- | :--- |
| Name | `ecommerce-vpc` |
| IPv4 CIDR | `10.0.0.0/16` |
| Tenancy | Default |
| IPv6 | Disabled |

> **Note:** Select "VPC only" (do not use the Wizard) to understand each component individually.

```text
CIDR 10.0.0.0/16 allows up to 65,536 IP addresses
→ Sufficient to divide into many smaller subnets
```

> **Screenshot:** ![VPC created](/images/evidence/week-04/01-vpc-created.png)

#### Exercise 2: Create Subnets, Internet Gateway & Route Tables

Created 4 subnets (2 public, 2 private — multi-AZ in preparation for Week 6 ELB):

| Name | CIDR | Availability Zone | Type |
| :--- | :--- | :--- | :--- |
| public-subnet-1a | 10.0.1.0/24 | ap-southeast-1a | Public |
| public-subnet-1b | 10.0.2.0/24 | ap-southeast-1b | Public |
| private-subnet-1a | 10.0.3.0/24 | ap-southeast-1a | Private |
| private-subnet-1b | 10.0.4.0/24 | ap-southeast-1b | Private |

After creation, enabled Auto-assign public IPv4 for both public subnets: select subnet → Actions → Edit subnet settings → Enable auto-assign public IPv4 address.

Created Internet Gateway `ecommerce-igw` → Actions → Attach to VPC → select `ecommerce-vpc`.

Created 2 route tables inside `ecommerce-vpc`:

- `public-rtb`: added route `0.0.0.0/0` → `ecommerce-igw`, associated `public-subnet-1a` and `public-subnet-1b`.
- `private-rtb`: no `0.0.0.0/0` route yet — will be added after NAT Gateway is ready. Associated `private-subnet-1a` and `private-subnet-1b`.

> **Screenshot:** ![Subnets created](/images/evidence/week-04/02-subnets-created.png)
>
> **Screenshot:** ![IGW attached](/images/evidence/week-04/03-igw-attached.png)
>
> **Screenshot:** ![Route tables](/images/evidence/week-04/04-route-tables.png)

#### Exercise 3: Create NAT Gateway

The NAT Gateway allows EC2 instances in the private subnet to reach the internet for package updates, while blocking inbound connections from the internet.

Navigate to NAT Gateways → Create NAT Gateway:

| Parameter | Value |
| :--- | :--- |
| Name | `ecommerce-nat` |
| Subnet | `public-subnet-1a` (must be a public subnet) |
| Connectivity type | Public |
| Elastic IP | Click Allocate Elastic IP |

Once the NAT Gateway status becomes Available, updated `private-rtb`: added route `0.0.0.0/0` → target `ecommerce-nat`.

> **Screenshot:** ![NAT Gateway](/images/evidence/week-04/05-nat-gateway.png)

#### Exercise 4: Create Security Groups, Launch EC2 & Test Connectivity

Created 2 Security Groups inside `ecommerce-vpc`.

Security Group for Web Server (public subnet) — `web-server-sg`:

| Type | Protocol | Port | Source | Reason |
| :--- | :--- | :--- | :--- | :--- |
| SSH | TCP | 22 | My IP | Remote access |
| HTTP | TCP | 80 | 0.0.0.0/0 | Web traffic |
| HTTPS | TCP | 443 | 0.0.0.0/0 | Secure web |

Security Group for Database (private subnet) — `db-server-sg`:

| Type | Protocol | Port | Source | Reason |
| :--- | :--- | :--- | :--- | :--- |
| MySQL/Aurora | TCP | 3306 | `web-server-sg` | Only EC2 can access RDS |

Launched EC2 instance into `ecommerce-vpc`: Network `ecommerce-vpc`, Subnet `public-subnet-1a`, Security Group `web-server-sg`, Auto-assign public IP Enabled.

```bash
# SSH into public EC2
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Test outbound internet from public EC2
ping -c 4 google.com
# Expected: 4 packets transmitted, 4 received

# Check public IP
curl ifconfig.me
```

> **Screenshot:** ![Security groups](/images/evidence/week-04/06-security-groups.png)
>
> **Screenshot:** ![EC2 in VPC](/images/evidence/week-04/07-ec2-in-vpc.png)
>
> **Screenshot:** ![Ping success](/images/evidence/week-04/08-ping-success.png)
>
> **Screenshot:** ![Deploy web server](/images/evidence/week-04/09-deploy-web-server.png)

#### Exercise 5: Enable VPC Flow Logs

VPC Flow Logs capture all traffic in and out of the VPC — useful for debugging and security auditing.

Navigate to Your VPCs → select `ecommerce-vpc` → Flow logs tab → Create flow log:

| Parameter | Value |
| :--- | :--- |
| Filter | All |
| Destination | CloudWatch Logs |
| Log group | `/aws/vpc/ecommerce-vpc` |
| IAM role | Create a new role allowing VPC to write to CloudWatch |

Full VPC architecture after completing all exercises:

```text
VPC: ecommerce-vpc (10.0.0.0/16)
│
├── public-subnet-1a (10.0.1.0/24) — AZ: ap-southeast-1a
│   ├── Route: 0.0.0.0/0 → ecommerce-igw
│   ├── EC2 Web Server (with Public IP)
│   └── NAT Gateway (ecommerce-nat)
│
├── public-subnet-1b (10.0.2.0/24) — AZ: ap-southeast-1b
│   ├── Route: 0.0.0.0/0 → ecommerce-igw
│   └── [Reserved for Week 6: ALB / second EC2]
│
├── private-subnet-1a (10.0.3.0/24) — AZ: ap-southeast-1a
│   ├── Route: 0.0.0.0/0 → ecommerce-nat
│   └── RDS MySQL [Week 5]
│
└── private-subnet-1b (10.0.4.0/24) — AZ: ap-southeast-1b
    ├── Route: 0.0.0.0/0 → ecommerce-nat
    └── [Reserved for RDS Multi-AZ]
```

> **Screenshot:** ![VPC Flow Logs](/images/evidence/week-04/10-flow-logs.png)

#### Challenges Encountered

| Issue | Cause | Resolution |
| :--- | :--- | :--- |
| NAT Gateway stuck in "Pending" status | Normal — takes 1–2 minutes to provision | Wait and refresh the console |
| New EC2 unreachable via SSH despite correct security group | Forgot to enable Auto-assign public IPv4 on the public subnet | Go to subnet settings → Enable auto-assign public IPv4 |
| Private subnet still couldn't reach the internet after creating NAT | Forgot to add route `0.0.0.0/0` → NAT in `private-rtb` | Add route with NAT Gateway as the correct target |
| Subnet creation failed with CIDR overlap error | Entered a CIDR that conflicted with another subnet | Check ranges: public uses 10.0.1.x and 10.0.2.x, private uses 10.0.3.x and 10.0.4.x |

### Plan for Week 5

- Create an RDS MySQL instance (db.t3.micro Free Tier).
- Place RDS in `private-subnet-1a` with Security Group `db-server-sg`.
- Connect to RDS from EC2 via MySQL client.
- Import ecommerce schema and sample data (products table).
- Confirm: EC2 (public) → RDS (private) connection works, but the internet cannot reach RDS directly.
