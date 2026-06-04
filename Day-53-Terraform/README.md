# 🟣 Day 53 — Terraform Day 2 | HCL Syntax + Workflow + First Resources

## 📅 Date: 4 June 2026 | #90DaysOfDevOps

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| 🌐 HCL Language Docs | [developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language) |
| 📦 Blocks & Syntax | [developer.hashicorp.com/terraform/language/syntax/configuration](https://developer.hashicorp.com/terraform/language/syntax/configuration) |
| 🧩 Resource Block | [developer.hashicorp.com/terraform/language/resources](https://developer.hashicorp.com/terraform/language/resources) |
| 📥 Variables | [developer.hashicorp.com/terraform/language/values/variables](https://developer.hashicorp.com/terraform/language/values/variables) |
| 📤 Outputs | [developer.hashicorp.com/terraform/language/values/outputs](https://developer.hashicorp.com/terraform/language/values/outputs) |
| 🔌 Providers | [developer.hashicorp.com/terraform/language/providers](https://developer.hashicorp.com/terraform/language/providers) |
| 🔄 Workflow | [developer.hashicorp.com/terraform/intro/core-workflow](https://developer.hashicorp.com/terraform/intro/core-workflow) |
| ☁️ AWS S3 Resource | [registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| 📁 Local Provider | [registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) |
| 🎥 Shubham Video | [youtube.com/watch?v=S9mohJI_R34&t=3100s](https://www.youtube.com/watch?v=S9mohJI_R34&t=3100s) |
| 💾 Course Repo | [github.com/LondheShubham153/terraform-for-devops](https://github.com/LondheShubham153/terraform-for-devops) |

---

## ✅ What I Learned Today

| # | Topic | Timestamp | Status |
|---|-------|-----------|--------|
| 1 | Basic Syntax — Blocks, Arguments, Attributes | [51:40](https://www.youtube.com/watch?v=S9mohJI_R34&t=3100s) | ✅ Done |
| 2 | Types of Blocks — resource, variable, output, provider | [59:06](https://www.youtube.com/watch?v=S9mohJI_R34&t=3546s) | ✅ Done |
| 3 | Terraform Workflow — init → validate → plan → apply | [1:10:24](https://www.youtube.com/watch?v=S9mohJI_R34&t=4224s) | ✅ Done |
| 4 | Local File Resource — first .tf file practice | [1:14:27](https://www.youtube.com/watch?v=S9mohJI_R34&t=4467s) | ✅ Done |
| 5 | AWS S3 Bucket — created via Terraform | [1:23:21](https://www.youtube.com/watch?v=S9mohJI_R34&t=5001s) | ✅ Done |
| 6 | AWS Credentials setup + STS verify | Hands-on | ✅ Done |

---

## 📁 .tf Files — Terraform uses its own language

```
Python    → .py files
Java      → .java files
C++       → .cpp files
Terraform → .tf files  ← HCL (HashiCorp Configuration Language)
```

---

## 🧱 HCL Syntax — Blocks, Arguments, Attributes

### Block Structure:
```
<block_type> <parameters> {
    arguments
}
```

### Example — Terraform block:
```hcl
terraform {                      ← block type
  required_providers {           ← nested block
    aws = {                      ← parameter (args)
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

### Example — Resource block:
```hcl
resource "local_file" "my_file" {    ← block  params  name
  filename = "automate.txt"          ← argument
  content  = "best content for devops - TWS"
}

# Syntax:
# resource  = block type
# "local_file" = resource type (provider)
# "my_file"    = resource name (your label)
# { ... }      = arguments
```

---

## 🧩 Types of Blocks

| Block | Purpose | Docs |
|-------|---------|------|
| `terraform {}` | Configure Terraform itself + required providers | [link](https://developer.hashicorp.com/terraform/language/terraform) |
| `provider {}` | Configure cloud provider (AWS, GCP, Azure) | [link](https://developer.hashicorp.com/terraform/language/providers/configuration) |
| `resource {}` | Create infrastructure (EC2, S3, VPC...) | [link](https://developer.hashicorp.com/terraform/language/resources) |
| `variable {}` | Input variables — parameterize your config | [link](https://developer.hashicorp.com/terraform/language/values/variables) |
| `output {}` | Output values after apply | [link](https://developer.hashicorp.com/terraform/language/values/outputs) |
| `module {}` | Reusable groups of resources | [link](https://developer.hashicorp.com/terraform/language/modules) |
| `data {}` | Read existing infrastructure (not create) | [link](https://developer.hashicorp.com/terraform/language/data-sources) |
| `locals {}` | Local computed variables | [link](https://developer.hashicorp.com/terraform/language/values/locals) |

---

## 🔄 Terraform Workflow — Write → Plan → Apply

```
main.tf
  │
  ├── terraform init      ① Initialize — downloads providers
  │                          Creates: .terraform/ + .terraform.lock.hcl
  │
  ├── terraform validate  ② Validate (optional) — check syntax
  │
  ├── terraform plan      ③ Planning — DRY RUN
  │                          Shows: what will be created/changed/destroyed
  │                          Output: + create  ~ update  - destroy
  │
  └── terraform apply     ④ Apply — actually creates infrastructure
                             Asks for confirmation: "Enter a value: yes"
                             Creates: terraform.tfstate
```

---

## 💻 Practice Done Today

### Project 1 — Local File Resource:

**main.tf:**
```hcl
resource "local_file" "my_file" {
  filename = "automate.txt"
  content  = "Today I my DevOps_90_Days Day 53"
}
```

**Result:**
```
terraform init    → Terraform has been successfully initialized!
terraform validate → Success! The configuration is valid.
terraform plan    → Plan: 1 to add, 0 to change, 0 to destroy.
terraform apply   → local_file.my_file: Creation complete ✅
ls                → automate.txt  main.tf  terraform.tfstate
cat automate.txt  → Today I my DevOps_90_Days Day 53
```

---

### Project 2 — AWS S3 Bucket:

**provider.tf:**
```hcl
provider "aws" {
  region = "us-east-1"
}
```

**s3.tf:**
```hcl
# this is s3 bucket
resource "aws_s3_bucket" "my_devops_bucket" {
  bucket = "devops-terraform-bucket-172313999-2026"
}
```

**terraform.tf:**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

**Result:**
```
terraform init    → Successfully initialized! (AWS provider v6.48.0)
terraform plan    → Plan: 1 to add, 0 to change, 0 to destroy.
terraform apply   → aws_s3_bucket.my_devops_bucket: Creation complete ✅
                    [id=devops-terraform-bucket-172313999-2026]
```

**S3 bucket visible in AWS Console** ✅
`devops-terraform-bucket-172313999-2026` — US East (N. Virginia) us-east-1

---

## 📊 Files Created After terraform apply

```
Day-53-Terraform/
├── automate.txt          ← created by local_file resource
├── main.tf               ← your Terraform code
├── provider.tf           ← AWS provider config
├── s3.tf                 ← S3 bucket resource
├── terraform.tf          ← terraform block + required_providers
├── terraform.tfstate     ← STATE FILE (tracks what exists)
└── terraform.tfstate.backup  ← previous state backup
```

---

## 🗺️ Progress Tracker

| Topic | Days | Status |
|-------|------|--------|
| Linux → Docker → Jenkins → K8s → Helm → ArgoCD | Done | ✅ |
| **Terraform Day 1** | Day 52 | ✅ Done |
| **Terraform Day 2** | Day 53 | ✅ Today |
| Terraform Day 3-5 | Day 54-56 | ⬜ |
| Prometheus + Grafana | Day 57-60 | ⬜ |

---

## 📂 My GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)
