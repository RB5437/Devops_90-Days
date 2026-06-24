# Day 72 — Terraform Variables + DynamoDB + Outputs 🌍
## 📅 Date: 23 June 2026
## 🎯 Topic: Terraform Variables | DynamoDB Table | Output Values | terraform fmt

---

## 📚 Resources Used
- 📺 **TrainWithShubham — Terraform Multi-Environment AWS Infrastructure**
- 📖 **Terraform Variables**: https://developer.hashicorp.com/terraform/language/values/variables
- 📖 **Terraform Outputs**: https://developer.hashicorp.com/terraform/language/values/outputs
- 📖 **DynamoDB Resource**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table

---

## 📁 Updated Project File Structure

```
multi-Environment/
├── .terraform/
├── .terraform.lock.hcl
├── main.tf
├── provider.tf
├── s3.tf
├── ec2.tf            ← Updated — now uses var.ami_id, var.instance_type
├── dynamodb.tf       ← NEW today
├── variable.tf       ← NEW today — all variables defined here
├── output.tf         ← NEW today — EC2 public IP output
├── terra-key
├── terra-key.pub
└── terraform.tfstate
```

---

## 📦 variable.tf — Terraform Variables

```hcl
variable "dynamo_table_name" {
  type        = string
  default     = "rbb-multi-env-table"
  description = "this is table name for Dynamodb"
}

variable "ami_id" {
  default     = "ami-08f44e8eca9095668"
  type        = string
  description = "this is ami id for EC2"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "this is instance type for ec2"
}
```

**Why Variables?**
- Reuse same code for Dev, Staging, Prod — just change variable values
- No hardcoded values in resource files
- `type` enforces correct data type
- `default` = value used when not provided

---

## 🗄️ dynamodb.tf — DynamoDB Table

```hcl
resource "aws_dynamodb_table" "name" {
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
```

**Key concepts:**
- `billing_mode = "PAY_PER_REQUEST"` — On-demand pricing, no capacity planning needed
- `hash_key = "id"` — Partition key
- `type = "S"` — String type attribute
- `var.dynamo_table_name` — Uses variable instead of hardcoded value

---

## 📤 output.tf — Output Values

```hcl
output "aws_ec2_ip" {
  value = aws_instance.my_ec2.public_ip
}
```

**Output result:**
```
Outputs:
aws_ec2_ip = "13.221.84.3"
```

Outputs are useful for:
- Getting resource details after apply
- Passing values between modules
- Displaying important info (IP, DNS, ARN)

---

## 🔄 ec2.tf Update — Hardcoded → Variables

```hcl
# BEFORE (Day 71 — hardcoded)
resource "aws_instance" "my_ec2" {
  ami           = "ami-08f44e8eca9095668"
  instance_type = "t2.micro"
  ...
}

# AFTER (Day 72 — using variables)
resource "aws_instance" "my_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  ...
}
```

---

## 🎨 terraform fmt — Code Formatter

```bash
# Auto-format all .tf files (consistent spacing + indentation)
terraform fmt

# Output shows which files were formatted:
dynamodb.tf
variable.tf
```

**Why use terraform fmt?**
- Consistent code style across team
- Catches misaligned indentation
- Best practice — run before every commit

---

## 🚀 Commands Used Today

```bash
# Format all .tf files
terraform fmt

# Plan — see what will be created
terraform plan

# Apply — create DynamoDB + update outputs
terraform apply
# Type: yes

# Output: apply complete
```

---

## ✅ Resources Summary — Day 71 + Day 72 Combined

| Resource | Name | Status |
|----------|------|--------|
| S3 Bucket | rbb-multi-env | ✅ Created Day 71 |
| EC2 Instance | terra-automate (t2.micro) | ✅ Running Day 71 |
| Key Pair | rbb-terra-key | ✅ Created Day 71 |
| Security Group | rbb-sg | ✅ Created Day 71 |
| Default VPC | default | ✅ Created Day 71 |
| DynamoDB Table | rbb-multi-env-table | ✅ Created Day 72 |
| Output | aws_ec2_ip = 13.221.84.3 | ✅ Day 72 |

**DynamoDB Console:**
- Table name: `rbb-multi-env-table`
- Status: ✅ Active
- Partition key: `id (S)`
- Billing mode: On-demand (PAY_PER_REQUEST)

---

## ❌ Errors Faced + Fixes

### Error 1 — Invalid function argument (file path)
```
Error: Invalid function argument
on ec2.tf line 4, in resource "aws_key_pair" "name":
public_key = file("/c/Users/HP/Pictures/Screenshots/Project 2/multi-Environment/terra-key.pub")
```
**Root Cause:** Absolute Windows path — not portable, spaces in path cause issues.

**Fix:**
```hcl
# Use relative path with path.module
public_key = file("${path.module}/terra-key.pub")
```

---

### Error 2 — Reference to undeclared resource
```
Error: Reference to undeclared resource
on ec2.tf line 15: vpc_id = aws_default_vpc.default.id
A managed resource "aws_default_vpc" "default" has not been declared
```
**Root Cause:** Referenced `aws_default_vpc.default` but never declared it.

**Fix:**
```hcl
# Add this block to ec2.tf
resource "aws_default_vpc" "default" {
}
```

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Variables | https://developer.hashicorp.com/terraform/language/values/variables |
| Output Values | https://developer.hashicorp.com/terraform/language/values/outputs |
| DynamoDB Table | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table |
| terraform fmt | https://developer.hashicorp.com/terraform/cli/commands/fmt |
| path.module | https://developer.hashicorp.com/terraform/language/expressions/references#path-module |
| aws_default_vpc | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
https://github.com/RB5437/Terraform-Multi-Environment-AWS-Infrastructure.git
