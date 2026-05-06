# 🚀 Day X – AWS RDS, EC2, DynamoDB & Lambda

## 📌 Overview

Today I worked on core AWS database and compute services.
This includes:

* Relational DB setup using RDS
* Connecting EC2 with RDS
* NoSQL database using DynamoDB
* Serverless computing using AWS Lambda
* Debugging real-world errors (boto3 & DynamoDB)

---

## 🧠 Key Concepts

### 🔹 Amazon RDS

📘 Official Docs: https://docs.aws.amazon.com/rds/

* Managed relational database service
* Supports MySQL, PostgreSQL, MariaDB, Oracle, SQL Server
* Automated backups, patching, scaling

✅ What I did:

* Created MySQL RDS instance
* Selected **Free Tier**
* Configured:

  * DB instance identifier
  * Username & password
  * Storage
* Enabled connectivity with EC2

---

### 🔹 EC2 ↔ RDS Connection

📘 EC2 Docs: https://docs.aws.amazon.com/ec2/
📘 RDS Connectivity: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_CommonTasks.Connect.html

* EC2 used as a client to connect to RDS
* Connection happens via:

  * **Security Groups**
  * Port **3306 (MySQL)**

✅ What I learned:

* Allow inbound rule in RDS SG from EC2 SG
* Private connection inside VPC
* Avoid public access for security

---

### 🔹 DynamoDB

📘 Official Docs: https://docs.aws.amazon.com/dynamodb/

* Fully managed NoSQL database
* Key-value + document based
* Ultra fast and scalable

✅ Table Created:

```json
{
  "TableName": "learners",
  "PrimaryKey": "learner_id (String)"
}
```

✅ Features:

* On-demand capacity
* No schema required
* High availability

---

### 🔹 AWS Lambda

📘 Official Docs: https://docs.aws.amazon.com/lambda/

* Serverless compute service
* Run code without managing servers

✅ What I implemented:

* Python Lambda function
* Connected Lambda with DynamoDB using boto3

---

## ⚠️ Error Faced & Fix (Important for Interview)

### ❌ Error:

```
Missing required parameter in input: "Key"
Unknown parameter in input: "key"
```

### 🔍 Root Cause:

* Case-sensitive parameter mistake in boto3

### 📘 Boto3 Docs:

https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html

### ✅ Fix:

```python
response = table.get_item(
    Key={'learner_id': "1"}  # Correct (Capital K)
)
```

💡 Lesson:

* AWS SDK parameters are **case-sensitive**
* Always verify from documentation

---

## 🔄 Architecture Flow

```
User → Lambda → DynamoDB
           ↓
          EC2 → RDS (MySQL)
```

---

## 🛠️ Commands / Code Snippet

### Lambda Code:

```python
import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('learners')

    response = table.get_item(
        Key={'learner_id': "1"}
    )

    return {
        'statusCode': 200,
        'body': json.dumps(response.get('Item'))
    }
```

---

## 🎯 Interview Questions

1. Difference between RDS and DynamoDB?
2. How EC2 connects to RDS securely?
3. What is a Security Group?
4. What is serverless?
5. What is partition key in DynamoDB?
6. Explain boto3 usage in Lambda
7. Difference between Scan and Query in DynamoDB

---

## 🔥 Key Takeaways

* RDS = Structured data (SQL)
* DynamoDB = Unstructured / flexible data (NoSQL)
* Lambda = Serverless execution
* Security Groups = Firewall control
* Small mistakes (like `Key`) can break production systems

---

## 📅 Progress Tracker

✔ RDS Setup
✔ EC2 Connection
✔ DynamoDB Table
✔ Lambda Integration
✔ Debugging

---

## 🚀 Next Steps

* Connect API Gateway with Lambda
* Perform CRUD operations
* Add IAM roles with least privilege
* Deploy real-world mini project

---

## 🙌 Author

Learning AWS DevOps step by step 💪
