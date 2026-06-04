# ⚡ Day 53 — Terraform Commands 

## 🔗 Official CLI References

| Command | Official Doc |
|---------|-------------|
| terraform init | [developer.hashicorp.com/terraform/cli/commands/init](https://developer.hashicorp.com/terraform/cli/commands/init) |
| terraform validate | [developer.hashicorp.com/terraform/cli/commands/validate](https://developer.hashicorp.com/terraform/cli/commands/validate) |
| terraform plan | [developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan) |
| terraform apply | [developer.hashicorp.com/terraform/cli/commands/apply](https://developer.hashicorp.com/terraform/cli/commands/apply) |
| terraform destroy | [developer.hashicorp.com/terraform/cli/commands/destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy) |
| terraform fmt | [developer.hashicorp.com/terraform/cli/commands/fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt) |
| terraform show | [developer.hashicorp.com/terraform/cli/commands/show](https://developer.hashicorp.com/terraform/cli/commands/show) |
| terraform output | [developer.hashicorp.com/terraform/cli/commands/output](https://developer.hashicorp.com/terraform/cli/commands/output) |
| All CLI Commands | [developer.hashicorp.com/terraform/cli/commands](https://developer.hashicorp.com/terraform/cli/commands) |

---

## 📋 TODAY'S EXACT COMMANDS (Practised)

### Project 1 — Local File Resource
```bash
# Create project folder
mkdir ~/Devops_90-Days/Day-53-Terraform
cd ~/Devops_90-Days/Day-53-Terraform

# Create main.tf
vi main.tf
# Content:
# resource "local_file" "my_file" {
#   filename = "automate.txt"
#   content  = "Today I my DevOps_90_Days Day 53"
# }

# Initialize
terraform init
# Output: Terraform has been successfully initialized!
# Creates: .terraform.lock.hcl

# Validate syntax
terraform validate
# Output: Success! The configuration is valid.

# Dry run — see what will happen
terraform plan
# Output: Plan: 1 to add, 0 to change, 0 to destroy.

# Apply — create the file
terraform apply
# Type: yes
# Output: local_file.my_file: Creation complete after 0s

# Verify
ls
# automate.txt  main.tf  terraform.tfstate  terraform.tfstate.backup

cat automate.txt
# Today I my DevOps_90_Days Day 53
```

---

### Project 2 — AWS S3 Bucket
```bash
# Check AWS credentials
aws configure list
# Shows: access_key, secret_key, region

# Verify AWS identity
aws sts get-caller-identity
# Returns: UserId, Account, Arn

# Check environment
env | grep AWS

# Create provider.tf
cat provider.tf
# provider "aws" {
#   region = "us-east-1"
# }

# Create terraform.tf
cat terraform.tf
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# Create s3.tf
cat s3.tf
# #this is s3 bucket
# resource "aws_s3_bucket" "my_devops_bucket" {
#   bucket = "devops-terraform-bucket-172313999-2026"
# }

# Initialize (downloads AWS provider v6.48.0)
terraform init
# Output: Terraform has been successfully initialized!

# Validate
terraform validate
# Output: Success! The configuration is valid.

# List files
ls -a
# .terraform  .terraform.lock.hcl  main.tf  provider.tf  s3.tf  terraform.tf

# Plan
terraform plan
# Output: Plan: 1 to add, 0 to change, 0 to destroy.
# aws_s3_bucket.my_devops_bucket will be created

# Apply
terraform apply
# Type: yes
# Output: aws_s3_bucket.my_devops_bucket: Creation complete after 0s
#         [id=devops-terraform-bucket-172313999-2026]
# Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

## 🚀 CORE WORKFLOW COMMANDS
📖 Full workflow: https://developer.hashicorp.com/terraform/intro/core-workflow

```bash
# 1. Initialize project
terraform init

# 2. Format code (auto-indent)
terraform fmt

# 3. Validate syntax
terraform validate

# 4. Preview changes (DRY RUN — no real changes)
terraform plan

# 5. Save plan to file
terraform plan -out=myplan.tfplan

# 6. Apply changes
terraform apply

# 7. Apply without confirmation
terraform apply -auto-approve

# 8. Apply saved plan
terraform apply myplan.tfplan

# 9. Destroy all resources
terraform destroy

# 10. Destroy without confirmation
terraform destroy -auto-approve

# 11. Destroy specific resource only
terraform destroy -target=aws_s3_bucket.my_devops_bucket
```

---

## 📁 HCL CODE TEMPLATES

### terraform.tf — Required providers
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0"
}
```

### provider.tf — AWS provider
```hcl
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = "us-east-1"
}
```

### local_file resource
```hcl
# Docs: https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "my_file" {
  filename = "automate.txt"
  content  = "Today I my DevOps_90_Days Day 53"
}
```

### aws_s3_bucket resource
```hcl
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "my_devops_bucket" {
  bucket = "devops-terraform-bucket-172313999-2026"

  tags = {
    Name        = "My DevOps Bucket"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}
```

---

## 🔑 AWS AUTHENTICATION COMMANDS

```bash
# Configure AWS credentials
# Docs: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
aws configure

# View current config
aws configure list

# Verify identity (who am I?)
aws sts get-caller-identity

# Check env variables
env | grep AWS

# Set via environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## 🗂️ STATE FILE COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/state

```bash
# List all resources in state
terraform state list

# Show specific resource details
terraform state show aws_s3_bucket.my_devops_bucket

# Show full state (human-readable)
terraform show

# Pull remote state
terraform state pull

# Remove resource from state (without destroying)
terraform state rm aws_s3_bucket.my_devops_bucket

# Refresh state (sync with real cloud)
terraform refresh
```

---

## 📊 Day 53 — Files Created

```bash
ls ~/Devops_90-Days/Day-53-Terraform/
# automate.txt           ← created by local_file resource
# awscliv2.zip           ← AWS CLI installer
# main.tf                ← local_file resource code
# provider.tf            ← AWS provider config
# s3.tf                  ← S3 bucket resource
# terraform.tf           ← required_providers block
# terraform.tfstate      ← STATE FILE (tracks what exists)
# terraform.tfstate.backup ← previous state
```

---

## 📚 AWS S3 Resources — Official Docs

| Resource | Link |
|----------|------|
| aws_s3_bucket | [registry.terraform.io/../s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| aws_s3_bucket_versioning | [registry.terraform.io/../s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) |
| aws_s3_bucket_policy | [registry.terraform.io/../s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) |
| aws_s3_bucket_lifecycle_configuration | [registry.terraform.io/../s3_bucket_lifecycle_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) |
