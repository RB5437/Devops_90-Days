– S3, IAM & AWS CLI
Welcome to Day 3 of the 7 Days of AWS Challenge 🚀
Today, you’ll explore how to store and protect data on AWS, manage user access securely, and perform tasks from the Command Line Interface (CLI) like a true Cloud Engineer.

 Concepts to Learn
 What is Amazon S3?
Amazon Simple Storage Service (Amazon S3) is a scalable object storage service that allows you to store and retrieve data from anywhere on the internet.
Common use cases include:

Backup & Restore
Hosting Static Websites
Data Archiving & Content Delivery
 S3 Documentation → Click Here

 What is IAM?
Identity and Access Management (IAM) is AWS’s service for controlling access to resources securely.
It lets you create users, groups, and roles with defined permissions.

Key Components:

Users – Individual accounts
Groups – Collection of users with common permissions
Roles – Temporary credentials for apps or services
Policies – JSON documents defining permissions
 IAM Documentation → Click Here

 What is AWS CLI?
AWS Command Line Interface (CLI) is a unified tool that lets you manage AWS services from your terminal instead of the console.

With CLI, you can:

Launch EC2 instances
Upload data to S3
Configure IAM roles and permissions
 AWS CLI Documentation → Click Here

 Tasks for Day 3
 Task 1: Secure Your S3 Bucket
Create a private S3 bucket in AWS.
Modify the bucket policy so you can access its contents securely without making it public.
 This helps you understand how to secure your S3 storage using policies.

 Task 2: Configure AWS CLI
Install and configure the AWS CLI on your Ubuntu or local machine using your AWS credentials.
 Task 3: Launch EC2 Using CLI
Create an EC2 instance using AWS CLI.
 Resource: Creating EC2 Using AWS CLI (Blog)

 Task 4: IAM Access Setup for a New Team Member
Scenario:
You’re an IT admin at GlobalTech Inc. and a new team member, Alex, joins your team.

You must configure IAM to provide specific access rights:

View EC2 instances (monitor only).
Create S3 buckets (no EC2 modification rights).
Document your steps and write a short LinkedIn blog titled:




