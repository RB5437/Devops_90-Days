# ⚡ Day 54 — Terraform Commands 

## 🔗 Official CLI References

| Command | Official Doc |
|---------|-------------|
| terraform plan | [developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan) |
| terraform apply | [developer.hashicorp.com/terraform/cli/commands/apply](https://developer.hashicorp.com/terraform/cli/commands/apply) |
| terraform output | [developer.hashicorp.com/terraform/cli/commands/output](https://developer.hashicorp.com/terraform/cli/commands/output) |
| terraform state | [developer.hashicorp.com/terraform/cli/commands/state](https://developer.hashicorp.com/terraform/cli/commands/state) |
| Variables | [developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables) |
| for_each | [developer.hashicorp.com/terraform/language/meta-arguments/for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) |

---

## 📋 TODAY'S EXACT COMMANDS

### SSH Key Generation (before terraform)
```bash
# Generate SSH key pair for EC2
# Docs: https://developer.hashicorp.com/terraform/language/functions/file
ssh-keygen -t ed25519 -f terra-key-ec2

# This creates:
# terra-key-ec2     → private key (keep safe, never share)
# terra-key-ec2.pub → public key (upload to AWS via Terraform)

# Verify key files
ls -la terra-key-ec2*
# terra-key-ec2     (private)
# terra-key-ec2.pub (public)
```

### VS Code — terraform plan (Windows)
```powershell
# In VS Code terminal (PowerShell)
cd C:\Users\HP\Documents\terraform

terraform plan
# Plan: 5 to add, 0 to change, 0 to destroy.

terraform apply
# Enter a value: yes
# Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

### Output commands
```bash
# Show all outputs after apply
terraform output

# Show specific output
terraform output ec2_instance_public_ip
terraform output ec2_arn
terraform output ec2_instance_public_dns

# JSON format (for scripting)
terraform output -json
```

---

## 📁 VARIABLES — HCL TEMPLATES

### variables.tf — complete template
```hcl
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

### terraform.tfvars — override defaults
```hcl
# Auto-loaded by terraform apply
aws_region                   = "us-east-1"
ami_id                       = "ami-091138d0f0d41ff90"
instance_type                = "t3.micro"
ec2_default_root_volume_size = 10
env                          = "prod"
```

---

## 🔄 for_each TEMPLATES

### Basic for_each with tomap
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each

resource "aws_instance" "my_instance" {
  for_each = tomap({
    "instance1" = "t2.micro"
    "instance2" = "t3.micro"
  })
  ami           = var.ami_id
  instance_type = each.value   # each.value = t2.micro or t3.micro
  tags = {
    Name = each.key            # each.key = instance1 or instance2
  }
}
```

### for_each with set of strings
```hcl
resource "aws_iam_user" "the_accounts" {
  for_each = toset(["alice", "bob", "charlie"])
  name     = each.key
}
```

### for_each output
```hcl
output "ec2_ips" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}

# Or as map:
output "ec2_ips_map" {
  value = {
    for k, instance in aws_instance.my_instance : k => instance.public_ip
  }
}
```

---

## ❓ CONDITIONAL TEMPLATES

```hcl
# Docs: https://developer.hashicorp.com/terraform/language/expressions/conditionals
# Syntax: condition ? true_value : false_value

# Volume size — double in prod
volume_size = var.env == "prod" ? var.ec2_default_root_volume_size * 2 : var.ec2_default_root_volume_size

# Instance type per env
instance_type = var.env == "prod" ? "t3.medium" : "t2.micro"

# Deletion protection
deletion_protection = var.env == "prod" ? true : false

# Enable resource only in prod (count trick)
resource "aws_instance" "bastion" {
  count = var.env == "prod" ? 1 : 0
}
```

---

## 🔑 EC2 PROJECT — COMPLETE COMMANDS

```bash
# Step 1: Generate SSH keypair
ssh-keygen -t ed25519 -f terra-key-ec2

# Step 2: Create install_nginx.sh (user_data)
cat > install_nginx.sh << 'EOF'
#!/bin/bash
apt update -y
apt install nginx -y
systemctl start nginx
systemctl enable nginx
EOF

# Step 3: terraform init
terraform init

# Step 4: terraform plan
terraform plan
# Plan: 5 to add, 0 to change, 0 to destroy.
# Resources: aws_key_pair + aws_default_vpc + aws_security_group + aws_instance x2

# Step 5: terraform apply
terraform apply
# Enter a value: yes
# aws_key_pair.my_key_pair: Creation complete after 2s [id=terra-key-ec2]
# aws_default_vpc.default: Creation complete after 5s [id=vpc-0f0637ea8d32462bd]
# aws_security_group.my_security_group: Creation complete after 5s [id=sg-0143a59212e24379b]
# aws_instance.my_instance: Still creating... [00m10s elapsed]
# aws_instance.my_instance: Creation complete after 16s [id=i-01c88cc752e4af565]
# Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

# Step 6: View outputs
terraform output
# ec2_arn = "arn:aws:ec2:us-east-1:904352270417:instance/i-01c88cc752e4af565"
# ec2_instance_public_dns = "ec2-54-225-37-192.compute-1.amazonaws.com"
# ec2_instance_public_ip  = "54.225.37.192"

# Step 7: SSH into EC2
ssh -i terra-key-ec2 ubuntu@54.225.37.192

# Step 8: Destroy when done (avoid AWS charges!)
terraform destroy -auto-approve
```

---

## 🗂️ STATE MANAGEMENT COMMANDS
📖 Docs: https://developer.hashicorp.com/terraform/cli/commands/state

```bash
# List all resources in state
terraform state list
# aws_default_vpc.default
# aws_instance.my_instance["instance1"]
# aws_instance.my_instance["instance2"]
# aws_key_pair.my_key_pair
# aws_security_group.my_security_group

# Show specific resource
terraform state show aws_instance.my_instance[\"instance1\"]

# Show full state
terraform show

# Refresh state (sync with AWS)
terraform refresh
```

---

## 📊 VARIABLE PASSING METHODS (Priority Order)

```bash
# Highest priority → Lowest priority:
# 1. -var flag (highest)
terraform apply -var="env=prod" -var="instance_type=t3.large"

# 2. -var-file flag
terraform apply -var-file="prod.tfvars"

# 3. terraform.tfvars (auto-loaded)
# Just create terraform.tfvars file

# 4. TF_VAR_ environment variables
export TF_VAR_env="prod"
export TF_VAR_instance_type="t3.micro"

# 5. Default in variable block (lowest)
variable "env" { default = "dev" }
```

---

## 📚 AWS Resources Used Today — Official Docs

| Resource | Link |
|----------|------|
| aws_key_pair | [registry.terraform.io/.../aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| aws_default_vpc | [registry.terraform.io/.../aws_default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) |
| aws_security_group | [registry.terraform.io/.../aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| aws_instance | [registry.terraform.io/.../aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| file() function | [developer.hashicorp.com/terraform/language/functions/file](https://developer.hashicorp.com/terraform/language/functions/file) |
| tomap() function | [developer.hashicorp.com/terraform/language/functions/tomap](https://developer.hashicorp.com/terraform/language/functions/tomap) |
| toset() function | [developer.hashicorp.com/terraform/language/functions/toset](https://developer.hashicorp.com/terraform/language/functions/toset) |
