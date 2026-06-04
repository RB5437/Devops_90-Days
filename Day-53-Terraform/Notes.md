# 📝 Day 53 — Terraform Notes (HCL Syntax + Workflow)

## 🔗 Quick Reference Links

| Topic | Official Doc |
|-------|-------------|
| HCL Syntax | [developer.hashicorp.com/terraform/language/syntax/configuration](https://developer.hashicorp.com/terraform/language/syntax/configuration) |
| Resource Blocks | [developer.hashicorp.com/terraform/language/resources/syntax](https://developer.hashicorp.com/terraform/language/resources/syntax) |
| Provider Config | [developer.hashicorp.com/terraform/language/providers/configuration](https://developer.hashicorp.com/terraform/language/providers/configuration) |
| Variables | [developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables) |
| Outputs | [developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs) |
| Core Workflow | [developer.hashicorp.com/terraform/intro/core-workflow](https://developer.hashicorp.com/terraform/intro/core-workflow) |
| State File | [developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state) |
| AWS S3 Resource | [registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| Local File Resource | [registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |

---

## 1. 📁 Terraform File Extension

```
Programming Language  →  File Extension
─────────────────────────────────────────
Python                →  .py
Java                  →  .java
C++                   →  .cpp
Terraform (HCL)       →  .tf   ← HashiCorp Configuration Language
```

**Common .tf files in a project:**
```
main.tf         → main resources (EC2, S3, VPC...)
provider.tf     → cloud provider config (AWS, GCP...)
terraform.tf    → terraform block + required_providers
variables.tf    → input variables
outputs.tf      → output values
terraform.tfvars → variable values
```

---

## 2. 🧱 HCL Block Syntax — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/syntax/configuration

### Generic syntax:
```
<block_type> "<resource_type>" "<resource_name>" {
  argument_key = "argument_value"
  argument_key = value
}
```

### Block anatomy explained:
```hcl
resource "aws_instance" "my_instance" {
│        │              │              │
│        │              │              └── { arguments }
│        │              └── resource name (YOUR label — can be anything)
│        └── resource type (from AWS provider)
└── block type (resource, variable, output, provider...)
```

### Block = Variable analogy:
```
block     = variable (container)
resource  = type of block
variable  = input block
output    = output block
```

---

## 3. 🧩 All Block Types Explained
📖 Docs: https://developer.hashicorp.com/terraform/language

### terraform block
```hcl
# Configures Terraform itself
# Docs: https://developer.hashicorp.com/terraform/language/terraform
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

### provider block
```hcl
# Configures the cloud provider
# Docs: https://developer.hashicorp.com/terraform/language/providers/configuration
provider "aws" {
  region = "us-east-1"
}
```

### resource block
```hcl
# Creates actual infrastructure
# Docs: https://developer.hashicorp.com/terraform/language/resources/syntax
resource "aws_s3_bucket" "my_devops_bucket" {
  bucket = "devops-terraform-bucket-172313999-2026"
}
```

### variable block
```hcl
# Input variables — parameterize your config
# Docs: https://developer.hashicorp.com/terraform/language/values/variables
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

### output block
```hcl
# Output values after terraform apply
# Docs: https://developer.hashicorp.com/terraform/language/values/outputs
output "bucket_name" {
  value = aws_s3_bucket.my_devops_bucket.bucket
}
```

### locals block
```hcl
# Local computed values
# Docs: https://developer.hashicorp.com/terraform/language/values/locals
locals {
  env  = "production"
  name = "myapp-${local.env}"
}
```

---

## 4. 🔄 Terraform Workflow — Detailed
📖 Docs: https://developer.hashicorp.com/terraform/intro/core-workflow

```
WRITE           PLAN              APPLY
  │               │                 │
main.tf     terraform plan    terraform apply
  │           (dry run)         (real infra)
  │               │                 │
  │         Shows: + create    Creates infra
  │               ~ update     Updates state
  │               - destroy    terraform.tfstate
  │
terraform init (first step — downloads providers)
```

### What each command does:

**terraform init**
```
- Downloads provider plugins (.terraform/ folder)
- Creates .terraform.lock.hcl (dependency lock file)
- Initializes backend
- Run whenever: new project OR provider version change
- Docs: https://developer.hashicorp.com/terraform/cli/commands/init
```

**terraform validate**
```
- Checks HCL syntax — finds typos, missing arguments
- Does NOT connect to cloud — just checks code
- Fast — run before plan
- Docs: https://developer.hashicorp.com/terraform/cli/commands/validate
```

**terraform plan**
```
- Dry run — shows what WILL happen without doing it
- + create  → new resource will be created
- ~ update  → existing resource will be modified
- - destroy → resource will be deleted
- Plan: 1 to add, 0 to change, 0 to destroy
- Docs: https://developer.hashicorp.com/terraform/cli/commands/plan
```

**terraform apply**
```
- Actually creates/updates/destroys infrastructure
- Shows plan first, asks "Enter a value: yes"
- Creates terraform.tfstate after success
- Docs: https://developer.hashicorp.com/terraform/cli/commands/apply
```

---

## 5. 🗂️ State File — terraform.tfstate
📖 Docs: https://developer.hashicorp.com/terraform/language/state

```
terraform.tfstate = Terraform's database of what exists

After terraform apply:
  - Records every resource created
  - Stores resource IDs, attributes, metadata
  - Used for: plan (compare desired vs actual)

terraform.tfstate.backup = previous state (auto-created)
```

**Important:**
```
NEVER manually edit terraform.tfstate ❌
NEVER delete terraform.tfstate ❌
Store in S3 (remote backend) for team use ✅
```

---

## 6. 🔑 AWS Credentials — How Terraform Authenticates
📖 Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

```bash
# Method 1: aws configure (most common)
aws configure
# Stores in ~/.aws/credentials

# Method 2: Environment variables
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG"
export AWS_DEFAULT_REGION="us-east-1"

# Verify who you are
aws sts get-caller-identity
# Returns: UserId, Account, Arn
```

**Today's output:**
```json
{
  "UserId": "AIDA5FD4YRBI6GHLN5ZTC",
  "Account": "904352270417",
  "Arn": "arn:aws:iam::904352270417:user/terraform-admin"
}
```

---

## 7. 🎯 Interview Questions — Terraform Day 2

**Q1: What is HCL?**
HashiCorp Configuration Language — the language Terraform uses to write .tf files. It is declarative, human-readable, and uses blocks, arguments, and attributes.
Docs: https://developer.hashicorp.com/terraform/language/syntax/configuration

**Q2: What is a Terraform block?**
The basic unit of HCL. Has a type (resource, variable, output), optional parameters (resource type, name), and arguments inside curly braces.

**Q3: What is terraform.tfstate?**
The state file — Terraform's database of what infrastructure exists. It maps your .tf code to real cloud resources. Never manually edit it. For teams, store it remotely in S3.
Docs: https://developer.hashicorp.com/terraform/language/state

**Q4: Difference between terraform plan and apply?**
`plan` = dry run — shows what WILL change without making changes. `apply` = actually creates/updates/destroys infrastructure. Always run plan before apply in production.

**Q5: What does terraform init do?**
Downloads provider plugins, creates .terraform.lock.hcl (version lock file), initializes the backend. Must be run first in any new Terraform project.
Docs: https://developer.hashicorp.com/terraform/cli/commands/init

**Q6: What is .terraform.lock.hcl?**
Dependency lock file — records exact provider versions used. Should be committed to git so team uses same versions.
