# 📝 Day 55 — Terraform Notes (Remote Backend + Workspaces + Modules)

## 🔗 Quick Reference Links

| Topic | Official Doc |
|-------|-------------|
| Backend Configuration | [developer.hashicorp.com/terraform/language/backend](https://developer.hashicorp.com/terraform/language/backend) |
| S3 Backend | [developer.hashicorp.com/terraform/language/backend/s3](https://developer.hashicorp.com/terraform/language/backend/s3) |
| State Locking | [developer.hashicorp.com/terraform/language/state/locking](https://developer.hashicorp.com/terraform/language/state/locking) |
| Workspaces | [developer.hashicorp.com/terraform/language/state/workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) |
| Modules Overview | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| Module Sources | [developer.hashicorp.com/terraform/language/modules/sources](https://developer.hashicorp.com/terraform/language/modules/sources) |
| terraform import | [developer.hashicorp.com/terraform/cli/commands/import](https://developer.hashicorp.com/terraform/cli/commands/import) |
| AWS S3 Resource | [registry.terraform.io/.../s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| AWS DynamoDB | [registry.terraform.io/.../dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) |
| VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |

---

## 1. 🔄 terraform import — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/import

### Why import?
```
Problem: Infrastructure already exists (created manually in console)
         Terraform doesn't know about it → not in state file

Solution: terraform import → adds it to state → now managed by Terraform
```

### How import works:
```
Step 1: Write resource block in .tf file (describe the resource)
Step 2: Run terraform import <resource_address> <real_id>
Step 3: Terraform fetches real resource details from cloud
Step 4: Adds to terraform.tfstate
Step 5: Now managed by Terraform!
```

### Syntax:
```bash
terraform import <resource_type>.<resource_name> <real_resource_id>

# EC2 example:
terraform import aws_instance.my_new_instance i-0f856b753d1bd22b1

# Key Pair example:
terraform import aws_key_pair.my_key key-0df156aa2f3db2296

# S3 Bucket example:
terraform import aws_s3_bucket.my_bucket my-bucket-name
```

### Modern import block (Terraform 1.5.0+):
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/import
import {
  to = aws_key_pair.deployer
  id = "deployer-key"
}
```

---

## 2. 🔴 Problem: State Conflict in Teams

```
Without remote backend — team of 2:

Person 1: count=2 → .tf → apply → .tfstate (count=2)
Person 2: count=3 → .tf → apply → .tfstate (count=3)

PROBLEM: State conflict!
- Local tfstate on Person 1's machine
- Different local tfstate on Person 2's machine
- They see different states of the same infra!
- Destroying together = chaos
```

**Solution: Remote Backend**

---

## 3. ☁️ Remote Backend — S3 Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/backend/s3

### What it solves:
```
Everyone reads/writes to the SAME tfstate in S3
→ No more state conflicts
→ Team can collaborate safely
→ State is backed up (S3 versioning)
→ State is encrypted (S3 SSE)
```

### Architecture:
```
Developer 1 → terraform apply → S3 bucket → terraform.tfstate
Developer 2 → terraform plan  → S3 bucket → reads same tfstate

DynamoDB → state LOCK during apply
         → only ONE person can modify at a time
         → LockID stored as item in DynamoDB table
```

### S3 Backend config:
```hcl
backend "s3" {
  bucket       = "rbb-remote-s3-bucket-1"   # S3 bucket name
  key          = "terraform.tfstate"         # path in S3 bucket
  region       = "us-east-1"
  use_lockfile = "true"                      # modern locking (replaces dynamodb_table)
}
```

### Old way vs New way:
```hcl
# OLD (deprecated):
dynamodb_table = "rbb-remote-dynamodb-table-1"

# NEW (use this):
use_lockfile = "true"

# Warning you'll see:
# "dynamodb_table is deprecated. Use use_lockfile instead."
```

### State locking in action:
```
Developer 1 runs terraform apply:
→ DynamoDB: writes LockID = "rbb-remote-s3-bucket..."
→ Applies changes to AWS
→ Updates tfstate in S3
→ DynamoDB: removes LockID

Developer 2 tries terraform apply SAME TIME:
→ Checks DynamoDB: LockID exists!
→ ERROR: "Error acquiring the state lock"
→ Waits or errors out — prevents corruption
```

---

## 4. 🔒 DynamoDB State Locking — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/state/locking

### DynamoDB table requirements:
```hcl
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "rbb-remote-dynamodb-table-1"
  billing_mode = "PAY_PER_REQUEST"  # only pay when used
  hash_key     = "LockID"           # MUST be "LockID" exactly

  attribute {
    name = "LockID"
    type = "S"           # S = String
  }
}
```

**Key requirement:** hash_key MUST be `"LockID"` — Terraform looks for this exact key.

### Lock item in DynamoDB:
```
When terraform apply runs:
Table: rbb-remote-dynamodb-table-1
Item: {
  LockID: "rbb-remote-s3-bucket-1/terraform.tfstate",
  Digest: "20ba68d67c5e1553c9beab0e2cb321cc",
  ...
}
→ Released after apply completes
```

---

## 5. 🏷️ Workspaces — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/state/workspaces

### What are workspaces?
```
Same code (.tf files) → different environments
Like git branches for Terraform state!

workspace: dev   → separate tfstate → Dev infra
workspace: prod  → separate tfstate → Prod infra
workspace: stg   → separate tfstate → Staging infra
```

### workspace vs separate folders:
```
Approach 1 — Workspaces (what we did today):
  Same .tf code → different workspace → different state
  Use: simple environments, same config

Approach 2 — Separate folders (enterprise):
  dev/main.tf
  prod/main.tf
  Use: very different configs per env
```

### Using workspace with variables:
```hcl
# In variables.tf
variable "env" {
  default = terraform.workspace  # automatically gets workspace name!
}

# Now:
# workspace dev  → var.env = "dev"
# workspace prod → var.env = "prod"
```

### Workspace state isolation:
```
S3 backend with workspace:
rbb-remote-s3-bucket-1/
├── terraform.tfstate           ← default workspace
├── env:/
│   ├── dev/terraform.tfstate   ← dev workspace
│   └── prod/terraform.tfstate  ← prod workspace
```

---

## 6. 📦 Modules — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/modules

### What are modules?
```
Module = packaged, reusable Terraform code

Like functions in programming:
  Function: define once → call many times
  Module:   define once → use in many projects
```

### Types of modules:
```
1. Root module        → your main .tf files
2. Child modules      → modules you call
3. Published modules  → from Terraform Registry (what we used today)
```

### Using a published module:
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"  # registry path
  # ↑ from registry.terraform.io/modules/terraform-aws-modules/vpc/aws

  # Pass variables to the module:
  name = "my-auto-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true
}
```

### What VPC module creates (Plan: 29 to add!):
```
VPC → Subnets (public + private) → Route Tables
→ Internet Gateway → NAT Gateway → VPN Gateway
→ Route Table Associations → Security Groups
```

### Module versioning:
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"  # pin to specific version
}
```

---

## 7. 🎯 Interview Questions — Terraform Day 4

**Q1: Why use remote backend instead of local state?**
Local state causes conflicts in team environments. Remote backend (S3) stores one shared state file. DynamoDB adds locking so only one person modifies state at a time. Docs: https://developer.hashicorp.com/terraform/language/backend/s3

**Q2: What is state locking in Terraform?**
Prevents two people from running terraform apply simultaneously. DynamoDB stores a LockID item when apply starts, releases it when done. If locked, second person gets "Error acquiring the state lock".

**Q3: What is a Terraform workspace?**
A named isolated state environment. Same .tf code can manage Dev, Staging, Prod with separate state files per workspace. Like git branches for infrastructure state.

**Q4: What is terraform import?**
Brings existing infrastructure (created outside Terraform) into Terraform state management. After import, the resource is tracked in tfstate and managed by Terraform going forward.

**Q5: What are Terraform modules?**
Reusable, packaged groups of resources. Can be local (your own) or from Terraform Registry (community). The VPC module creates 29 resources with just 15 lines of code.

**Q6: What is the difference between dynamodb_table and use_lockfile?**
dynamodb_table is deprecated. use_lockfile = "true" is the modern way to enable state locking in the S3 backend. Both achieve the same result — preventing concurrent state modifications.
