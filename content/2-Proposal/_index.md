---
title: "Proposal"
date: 2026-05-14
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## Overview

The project deploys a small e-commerce product catalog on AWS. It includes a React frontend, Spring Boot backend, MySQL database, object storage for product images, and monitoring.

## Goals

- Build an end-to-end AWS application using managed and scalable services.
- Keep the database private and expose only the required web/API entry points.
- Add logs, metrics, alarms, and cleanup steps to control operational cost.

## Problem

A small shop needs a simple product catalog that can be deployed quickly, remain secure by default, and provide enough observability for troubleshooting.

## Solution Architecture

![Architecture](/images/workshop/ecommerce-architecture.svg)

Main AWS services: VPC, EC2, RDS MySQL, S3, CloudFront, IAM, CloudWatch, SNS, and optionally ALB/Auto Scaling.

## Timeline

| Phase | Time | Deliverable |
| --- | --- | --- |
| Foundation | Week 1-4 | AWS account, S3, EC2, VPC |
| Data and app | Week 5-8 | RDS, backend API, frontend |
| DevOps | Week 9-11 | Docker, CI/CD, monitoring |
| Finalization | Week 12 | Workshop website and final report |

## Budget

The project is designed for Free Tier where possible. NAT Gateway, ALB, RDS, and CloudWatch alarms may create cost, so cleanup is mandatory after the lab.

## Risks

| Risk | Mitigation |
| --- | --- |
| Unexpected AWS cost | Use budget alerts and run cleanup after testing. |
| Public exposure of database | Place RDS in private subnets and restrict Security Group source to the app tier. |
| Hard-coded credentials | Store secrets in environment variables or AWS Secrets Manager. |
| Deployment drift | Use CloudFormation/CLI steps and document validation commands. |
