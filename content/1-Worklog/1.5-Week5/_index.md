---
title: "Week 5 Worklog"
date: 2026-05-14
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

## Week 5 Objectives

- Create an RDS MySQL instance (db.t2.micro Free Tier).
- Place RDS in a private subnet (accessible by EC2 only).
- Connect to RDS from EC2 via MySQL client.
- Import database schema and sample data.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Study RDS: managed vs self-managed. Create DB Security Group and DB Subnet Group | 18/05/2026 | 18/05/2026 | [Prerequisite Steps – Lab 000005](https://000005.awsstudygroup.com/2-prerequiste/) |
| Tue | Create RDS MySQL 8.0 instance (db.t2.micro, Free Tier) in private subnet | 19/05/2026 | 19/05/2026 | [Create MySQL DB Instance – Lab 000005](https://000005.awsstudygroup.com/4-createdbinstance/4.1-cretaemysqldbinstance/) |
| Wed | **Connection hands-on:** SSH into EC2, install MySQL client, connect to RDS endpoint | 20/05/2026 | 20/05/2026 | [Connect DB Instance – Lab 000005](https://000005.awsstudygroup.com/4-createdbinstance/4.2-connectmysqldbinstance/) |
| Thu | Import ecommerce schema and sample data (products table). Run test queries | 21/05/2026 | 21/05/2026 | [Application Deployment – Lab 000005](https://000005.awsstudygroup.com/5-deploy-app/) |
| Fri | Review and consolidate Week 5 knowledge. Write worklog report. Plan Week 6 | 22/05/2026 | 22/05/2026 | |

### Week 5 Results

- RDS MySQL instance running in private subnet, not accessible from the internet.
- Successfully connected from EC2 via MySQL client.
- `ecommerce` schema and `products` table created successfully.
- Confirmed: EC2 (public) → RDS (private) connection works, but the internet cannot reach RDS directly.

#### Exercise 1: Create DB Security Group & DB Subnet Group

Created Security Group `db-server-sg` inside `ecommerce-vpc`:

| Type | Protocol | Port | Source | Reason |
| :--- | :--- | :--- | :--- | :--- |
| MySQL/Aurora | TCP | 3306 | `web-server-sg` (Security Group ID) | Only EC2 instances can access RDS |

> **Security note:** Source is the EC2 Security Group ID, not a public IP range — this is the production best practice.

Created DB Subnet Group `rds-subnet-group`:

- VPC: `ecommerce-vpc`
- Subnets: `private-subnet-1a` and `private-subnet-1b` (minimum 2 AZs required to support Multi-AZ later)

> **Screenshot:** ![DB Security Group and Subnet Group](/images/evidence/week-05/01-rds-prereq.png)

#### Exercise 2: Create RDS MySQL Instance

Navigate to RDS Console → Databases → Create database:

| Parameter | Value |
| :--- | :--- |
| Engine | MySQL 8.0 |
| Template | **Free Tier** |
| Instance class | `db.t2.micro` |
| Storage | 20 GB gp2 |
| Multi-AZ | No |
| Subnet group | `rds-subnet-group` |
| Public access | **No** |
| Security Group | `db-server-sg` |

Understood the key difference between RDS and self-managed MySQL on EC2:

| | RDS | Self-managed MySQL on EC2 |
| :--- | :--- | :--- |
| Backups | Automated | Manual |
| Patching | Managed by AWS | Manual |
| Multi-AZ | One click | Complex setup |
| Cost | Higher | Lower |
| Use case | Production | Learning / Dev |

> **Screenshot:** ![RDS created](/images/evidence/week-05/01-rds-created.png)

#### Exercise 3: Connect to RDS from EC2

```bash
# SSH into EC2 first
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Install MySQL client
sudo apt install mysql-client -y

# Connect to RDS
mysql -h <RDS-ENDPOINT> -u admin -p<password>

# Test connection
SHOW DATABASES;
SELECT VERSION();
```

RDS in a private subnet → only EC2 instances within the same VPC can connect → this is the **best practice** for production environments.

> **Screenshot:** ![RDS connected](/images/evidence/week-05/02-rds-connected.png)

#### Exercise 4: Import Schema & Sample Data

```sql
CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  description TEXT,
  image_url VARCHAR(500),
  stock INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO products (name, price, description, stock) VALUES 
  ('Gaming Laptop', 25000000, 'High-performance gaming laptop', 10),
  ('Smartphone', 15000000, 'Flagship smartphone', 25),
  ('Headphones', 2000000, 'Noise-cancelling headphones', 50);

SELECT * FROM products;
```

> **Screenshot:** ![Schema imported](/images/evidence/week-05/03-schema-imported.png)

#### Challenges Encountered

| Issue | Solution |
| :--- | :--- |
| SSH timeout even though EC2 is Running | SSH Inbound rule was mistakenly placed in Outbound rules — move it to Inbound rules |
| SSH timeout after fixing Security Group | Route table missing `0.0.0.0/0 → IGW` route — create Internet Gateway and add route |
| Permission denied (publickey) when SSH | EC2 was launched with old key pair but `.pem` file is a new key — re-launch EC2 with correct key pair |
| EC2 cannot reach internet (`curl` timeout) | Subnet had no Public IP — manually assign Elastic IP to EC2 |
| `sudo apt update` fails with Network unreachable | Internet Gateway not attached to VPC — create IGW and attach to `ecommerce-vpc` |
| ERROR 2003 when connecting to RDS | RDS was using `default` Security Group instead of `db-server-sg` — Modify RDS to change SG |
| `db-server-sg` not showing in dropdown when Modifying RDS | RDS was created in default VPC instead of `ecommerce-vpc` — delete and recreate RDS in correct VPC |
| DB Subnet Group creation failed | Only 1 subnet in 1 AZ — create additional subnet `private-subnet-1b` in `ap-southeast-2b` |
| SSL connection error using command from AWS Console | Remove `--ssl-mode=VERIFY_IDENTITY` — use simple command `mysql -h ... -u admin -p` |
| EC2 Instance Connect failed | EC2 had no Public IP — assign Elastic IP first |

### Plan for Week 6

- Create an Application Load Balancer (ALB).
- Configure Target Group and Health Check.
- Launch a second EC2 instance into `public-subnet-1b`.
- Test load balancing across 2 EC2 instances.
- Configure Auto Scaling Group.
