---
title: "Week 2 Worklog"
date: 2026-04-27
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

## Week 2 Objectives

- Master S3 fundamentals: bucket, object, storage classes.
- Understand ACL, Bucket Policy, and Public Access settings.
- Deploy Static Website Hosting on S3.
- Manage object versioning & lifecycle.

### Tasks Planned for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Create an S3 Bucket, study core concepts: object, storage class, ACL | 27/04/2026 | 27/04/2026 | [Starting with Amazon S3](https://000057.awsstudygroup.com) |
| Tue | Configure Static Website Hosting. Upload static HTML files to S3 | 28/04/2026 | 28/04/2026 | [Enable Static Website – Lab 000057](https://000057.awsstudygroup.com/3-staticwebsite/) |
| Wed | **Bucket Policy hands-on:** Configure Public Read, understand the difference between ACL and Bucket Policy | 29/04/2026 | 29/04/2026 | [S3 Security Best Practices](https://000069.awsstudygroup.com) |
| Thu | Enable Versioning. Re-upload files and restore an old version. Study Lifecycle rules | 30/04/2026 | 30/04/2026 | [Bucket Versioning – Lab 000057](https://000057.awsstudygroup.com/8-versioning/) |
| Fri | Review and consolidate Week 2 knowledge. Write worklog report. Plan Week 3 | 01/05/2026 | 01/05/2026 | |

### Week 2 Results

- Static website running live on S3: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`
- Bucket versioning successfully enabled.
- Product images accessible via public URL.
- Clear understanding of the difference between ACL and Bucket Policy.

#### Exercise 1: Create an S3 Bucket

Created a bucket named `demo-bucket-phamducthanh` (bucket names must be globally unique):

- Region: `ap-southeast-2`
- Block all public access: **OFF** (required to host a static site)
- Versioning: **Enabled**

```bash
# Or create via AWS CLI:
aws s3 mb s3://demo-bucket-phamducthanh --region ap-southeast-2
```

> **Screenshot:** ![S3 bucket created](/images/evidence/week-02/01-s3-bucket-created.png)

#### Exercise 2: Upload Static HTML Files & Configure Static Website Hosting

Created 2 basic HTML files and uploaded them to the S3 bucket via the Console:

```html
<!-- index.html -->
<!DOCTYPE html>
<html>
<head><title>E-Commerce Mini</title></head>
<body>
  <h1>Pham Duc Thanh</h1>
  <p>Hosted on AWS S3</p>
  <a href="products.html">View Products</a>
</body>
</html>
```

Navigate to bucket → Properties → Static website hosting:

- Enable: ✅
- Index document: `index.html`
- Error document: `error.html`

Endpoint URL: `http://demo-bucket-phamducthanh.s3-website-ap-southeast-2.amazonaws.com`

> **Screenshot:** ![Files uploaded](/images/evidence/week-02/02-files-uploaded.png)
>
> **Screenshot:** ![Static hosting config](/images/evidence/week-02/03-static-hosting-config.png)

#### Exercise 3: Configure Bucket Policy (Public Read)

Added a policy to allow public read access to all objects in the bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::demo-bucket-phamducthanh/*"
    }
  ]
}
```

Mastered key S3 concepts:

- **Bucket:** Container for objects (globally unique name)
- **Object:** File + metadata; the key is the full path
- **ACL:** Access Control List — controls who can read/write
- **Bucket Policy:** JSON policy applied at the entire bucket level
- **Presigned URL:** Temporary URL to share a private object

> **Screenshot:** ![Bucket policy](/images/evidence/week-02/04-bucket-policy.png)

#### Exercise 4: Upload Product Images, Enable Versioning & Test Access

Uploaded 3 product images into the `images/` folder. Tested direct URL access:

```text
https://demo-bucket-phamducthanh.s3.ap-southeast-2.amazonaws.com/images/avt.jpg
```

With versioning enabled, re-uploading an existing file does **not overwrite** it — a new version is created instead. Previous versions can be restored at any time.

> **Screenshot:** ![Website live](/images/evidence/week-02/05-website-live.png)
>
> **Screenshot:** ![Product images accessible](/images/evidence/week-02/06-product-images-accessible.png)

#### Challenges Encountered

| Issue | Resolution |
| :--- | :--- |
| Website showed "403 Forbidden" despite being public | Forgot to turn off "Block Public Access" — must disable it before adding the Policy |
| Images uploaded but URL returned 403 | The Bucket Policy applies to `/*`, so images inside the `images/` folder are still covered |
| Bucket name was rejected | Name must be lowercase, no special characters, globally unique — append a name or number to the end |

### Plan for Week 3

- Study EC2: launch instance, AMI, instance types.
- Configure Security Groups (inbound/outbound rules).
- SSH into EC2 from local machine.
- Install Nginx web server on EC2.
  