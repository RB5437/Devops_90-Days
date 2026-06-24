# Day 71 — Terraform Multi-Environment AWS Infrastructure 🌍
## 📅 Date: 22 June 2026
## 🎯 Topic: Terraform Basics + AWS Provider Setup + S3 Bucket + EC2 with Security Group

---

## 📚 Resources Used
- 📺 **TrainWithShubham — Terraform Multi-Environment AWS Infrastructure**
  - YouTube: https://www.youtube.com/watch?v=E_eoFRX1Fzw
- 📖 **Official Terraform Docs**: https://developer.hashicorp.com/terraform/docs
- 📖 **AWS Provider Docs**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

---

## 🏗️ Project Architecture

```
Terraform Code (Local)
        ↓
   terraform init
        ↓
   terraform plan    ← Shows what will be created
        ↓
   terraform apply   ← Actually creates on AWS
        ↓
   AWS Resources:
   ├── S3 Bucket     (rbb-multi-env)
   ├── EC2 Instance  (terra-automate — t2.micro)
   ├── Key Pair      (rbb-terra-key)
   ├── Security Group (rbb-sg — SSH port 22)
   └── Default VPC   (aws_default_vpc)
```

---

## 📁 Project File Structure

```
multi-Environment/
├── .terraform/              # Terraform plugins (auto-generated)
├── .terraform.lock.hcl      # Provider version lock file
├── main.tf                  # Main configuration
├── provider.tf              # AWS provider config
├── s3.tf                    # S3 bucket resource
├── ec2.tf                   # EC2 + Security Group + Key Pair
├── terra-key                # Private SSH key (DO NOT commit!)
├── terra-key.pub            # Public SSH key
└── terraform.tfstate        # Current state file
```

---

## 📋 provider.tf — AWS Provider Block

```hcl
# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider Block
provider "aws" {
  region = "us-east-1"
}
```

---

## 🪣 s3.tf — S3 Bucket

```hcl
resource "aws_s3_bucket" "rbb-s3-bucket" {
  #arguments
  bucket = "rbb-multi-env"
  tags = {
    Name = "rbb-multi-env"
  }
}
```

---

## 🖥️ ec2.tf — EC2 + Security Group + Key Pair

```hcl
# Key Pair
resource "aws_key_pair" "name" {
  key_name   = "rbb-terra-key"
  public_key = file("${path.module}/terra-key.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {
}

# Security Group
resource "aws_security_group" "rbb-sg" {
  name        = "allow ports"
  description = "this SG is to open ports for ec2 instance"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami             = "ami-08f44e8eca9095668"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.name.key_name
  security_groups = [aws_security_group.rbb-sg.name]

  tags = {
    Name = "terra-automate"
  }
}
```

---

## 🔑 SSH Key Generation

```bash
# Generate SSH key pair (ed25519 — more secure than RSA)
ssh-keygen

# Enter file name: terra-key
# Enter passphrase: (empty for no passphrase)

# Files created:
# terra-key      → private key (keep secret!)
# terra-key.pub  → public key (upload to AWS)
```

---

## 🚀 Terraform Commands Used Today

```bash
# Step 1 — Initialize (downloads AWS provider plugin)
terraform init

# Step 2 — Plan (dry run — shows what will be created)
terraform plan

# Step 3 — Apply (creates resources on AWS)
terraform apply
# Type: yes to confirm

# Step 4 — Verify
terraform show
```

---

## ✅ Resources Created Today

| Resource | Name | Status |
|----------|------|--------|
| S3 Bucket | rbb-multi-env | ✅ Created |
| EC2 Instance | terra-automate (t2.micro) | ✅ Running |
| Key Pair | rbb-terra-key | ✅ Created |
| Security Group | rbb-sg (SSH port 22) | ✅ Created |
| Default VPC | default | ✅ Created |

**terraform apply output:**
```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

**EC2 Instance:**
- Instance ID: `i-00dacd314fa7efb92`
- Public IP: `13.221.84.3`
- Region: `us-east-1c`
- Status: ✅ Running

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Terraform Docs | https://developer.hashicorp.com/terraform/docs |
| AWS Provider | https://registry.terraform.io/providers/hashicorp/aws/latest/docs |
| aws_instance | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance |
| aws_s3_bucket | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket |
| aws_security_group | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group |
| aws_key_pair | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair |
| terraform init | https://developer.hashicorp.com/terraform/cli/commands/init |
| terraform plan | https://developer.hashicorp.com/terraform/cli/commands/plan |
| terraform apply | https://developer.hashicorp.com/terraform/cli/commands/apply |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
