 S3, IAM & AWS CLI

Welcome to Day 3 of the AWS learning challenge.  
Today focuses on storing data securely, managing access, and automating AWS tasks using CLI.

---

## Overview

In this module, you will learn:

- Amazon S3 (Storage Service)
- IAM (Access Control)
- AWS CLI (Command Line Tool)

These are core services used in real-world AWS environments.

---

## Amazon S3 (Simple Storage Service)

Amazon S3 is a scalable object storage service used to store and retrieve data from anywhere.

### Key Features:
- Highly durable (99.999999999%)
- Scalable storage
- Secure with bucket policies and IAM

### Use Cases:
- Backup & Restore
- Static Website Hosting
- Data Archiving
- Media storage

### Interview Points:
- S3 is object storage (not block storage)
- Data is stored in **buckets**
- Access controlled via **bucket policies & IAM**

---

## IAM (Identity and Access Management)

IAM is used to securely control access to AWS resources.

### Key Components:

- **Users** → Individual identities  
- **Groups** → Collection of users  
- **Roles** → Temporary access (used by services)  
- **Policies** → JSON permissions  

### Best Practice:
- Follow **Principle of Least Privilege**

### Interview Points:
- Authentication = Who you are  
- Authorization = What you can access  
- IAM is global service

---

## AWS CLI (Command Line Interface)

AWS CLI is a tool to interact with AWS services using terminal commands.

### Key Uses:
- Automate tasks
- Manage resources faster
- Useful in DevOps & scripting

### Example Commands:

```bash
aws configure
aws s3 ls
aws ec2 describe-instances
