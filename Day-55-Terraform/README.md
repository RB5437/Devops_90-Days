# 🟣 Day 55 — Terraform Day 4 | Remote Backend + State Locking + Workspaces + Modules

## 📅 Date: 6 June 2026 | #90DaysOfDevOps

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| 🗂️ Remote Backends | [developer.hashicorp.com/terraform/language/backend](https://developer.hashicorp.com/terraform/language/backend) |
| ☁️ S3 Backend | [developer.hashicorp.com/terraform/language/backend/s3](https://developer.hashicorp.com/terraform/language/backend/s3) |
| 🔒 State Locking | [developer.hashicorp.com/terraform/language/state/locking](https://developer.hashicorp.com/terraform/language/state/locking) |
| 🏷️ Workspaces | [developer.hashicorp.com/terraform/language/state/workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) |
| 📦 Modules | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| 🔌 Terraform Registry | [registry.terraform.io](https://registry.terraform.io) |
| 🌐 terraform import | [developer.hashicorp.com/terraform/cli/commands/import](https://developer.hashicorp.com/terraform/cli/commands/import) |
| 📥 AWS VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |


---

## ✅ What I Learned Today

| # | Topic | Timestamp | Status |
|---|-------|-----------|--------|
| 1 | State Management + terraform import | [03:56:08](https://www.youtube.com/watch?v=S9mohJI_R34&t=14168s) | ✅ Done |
| 2 | Remote State Backend — S3 | [04:26:19](https://www.youtube.com/watch?v=S9mohJI_R34&t=15979s) | ✅ Done |
| 3 | State Locking — DynamoDB | [04:33:21](https://www.youtube.com/watch?v=S9mohJI_R34&t=16401s) | ✅ Done |
| 4 | Workspaces — Dev/Staging/Prod | [05:01:26](https://www.youtube.com/watch?v=S9mohJI_R34&t=18086s) | ✅ Done |
| 5 | Modules — VPC module from Registry | [05:29:00](https://www.youtube.com/watch?v=S9mohJI_R34&t=19740s) | ✅ Done |
| 6 | Full EC2 + Remote Backend + 2 Instances | Hands-on | ✅ Done |

---

## 🗂️ State Management + terraform import

### TF State Flow:
```
Terraform .tf          deploy           AWS
  (code)    ──────────────────────────→ Running: 2 EC2
                                            ↑
                                       TF State File
                                       (tracks state)
                   #1 → Commit GitHub ←─┘
```

### terraform import — bring existing infra into state:
```bash
# Import existing EC2 instance
terraform import aws_instance.my_new_instance i-0f856b753d1bd22b1

# Import existing Key Pair
terraform import aws_key_pair.my_key key-0df156aa2f3db2296

# Output:
# Import successful!
# The resources are now in your Terraform state
# and will be managed by Terraform.
```

**Why import?**
- Infra created manually in console → bring under Terraform management
- Existing resources → manage with IaC going forward

---

## 🔄 Problem: State Conflict (Without Remote Backend)

```
Shubham's diagram:
                    count=2           count=3
Person 1 → .tf ──────────────→  .tfstate (state merged)
Person 2 → .tf ──────────────→  .tfstate

#2 → State Conflict!  ← 2 people working = CONFLICT
     [Comm lead]      ← need team lead to resolve
```

**Solution → Remote Backend!**

---

## ☁️ Remote Backend — S3 + DynamoDB

```
Remote Backend diagram:
                     [Remote Backend]
Person 1 → ──────→ S3 (.tfstate) ──→ DynamoDB (LockID)
Person 2 → ──────→ S3 (.tfstate) ──→ DynamoDB (LockID)

S3 = stores terraform.tfstate file
DynamoDB = state locking (one person at a time)
```

### Step 1 — Create remote-infra (S3 + DynamoDB):

**remote-infra/s3.tf:**
```hcl
resource "aws_s3_bucket" "remote_s3_bucket" {
  bucket = "rbb-remote-s3-bucket-1"
  tags = {
    Name = "rbb-remote-s3-bucket-1"
  }
}
```

**remote-infra/dynamodb.tf:**
```hcl
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "rbb-remote-dynamodb-table-1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "rbb-remote-dynamodb-table-1"
  }
}
```

```bash
cd remote-infra
terraform init && terraform apply
# Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
# ✅ S3: rbb-remote-s3-bucket-1
# ✅ DynamoDB: rbb-remote-dynamodb-table-1 (LockID)
```

### Step 2 — Configure backend in main terraform.tf:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "rbb-remote-s3-bucket-1"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = "true"   # modern — replaces dynamodb_table
  }
}
```

> ⚠️ Note: `dynamodb_table` is deprecated. Use `use_lockfile = "true"` instead.

```bash
terraform init
# Successfully configured the backend "s3"!
# Terraform will automatically use this backend.
```

### Result — tfstate stored in S3:
```
S3 bucket: rbb-remote-s3-bucket-1
  └── terraform.tfstate  (16.3 KB, June 6, 2026)

DynamoDB: rbb-remote-dynamodb-table-1
  └── LockID: rbb-remote-s3-bucket... (lock entry when applying)
```

---

## 🏷️ Workspaces — Dev/Staging/Prod

```
Workspace diagram:
Person → laptop/workstation

Same .tf code → Dev AWS environment
             → Prod AWS environment
             → Stg AWS environment

Like git branches — same code, different state!
```

```bash
# List workspaces
terraform workspace list
# * default

# Create new workspace
terraform workspace new dev
# Created and switched to workspace "dev"!
# Workspaces isolate their state — terraform plan
# will not see any existing state for this config.

# Switch workspace
terraform workspace select default
# Switched to workspace "default".

# Show current
terraform workspace show
```

---

## 📦 Modules — VPC from Terraform Registry

```
Modules = Reusable groups of resources
Like functions in programming!
```

**vpc.tf — using official VPC module:**
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-auto-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
```

```bash
terraform init
# Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 6.6.1 for vpc...
# Terraform has been successfully initialized!

terraform plan
# Plan: 29 to add, 0 to change, 0 to destroy.
# Creates: VPC, subnets, route tables, NAT gateway, VPN gateway...
```

---

## 💻 Full EC2 Project Results

```
terraform apply
# Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
# ✅ Releasing state lock — state saved to S3!

Outputs:
ec2_instance_public_ip = [
  "54.198.74.86",    ← instance1 (t2.micro)
  "13.216.255.196",  ← instance2 (t3.micro)
]
```

**Nginx working on both instances:**
- http://54.198.74.86 → "Hello from Terraform on Ubuntu!" ✅
- http://13.216.255.196 → "Hello from Terraform on Ubuntu!" ✅

**terraform state list:**
```
aws_default_vpc.default
aws_instance.my_instance["instance1"]
aws_instance.my_instance["instance2"]
aws_key_pair.my_key_pair
aws_security_group.my_security_group
```

---

## 📁 Project Structure

```
Day-55-Terraform/
├── remote-infra/          ← Step 1: Create backend infra
│   ├── s3.tf              ← S3 bucket for tfstate
│   ├── dynamodb.tf        ← DynamoDB for state locking
│   ├── provider.tf
│   └── terraform.tf
│
└── terraform/             ← Step 2: Main project
    ├── ec2.tf             ← KeyPair + SG + EC2 (for_each)
    ├── vpc.tf             ← VPC module from registry
    ├── variables.tf
    ├── output.tf
    ├── providers.tf
    ├── terraform.tf       ← backend "s3" configured here
    └── install_nginx.sh
```

---

## 🗺️ Progress Tracker

| Topic | Days | Status |
|-------|------|--------|
| Terraform Day 1 — Intro + Setup | Day 52 | ✅ Done |
| Terraform Day 2 — HCL + S3 | Day 53 | ✅ Done |
| Terraform Day 3 — Variables + EC2 | Day 54 | ✅ Done |
| **Terraform Day 4 — Remote Backend + Workspaces + Modules** | Day 55 | ✅ Today |
| Terraform Day 5 — Final Project EKS | Day 56 | ⬜ |

---

## 📂 My GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)
