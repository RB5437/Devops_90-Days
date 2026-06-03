# ⚡ Day 52 — Terraform Commands (Copy-Paste Ready)

## 🔗 Official Command References

| Reference | Link |
|-----------|------|
| All CLI Commands | [developer.hashicorp.com/terraform/cli](https://developer.hashicorp.com/terraform/cli) |
| Init Command | [developer.hashicorp.com/terraform/cli/commands/init](https://developer.hashicorp.com/terraform/cli/commands/init) |
| Plan Command | [developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan) |
| Apply Command | [developer.hashicorp.com/terraform/cli/commands/apply](https://developer.hashicorp.com/terraform/cli/commands/apply) |
| Destroy Command | [developer.hashicorp.com/terraform/cli/commands/destroy](https://developer.hashicorp.com/terraform/cli/commands/destroy) |
| State Commands | [developer.hashicorp.com/terraform/cli/commands/state](https://developer.hashicorp.com/terraform/cli/commands/state) |
| Import Command | [developer.hashicorp.com/terraform/cli/commands/import](https://developer.hashicorp.com/terraform/cli/commands/import) |
| Env Variables | [developer.hashicorp.com/terraform/cli/config/environment-variables](https://developer.hashicorp.com/terraform/cli/config/environment-variables) |
| Install Guide | [developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install) |
| Downloads | [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/) |

---

## 🔧 INSTALLATION COMMANDS
📖 Official install guide: https://developer.hashicorp.com/terraform/install

### Linux (Ubuntu/Debian) — AWS EC2:
```bash
# Step 1: Add GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Step 2: Add HashiCorp repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Step 3: Install
sudo apt update && sudo apt install terraform -y

# Step 4: Verify
terraform --version
# Terraform v1.15.5 on linux_amd64
```

### Windows (PowerShell):
```powershell
# Download from: https://releases.hashicorp.com/terraform/
# OR https://developer.hashicorp.com/terraform/install

# Option 1: Chocolatey
choco install terraform

# Option 2: winget
winget install HashiCorp.Terraform

# Verify
terraform -version
# Terraform v1.15.5 on windows_amd64
```

### macOS:
```bash
# Official: https://developer.hashicorp.com/terraform/install
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

---

## 🚀 CORE WORKFLOW COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/intro/core-workflow

```bash
# 1. INIT — Download providers & modules
# Docs: https://developer.hashicorp.com/terraform/cli/commands/init
terraform init

# 2. VALIDATE — Check syntax errors
# Docs: https://developer.hashicorp.com/terraform/cli/commands/validate
terraform validate

# 3. FORMAT — Auto-format .tf files
# Docs: https://developer.hashicorp.com/terraform/cli/commands/fmt
terraform fmt
terraform fmt -recursive   # format all subdirectories

# 4. PLAN — Preview changes (DRY RUN — no actual changes)
# Docs: https://developer.hashicorp.com/terraform/cli/commands/plan
terraform plan
terraform plan -out=tfplan   # save plan to file

# 5. APPLY — Create/Update infrastructure
# Docs: https://developer.hashicorp.com/terraform/cli/commands/apply
terraform apply
terraform apply -auto-approve           # skip confirmation
terraform apply tfplan                  # apply saved plan

# 6. DESTROY — Delete all infrastructure
# Docs: https://developer.hashicorp.com/terraform/cli/commands/destroy
terraform destroy
terraform destroy -auto-approve         # skip confirmation
terraform destroy -target=aws_instance.web  # destroy specific resource
```

---

## 🔑 AWS PROVIDER SETUP
📖 AWS Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
📖 AWS Provider GitHub: https://github.com/hashicorp/terraform-provider-aws

```hcl
# provider.tf
# Docs: https://developer.hashicorp.com/terraform/language/providers/configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # registry.terraform.io/hashicorp/aws
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}
```

```bash
# Configure AWS credentials
# Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
aws configure
# AWS Access Key ID: <key>
# Secret Access Key: <secret>
# Region: us-east-1

# OR environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## 📊 STATE MANAGEMENT COMMANDS
📖 State docs: https://developer.hashicorp.com/terraform/language/state
📖 State commands: https://developer.hashicorp.com/terraform/cli/commands/state

```bash
# List all resources in state
terraform state list

# Show details of specific resource
terraform state show aws_instance.web

# Move resource in state
terraform state mv aws_instance.web aws_instance.app

# Remove resource from state (WITHOUT destroying it)
terraform state rm aws_instance.web

# Pull remote state locally
terraform state pull

# Push local state to remote
terraform state push

# Refresh state (sync with real infra)
# Docs: https://developer.hashicorp.com/terraform/cli/commands/refresh
terraform refresh
```

---

## 🧹 UTILITY COMMANDS
📖 All commands: https://developer.hashicorp.com/terraform/cli/commands

```bash
# Check version
terraform version

# Help
terraform --help
terraform plan --help

# List providers used
terraform providers

# Show outputs
terraform output
terraform output instance_ip

# Show current state (human-readable)
terraform show

# Import existing resource
# Docs: https://developer.hashicorp.com/terraform/cli/commands/import
terraform import aws_instance.web i-1234567890abcdef0

# Generate dependency graph (needs graphviz)
terraform graph | dot -Tsvg > graph.svg

# Taint resource (force recreate on next apply)
# Docs: https://developer.hashicorp.com/terraform/cli/commands/taint
terraform taint aws_instance.web

# Untaint resource
terraform untaint aws_instance.web
```

---

## 🐛 DEBUGGING
📖 Env variables: https://developer.hashicorp.com/terraform/cli/config/environment-variables

```bash
# Enable debug logging
export TF_LOG=DEBUG      # TRACE, DEBUG, INFO, WARN, ERROR
terraform apply

# Save logs to file
export TF_LOG_PATH=./terraform.log
terraform plan

# Disable logging
unset TF_LOG
unset TF_LOG_PATH
```

---

## 📋 DAY 52 PRACTICE FLOW

```bash
# Step 1: Verify install
terraform --version

# Step 2: Create project
mkdir ~/terraform-day52 && cd ~/terraform-day52

# Step 3: Create provider.tf
# Reference: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
cat > provider.tf << 'EOF'
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
EOF

# Step 4: Initialize (downloads AWS provider)
terraform init

# Step 5: Validate
terraform validate
# Success! The configuration is valid.

# Step 6: Format
terraform fmt
```

---

## 📚 Full Learning Path (Official Tutorials)

| Tutorial | Link |
|----------|------|
| AWS Get Started | [developer.hashicorp.com/terraform/tutorials/aws-get-started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) |
| Build Infrastructure | [developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build) |
| Change Infrastructure | [developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-change](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-change) |
| Destroy Infrastructure | [developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-destroy](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-destroy) |
| Remote State | [developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-remote](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-remote) |
| Variables | [developer.hashicorp.com/terraform/tutorials/configuration-language/variables](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables) |
| Modules | [developer.hashicorp.com/terraform/tutorials/modules](https://developer.hashicorp.com/terraform/tutorials/modules) |
