
# 🟣 Day 54 — Terraform Day 3 | Variables, Outputs, for_each, Conditionals + EC2 Project

## 📅 Date: 5 June 2026 | #90DaysOfDevOps

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| 📥 Input Variables | [developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables) |
| 📤 Output Values | [developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs) |
| 🔄 for_each | [developer.hashicorp.com/terraform/language/meta-arguments/for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) |
| 🔢 count | [developer.hashicorp.com/terraform/language/meta-arguments/count](https://developer.hashicorp.com/terraform/language/meta-arguments/count) |
| ❓ Conditionals | [developer.hashicorp.com/terraform/language/expressions/conditionals](https://developer.hashicorp.com/terraform/language/expressions/conditionals) |
| 🗂️ State Management | [developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state) |
| ☁️ aws_instance | [registry.terraform.io/.../aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| 🔑 aws_key_pair | [registry.terraform.io/.../aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| 🛡️ aws_security_group | [registry.terraform.io/.../aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| 🎥 Shubham Video | [youtube.com/watch?v=S9mohJI_R34&t=9859s](https://www.youtube.com/watch?v=S9mohJI_R34&t=9859s) |


---

## ✅ What I Learned Today

| # | Topic | Timestamp | Status |
|---|-------|-----------|--------|
| 1 | Input Variables (variable block) | [02:44:19](https://www.youtube.com/watch?v=S9mohJI_R34&t=9859s) | ✅ Done |
| 2 | Output Variables (output block) | [02:49:55](https://www.youtube.com/watch?v=S9mohJI_R34&t=10195s) | ✅ Done |
| 3 | for_each meta-argument (tomap) | [03:23:00](https://www.youtube.com/watch?v=S9mohJI_R34&t=12180s) | ✅ Done |
| 4 | count meta-argument | [03:23:00](https://www.youtube.com/watch?v=S9mohJI_R34&t=12180s) | ✅ Done |
| 5 | Conditional Expressions (ternary) | [03:46:49](https://www.youtube.com/watch?v=S9mohJI_R34&t=13609s) | ✅ Done |
| 6 | State Management — TF State file | [03:56:08](https://www.youtube.com/watch?v=S9mohJI_R34&t=14168s) | ✅ Done |
| 7 | Full EC2 Project — KeyPair + VPC + SG + EC2 | Hands-on | ✅ Done |

---

## 📥 Variables — variables.tf

```hcl
# variables.tf
# Docs: https://developer.hashicorp.com/terraform/language/values/variables

variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-091138d0f0d41ff90"
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  default     = "t3.micro"
  type        = string
}

variable "ec2_default_root_volume_size" {
  description = "The size of the root EBS volume in GB"
  default     = 10
  type        = number
}

variable "env" {
  description = "The environment (dev, staging, prod)"
  default     = "prod"
  type        = string
}
```

**Variable Types:**
| Type | Example |
|------|---------|
| string | `"us-east-1"` |
| number | `10` |
| bool | `true` |
| list | `["a", "b"]` |
| map | `{key = "value"}` |
| object | Complex structures |

---

## 📤 Outputs — output.tf

```hcl
# output.tf
# Docs: https://developer.hashicorp.com/terraform/language/values/outputs

# For single instance (count):
output "ec2_instance_public_ip" {
  value       = aws_instance.my_instance[*].public_ip
  description = "Public IP address of the EC2 instance"
}

# For for_each instance:
output "ec2_instance_public_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}

output "ec2_instance_public_dns" {
  value       = aws_instance.my_instance.public_dns
  description = "Public DNS name of the EC2 instance"
}

output "ec2_arn" {
  value       = aws_instance.my_instance.arn
  description = "ARN of the EC2 instance"
}
```

**Apply output shown:**
```
Outputs:
ec2_arn = "arn:aws:ec2:us-east-1:904352270417:instance/i-01c88cc752e4af565"
ec2_instance_public_dns = "ec2-54-225-37-192.compute-1.amazonaws.com"
ec2_instance_public_ip  = "54.225.37.192"
```

---

## 🔄 for_each vs count

### count — simple, index-based
```hcl
resource "aws_instance" "my_instance" {
  count         = 2         # creates instance[0] and instance[1]
  ami           = var.ami_id
  instance_type = var.instance_type
}
# Access: aws_instance.my_instance[0].public_ip
```

### for_each — map-based, unique keys
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
resource "aws_instance" "my_instance" {
  for_each = tomap({
    "instance1" = "t2.micro",   # key = value
    "instance2" = "t3.micro"
  })
  ami           = var.ami_id
  instance_type = each.value    # t2.micro or t3.micro
  tags = {
    Name = each.key             # "instance1" or "instance2"
  }
}
# Access: aws_instance.my_instance["instance1"].public_ip
```

**for_each diagram:**
```
for_each = tomap({
  key   = value
  key2  = value2
})
→ Creates one resource per key
→ each.key   = the key name
→ each.value = the value
```

---

## ❓ Conditional Expression (Ternary)
📖 Docs: https://developer.hashicorp.com/terraform/language/expressions/conditionals

```hcl
# Syntax: condition ? true_val : false_val

# Example — volume size doubles in prod:
volume_size = var.env == "prod" ? var.ec2_default_root_volume_size * 2 : var.ec2_default_root_volume_size

# If env == "prod"  → volume = 10 * 2 = 20GB
# If env != "prod"  → volume = 10GB
```

---

## 🗂️ TF State — How Terraform Tracks Infrastructure
📖 Docs: https://developer.hashicorp.com/terraform/language/state

```
Terraform .tf files
    │
    ├── deploy (apply/create/destroy/modify)
    │
    └── AWS (running: 2 EC2 instances)
              ↑
         TF State File ← records what exists
         (terraform.tfstate)
```

**State file purpose:**
- Maps `.tf` code to real cloud resources
- Used by `terraform plan` to know what changed
- Contains resource IDs, IPs, ARNs
- Must never be manually edited

---

## 💻 Today's EC2 Project — Full Code

### Project structure:
```
Day-54-Terraform/
├── ec2.tf           → KeyPair + VPC + SecurityGroup + EC2
├── variables.tf     → all input variables
├── output.tf        → public IP, DNS, ARN outputs
├── providers.tf     → AWS provider
├── terraform.tf     → required_providers
├── terra-key-ec2    → SSH private key (generated locally)
└── terra-key-ec2.pub → SSH public key (uploaded to AWS)
```

### ec2.tf:
```hcl
# Key Value pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC Default
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Inbound and outbound rules for your instance Security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# EC2 instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    "instance1" = "t2.micro",
    "instance2" = "t3.micro"
  })
  ami                    = var.ami_id
  instance_type          = each.value
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prod" ? var.ec2_default_root_volume_size * 2 : var.ec2_default_root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "each.key"
  }
}
```

---

## 🎯 Results — AWS Console Verified

| Resource | Created | Details |
|----------|---------|---------|
| Key Pair | ✅ | terra-key-ec2 (ed25519) |
| Security Group | ✅ | automate-sg — ports 22, 80 open |
| EC2 Instance | ✅ | terra-automat... Running t3.micro — 54.145.88.4 |
| VPC | ✅ | Default VPC — vpc-0f0637ea8d32462bd |

**terraform apply output:**
```
Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:
ec2_arn                = "arn:aws:ec2:us-east-1:904352270417:instance/i-01c88cc752e4af565"
ec2_instance_public_dns = "ec2-54-225-37-192.compute-1.amazonaws.com"
ec2_instance_public_ip  = "54.225.37.192"
```

---

## 🗺️ Progress Tracker

| Topic | Days | Status |
|-------|------|--------|
| Terraform Day 1 — Intro + Setup | Day 52 | ✅ Done |
| Terraform Day 2 — HCL + Local file + S3 | Day 53 | ✅ Done |
| **Terraform Day 3 — Variables + for_each + EC2** | Day 54 | ✅ Today |
| Terraform Day 4 — Remote Backend + Modules | Day 55 | ⬜ |
| Terraform Day 5 — Final Project EKS | Day 56 | ⬜ |

---

## 📂 My GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)
