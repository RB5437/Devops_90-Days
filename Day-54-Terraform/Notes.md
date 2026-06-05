# 📝 Day 54 — Terraform Notes (Variables, for_each, Conditionals, State)

## 🔗 Quick Reference Links

| Topic | Official Doc |
|-------|-------------|
| Input Variables | [developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables) |
| Output Values | [developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs) |
| Local Values | [developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals) |
| for_each | [developer.hashicorp.com/terraform/language/meta-arguments/for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each) |
| count | [developer.hashicorp.com/terraform/language/meta-arguments/count](https://developer.hashicorp.com/terraform/language/meta-arguments/count) |
| Conditionals | [developer.hashicorp.com/terraform/language/expressions/conditionals](https://developer.hashicorp.com/terraform/language/expressions/conditionals) |
| State | [developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state) |
| depends_on | [developer.hashicorp.com/terraform/language/meta-arguments/depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on) |
| aws_instance | [registry.terraform.io/.../aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) |
| aws_key_pair | [registry.terraform.io/.../aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) |
| aws_security_group | [registry.terraform.io/.../aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |

---

## 1. 📥 Input Variables — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/values/variables

### Why variables?
```
Without variables:             With variables:
ami = "ami-091138d0f0d41ff90"  ami = var.ami_id
region = "us-east-1"          region = var.aws_region
→ Hardcoded — not reusable     → Parameterized — reusable anywhere
```

### Variable block structure:
```hcl
variable "variable_name" {
  description = "What this variable is for"  # optional but recommended
  type        = string                        # string, number, bool, list, map
  default     = "default_value"              # optional — if missing, user must provide
  sensitive   = false                        # hides value in logs (for passwords)
  validation {                               # optional validation rules
    condition     = var.env != ""
    error_message = "Environment must not be empty."
  }
}
```

### How to pass variable values:
```bash
# Method 1: default in variable block (used today)
variable "env" { default = "prod" }

# Method 2: terraform.tfvars file (auto-loaded)
echo 'env = "staging"' > terraform.tfvars

# Method 3: -var flag at command line
terraform apply -var="env=prod"

# Method 4: -var-file flag
terraform apply -var-file="prod.tfvars"

# Method 5: Environment variable
export TF_VAR_env="prod"
```

### Reference variables:
```hcl
# Use var.<name> to reference
ami           = var.ami_id
instance_type = var.instance_type
volume_size   = var.ec2_default_root_volume_size
```

---

## 2. 📤 Output Values — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/values/outputs

### Why outputs?
```
After terraform apply → You need to know:
- What IP was assigned to EC2?
- What is the RDS endpoint?
- What is the S3 bucket name?
→ Outputs show these values automatically!
```

### Output block structure:
```hcl
output "output_name" {
  value       = resource_type.resource_name.attribute
  description = "What this output represents"
  sensitive   = false  # set true for passwords/secrets
}
```

### Real examples from today:
```hcl
# Single instance output
output "ec2_instance_public_ip" {
  value       = aws_instance.my_instance.public_ip
  description = "Public IP address of the EC2 instance"
}

# for_each output — list comprehension
output "ec2_instance_public_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}
```

### View outputs:
```bash
terraform output                        # all outputs
terraform output ec2_instance_public_ip # specific output
terraform output -json                  # JSON format
```

---

## 3. 🔄 Meta-Arguments: count vs for_each
📖 count: https://developer.hashicorp.com/terraform/language/meta-arguments/count
📖 for_each: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each

### count — simple integer
```hcl
resource "aws_instance" "server" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  tags = {
    Name = "server-${count.index}"  # server-0, server-1
  }
}

# Access:
aws_instance.server[0].public_ip
aws_instance.server[1].public_ip
aws_instance.server[*].public_ip  # all IPs as list
```

**Problem with count:**
```
If you remove instance[0], Terraform destroys [0] and
renames [1] → [0]. Can cause unintended recreations!
```

### for_each — map/set based (PREFERRED)
```hcl
# Diagram from Shubham's notes:
# for_each = tomap({
#   key   = value
#   key2  = value2
# })

resource "aws_instance" "my_instance" {
  for_each = tomap({
    "instance1" = "t2.micro",
    "instance2" = "t3.micro"
  })

  ami           = var.ami_id
  instance_type = each.value   # t2.micro or t3.micro
  tags = {
    Name = each.key           # "instance1" or "instance2"
  }
}

# Access:
aws_instance.my_instance["instance1"].public_ip
aws_instance.my_instance["instance2"].public_ip
```

**Why for_each is better than count:**
```
Removing "instance1" only deletes that specific instance.
"instance2" remains untouched — no unintended changes!
```

---

## 4. ❓ Conditional Expression (Ternary Operator)
📖 Docs: https://developer.hashicorp.com/terraform/language/expressions/conditionals

```
Syntax: condition ? value_if_true : value_if_false

From Shubham's notes:
  if env == prod  → volume = 20
  else            → volume = 10
```

### Real example from today's code:
```hcl
root_block_device {
  volume_size = var.env == "prod" ? var.ec2_default_root_volume_size * 2 : var.ec2_default_root_volume_size
  volume_type = "gp3"
}

# If var.env == "prod"  → volume_size = 10 * 2 = 20GB
# If var.env != "prod"  → volume_size = 10GB (default)
```

### More examples:
```hcl
# Enable deletion protection only in prod
deletion_protection = var.env == "prod" ? true : false

# Different instance type per env
instance_type = var.env == "prod" ? "t3.medium" : "t2.micro"

# Conditional resource creation (with count)
resource "aws_instance" "bastion" {
  count = var.env == "prod" ? 1 : 0
}
```

---

## 5. 🔗 depends_on — Explicit Dependencies
📖 Docs: https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on

```hcl
# Terraform usually detects dependencies automatically
# Use depends_on for hidden dependencies

resource "aws_instance" "my_instance" {
  depends_on = [
    aws_security_group.my_security_group,
    aws_default_vpc.default
  ]
}
# EC2 won't be created until SG and VPC are ready
```

---

## 6. 🗂️ TF State — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/state

```
How State works:

Terraform code (.tf)        AWS Cloud
      │                         │
      │    terraform apply       │
      └────────────────────────→│ Creates EC2
                                 │
                    terraform.tfstate ← records:
                    - resource ID: i-01c88cc752e4af565
                    - public_ip: 54.225.37.192
                    - arn: arn:aws:ec2:...
                    
      │    terraform plan         │
      └────compare .tf vs state──│
           "no changes" or
           "X to add, Y to change"
```

### State file best practices:
```
✅ Store remotely in S3 (coming in Day 55)
✅ Enable state locking with DynamoDB
✅ Never commit tfstate to git
❌ Never manually edit tfstate
❌ Never delete tfstate
```

---

## 7. 🎯 Interview Questions — Terraform Day 3

**Q1: What is the difference between count and for_each?**
count creates resources by integer index — removing one causes renaming of others. for_each uses keys — each resource has a stable identity. for_each is preferred in production.
Docs: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each

**Q2: What is the purpose of output values?**
Output values expose specific attributes of resources after terraform apply — like EC2 IP, RDS endpoint, S3 bucket name. Can be used by other modules or shown to the user.

**Q3: How do you handle different configurations for dev vs prod?**
Use variables + conditional expressions. Example: `volume_size = var.env == "prod" ? 20 : 10`. Set env via tfvars files or -var flag.

**Q4: What is depends_on and when do you use it?**
Explicit dependency declaration — tells Terraform to create/destroy resources in a specific order. Use when Terraform can't automatically detect the dependency (hidden dependencies).

**Q5: How do you reference an attribute of one resource in another?**
Using resource references: `aws_security_group.my_security_group.id`. Terraform automatically creates an implicit dependency when you reference a resource.
