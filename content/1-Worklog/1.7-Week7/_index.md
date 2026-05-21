---
title: "Week 7 Worklog"
date: 2026-05-14
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

## Week 7 Objectives

- Create a Spring Boot project (Maven).
- Implement REST API: product CRUD.
- Connect to MySQL RDS.
- Implement product image upload to S3.
- Deploy the application to EC2.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Initialize Spring Boot project via Spring Initializr. Configure `application.properties` to connect to RDS | 01/06/2026 | 01/06/2026 | [Spring Initializr](https://start.spring.io) · [AWS SDK for Java – S3](https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/examples-s3.html) |
| Tue | Implement Product entity, JPA Repository, Service, Controller. Test CRUD API with Postman | 02/06/2026 | 02/06/2026 | [Application Deployment – Lab 000005](https://000005.awsstudygroup.com/5-deploy-app/) |
| Wed | **S3 Upload hands-on:** Implement image upload endpoint to S3. Configure IAM Role for EC2 | 03/06/2026 | 03/06/2026 | [Starting with Amazon S3 – Lab 000057](https://000057.awsstudygroup.com) |
| Thu | Build JAR, copy to EC2, install Java 17, run the application. Test API from Postman via Public IP | 04/06/2026 | 04/06/2026 | [Configure EC2 Instance – Lab 000015](https://000015.awsstudygroup.com/5-configure-ec2/) |
| Fri | Test all API endpoints end-to-end. Review, write worklog report. Plan Week 8 | 05/06/2026 | 05/06/2026 | [Test Application – Lab 000015](https://000015.awsstudygroup.com/6-docker-image/2-test-app/) |

### Week 7 Results

- Spring Boot project initialized and connected to RDS MySQL successfully.
- Full CRUD REST API completed: 6 endpoints for the `products` resource.
- Product image upload to S3 working — returns a public URL.
- Application deployed successfully on EC2 and accessible via Public IP.

#### Exercise 1: Initialize Spring Boot Project

Created the project at [start.spring.io](https://start.spring.io) with the following configuration:

```text
Spring Initializr:
- Project: Maven
- Language: Java 17
- Dependencies:
    Spring Web
    Spring Data JPA
    MySQL Driver
    AWS SDK S3
    Lombok
```

Configured `application.properties`:

```properties
# Database — RDS
spring.datasource.url=jdbc:mysql://<RDS-ENDPOINT>:3306/ecommerce
spring.datasource.username=admin
spring.datasource.password=${DB_PASSWORD}
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# AWS S3
aws.s3.bucket=simple-ecommerce-fe-yourname
aws.region=ap-southeast-1
```

**Security note:** Never hardcode passwords in `application.properties` — use the environment variable `${DB_PASSWORD}` or AWS Secrets Manager instead.

> **Screenshot:** ![Spring Initializr setup](/images/evidence/week-07/00-spring-init.png)

#### Exercise 2: Product CRUD API

Implemented using a 3-layer architecture (Entity → Repository → Service → Controller).

The Product entity maps directly to the `products` table created in Week 5. REST API endpoints:

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| GET | `/api/products` | Get all products |
| GET | `/api/products/{id}` | Get a single product by ID |
| POST | `/api/products` | Create a new product |
| PUT | `/api/products/{id}` | Update a product |
| DELETE | `/api/products/{id}` | Delete a product |
| POST | `/api/products/{id}/image` | Upload product image to S3 |

Spring Boot data flow:

```text
HTTP Request
    ↓
Controller  (@RestController)     — receives request, returns JSON response
    ↓
Service     (@Service)            — business logic
    ↓
Repository  (JpaRepository)       — interacts with RDS MySQL
    ↓
RDS MySQL (private subnet)
```

>**GET**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-GET.png)
>**POST**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-POST.png)
>**GET ID**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-GETID.png)
>**PUT**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-PUT.png)
>**DELETE**
>**Screenshot:** ![Postman API test](/images/evidence/week-07/01-api-postman-test-DELETE.png)

#### Exercise 3: Product Image Upload to S3

Added AWS SDK dependency to `pom.xml`:

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>s3</artifactId>
    <version>2.25.0</version>
</dependency>
```

Created IAM Role `ec2-s3-role` with `AmazonS3FullAccess` policy and attached it to the EC2 instance — no access keys stored in code.

The upload endpoint (`POST /api/products/{id}/image`) accepts a `MultipartFile`, uploads it to the S3 bucket, updates `image_url` in RDS, and returns the public URL:

```text
https://simple-ecommerce-fe-yourname.s3.ap-southeast-1.amazonaws.com/images/<filename>
```

> **Screenshot:** ![S3 image upload](/images/evidence/week-07/02-s3-image-upload.png)
>
> **Screenshot:** ![S3 image upload](/images/evidence/week-07/03-s3-image-upload.png)
>
> **Screenshot:** ![S3 image upload](/images/evidence/week-07/04-s3-image-upload.png)

#### Exercise 4: Build & Deploy to EC2

```bash
# Build JAR on local machine
./mvnw clean package -DskipTests

# Copy JAR to EC2
scp -i "aws-learning-key.pem" \
    target/ecommerce-0.0.1-SNAPSHOT.jar \
    ubuntu@<EC2-PUBLIC-IP>:~/

# SSH into EC2
ssh -i "aws-learning-key.pem" ubuntu@<EC2-PUBLIC-IP>

# Install Java 17 on EC2
sudo apt update
sudo apt install openjdk-17-jre -y
java -version

# Set environment variable and run application
export DB_PASSWORD=<your-rds-password>
java -jar ecommerce-0.0.1-SNAPSHOT.jar
```

Added inbound rule TCP port `8080` → `0.0.0.0/0` to the EC2 Security Group so Postman can reach the API.

Test from Postman:

```text
GET http://<EC2-PUBLIC-IP>:8080/api/products
```

> **Screenshot:** ![API running on EC2](/images/evidence/week-07/02-api-running-ec2.png)
>
> **Screenshot:** ![API test from Postman via EC2 IP](/images/evidence/week-07/03-api-postman-ec2.png)

### Challenges & Solutions

| Issue / Challenge | Solution |
| :--- | :--- |
| 500 Internal Server Error and risk of orphaned files on S3 during image upload | Refactored the logic sequence in the Controller: Validated `Product ID` existence in the database first using `service.getById(id)` before executing the S3 API call. |
| `Connection timed out` when connecting to RDS from local environment | Resolved network restrictions by enabling `DNS resolution` and `DNS hostnames` in the VPC, setting RDS to `Publicly accessible`, and allowing port 3306 for `My IP` in the Security Group's inbound rules. |
| Application failed to connect to DB located in a Private Subnet | Utilized SSH Tunneling (Bastion Host): Opened port 22 on EC2, ran `ssh -L 3307:<RDS-Endpoint>:3306` to establish a secure tunnel, and pointed the Spring Boot datasource to `127.0.0.1:3307`. |
| `Public Key Retrieval is not allowed` error in MySQL 8 | Modified `application.properties` by appending `allowPublicKeyRetrieval=true` to the JDBC URL, allowing the driver to retrieve the public key securely. |
| `scp` command returned `No such file or directory` error | Terminal was pointing to the wrong working directory. Used the `cd` command to navigate to the project's root directory before executing the JAR file copy command. |
| Failed to execute Linux commands (`sudo apt update`) on Windows PowerShell | Command-line environment confusion. Needed to successfully SSH into the EC2 instance using `ssh -i <file.pem> ubuntu@<EC2-IP>` before executing Linux package installation commands. |
| `Access Denied` error when uploading to S3 from EC2 | Avoided hardcoding AWS Access Keys. Created an IAM Role `ec2-s3-role` with `AmazonS3FullAccess` permission and attached it directly to the EC2 instance. |
| Port 8080 was inaccessible from the internet via Postman | Accessed the EC2 Security Group and added an Inbound rule: Type Custom TCP, Port `8080`, and Source `0.0.0.0/0` (Anywhere-IPv4). |
| Spring Boot application terminated immediately upon closing the SSH Terminal | Deployed the application as a background process using the `nohup` command: `nohup java -jar ecommerce-0.0.1-SNAPSHOT.jar > app.log 2>&1 &` |

### Plan for Week 8

- Dockerize the Spring Boot application (write a Dockerfile).
- Build a Docker image and push it to Amazon ECR.
- Run the container on EC2 instead of the raw JAR.
- Study Docker Compose to run app + MySQL together locally.
