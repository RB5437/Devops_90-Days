# ⚡ Day 55 — Terraform Commands

## 🔗 Official CLI References

| Command | Official Doc |
|---------|-------------|
| terraform import | [developer.hashicorp.com/terraform/cli/commands/import](https://developer.hashicorp.com/terraform/cli/commands/import) |
| terraform workspace | [developer.hashicorp.com/terraform/cli/commands/workspace](https://developer.hashicorp.com/terraform/cli/commands/workspace) |
| terraform state | [developer.hashicorp.com/terraform/cli/commands/state](https://developer.hashicorp.com/terraform/cli/commands/state) |
| S3 Backend | [developer.hashicorp.com/terraform/language/backend/s3](https://developer.hashicorp.com/terraform/language/backend/s3) |
| Workspaces | [developer.hashicorp.com/terraform/language/state/workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces) |
| VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |

---

## 📋 TODAY'S EXACT COMMANDS

### Step 1 — Create Remote Backend Infrastructure
```bash
# Navigate to remote-infra folder
cd Day-55-Terraform/remote-infra

# Initialize
terraform init

# Apply — creates S3 bucket + DynamoDB table
terraform apply
# Enter a value: yes
# aws_s3_bucket.remote_s3_bucket: Creation complete after 22s [id=rbb-remote-s3-bucket-1]
# aws_dynamodb_table.basic-dynamodb-table: Creation complete after 20s [id=rbb-remote-dynamodb-table-1]
# Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

### Step 2 — Configure Main Project with Remote Backend
```bash
# Navigate to main terraform folder
cd ../terraform

# terraform.tf already has backend "s3" configured
# terraform init will migrate state to S3

terraform init
# Initializing the backend...
# Successfully configured the backend "s3"!
# Terraform will automatically use this backend.
# Terraform has been successfully initialized!
```

### Step 3 — Full Project Apply
```bash
terraform plan
terraform apply
# Enter a value: yes
# aws_key_pair.my_key_pair: Creation complete after 1s [id=terra-key-ec2]
# aws_default_vpc.default: Creation complete after 4s [id=vpc-0f0637ea8d32462bd]
# aws_security_group.my_security_group: Creation complete after 5s [id=sg-09d1774f9bda000fd]
# aws_instance.my_instance["instance2"]: Creation complete after 17s
# aws_instance.my_instance["instance1"]: Creation complete after 36s
# Releasing state lock. This may take a few moments...
# Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

# Outputs:
terraform output
# ec2_instance_public_ip = [
#   "54.198.74.86",
#   "13.216.255.196",
# ]
```

### Step 4 — Check State List
```bash
terraform state list
# aws_default_vpc.default
# aws_instance.my_instance["instance1"]
# aws_instance.my_instance["instance2"]
# aws_key_pair.my_key_pair
# aws_security_group.my_security_group
```

---

## 🔄 TERRAFORM IMPORT COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/import

```bash
# Import EC2 instance
terraform import aws_instance.my_new_instance i-0f856b753d1bd22b1
# aws_instance.my_new_instance: Importing from ID "i-0f856b753d1bd22b1"...
# aws_instance.my_new_instance: Import prepared!
# Import successful!

# Import Key Pair
terraform import aws_key_pair.my_key key-0df156aa2f3db2296

# Import S3 Bucket
terraform import aws_s3_bucket.my_bucket bucket-name

# Import Security Group
terraform import aws_security_group.my_sg sg-0143a59212e24379b

# Import VPC
terraform import aws_vpc.my_vpc vpc-0f0637ea8d32462bd

# Import DynamoDB Table
terraform import aws_dynamodb_table.my_table table-name

# Modern import block (Terraform 1.5.0+)
# Docs: https://developer.hashicorp.com/terraform/language/import
# Add to .tf file:
# import {
#   to = aws_key_pair.deployer
#   id = "deployer-key"
# }
# Then run: terraform plan
```

---

## 🏷️ WORKSPACE COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/workspace

```bash
# Show all workspaces (* = current)
terraform workspace list
# * default

# Show current workspace
terraform workspace show
# default

# Create new workspace
terraform workspace new dev
# Created and switched to workspace "dev"!

terraform workspace new prod
terraform workspace new stg

# Switch workspace
terraform workspace select prod
# Switched to workspace "prod".

terraform workspace select default

# Delete workspace (must switch away first)
terraform workspace select default
terraform workspace delete dev

# Use workspace name in code:
# terraform.workspace = current workspace name
# Example: name = "server-${terraform.workspace}"
```

---

## ☁️ REMOTE BACKEND — HCL TEMPLATES

### remote-infra/s3.tf
```hcl
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "remote_s3_bucket" {
  bucket = "rbb-remote-s3-bucket-1"
  tags = {
    Name = "rbb-remote-s3-bucket-1"
  }
}
```

### remote-infra/dynamodb.tf
```hcl
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name         = "rbb-remote-dynamodb-table-1"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"   # MUST be "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "rbb-remote-dynamodb-table-1"
  }
}
```

### Main terraform.tf — S3 Backend (Modern)
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/backend/s3
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
    use_lockfile = "true"   # modern — replaces deprecated dynamodb_table
  }
}
```

---

## 📦 MODULE COMMANDS + TEMPLATES

### vpc.tf — VPC Module from Registry
```hcl
# Module docs: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

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
# After adding module, MUST re-init to download it
terraform init
# Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 6.6.1 for vpc...
# Terraform has been successfully initialized!

terraform plan
# Plan: 29 to add, 0 to change, 0 to destroy.
```

---

## 🗂️ STATE COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/state

```bash
# List all resources in state
terraform state list

# Show resource details
terraform state show aws_instance.my_instance[\"instance1\"]

# Move resource in state
terraform state mv aws_instance.old aws_instance.new

# Remove from state (without destroying)
terraform state rm aws_instance.my_instance[\"instance1\"]

# Pull state from remote
terraform state pull

# Show all outputs
terraform output

# Refresh state
terraform refresh
```

---

## 🧹 DESTROY ORDER (Important!)

```bash
# Step 1: Destroy main resources first
cd terraform/
terraform destroy -auto-approve

# Step 2: Then destroy remote-infra
cd ../remote-infra/
terraform destroy -auto-approve

# ⚠️ NEVER destroy remote-infra first!
# tfstate is stored there — destroy it last!
```

---

## 📚 AWS Resources Used Today

| Resource | Docs |
|----------|------|
| aws_s3_bucket | [registry.terraform.io/.../s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| aws_dynamodb_table | [registry.terraform.io/.../dynamodb_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) |
| aws_instance | [registry.terraform.io/.../instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| aws_key_pair | [registry.terraform.io/.../key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| aws_security_group | [registry.terraform.io/.../security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| terraform-aws-modules/vpc | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |
