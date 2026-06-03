# 📝 Day 52 — Terraform Notes (Deep Concepts)

## 🔗 Quick Reference Links

| Topic | Official Doc |
|-------|-------------|
| Terraform Overview | [developer.hashicorp.com/terraform/intro](https://developer.hashicorp.com/terraform/intro) |
| HCL Language Docs | [developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language) |
| Providers | [developer.hashicorp.com/terraform/language/providers](https://developer.hashicorp.com/terraform/language/providers) |
| Resources | [developer.hashicorp.com/terraform/language/resources](https://developer.hashicorp.com/terraform/language/resources) |
| State | [developer.hashicorp.com/terraform/language/state](https://developer.hashicorp.com/terraform/language/state) |
| AWS Provider | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| Terraform Registry | [registry.terraform.io](https://registry.terraform.io) |
| BSL License FAQ | [hashicorp.com/license-faq](https://www.hashicorp.com/license-faq) |
| OpenTofu (Fork) | [opentofu.org/docs](https://opentofu.org/docs) |

---

## 1. 🟣 What is Terraform — Full Picture

**Terraform** is an open-source IaC tool by HashiCorp.
📖 Docs: [developer.hashicorp.com/terraform/intro](https://developer.hashicorp.com/terraform/intro)

```
You write .tf files  →  terraform init   →  downloads providers
                     →  terraform plan   →  shows what will change
                     →  terraform apply  →  creates real infrastructure
                     →  terraform destroy → deletes infrastructure
```

**Key word: DECLARATIVE**
- You say WHAT you want, not HOW to do it
- Terraform figures out the HOW

```hcl
# You write this (WHAT):
resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
}
# Terraform calls AWS API → Creates EC2 → Updates state file
```

---

## 2. 📅 Terraform History Timeline
📖 Full history: [github.com/hashicorp/terraform/blob/main/CHANGELOG.md](https://github.com/hashicorp/terraform/blob/main/CHANGELOG.md)

```
2014        →  HashiCorp creates Terraform (Open Source MPL License)
2014–2017   →  OSS phase — community grows rapidly, IaC Tool + Ansible
2023        →  License → BSL (Business Source License)
               Cannot use commercially without permission
               → FAQ: https://www.hashicorp.com/license-faq
2023        →  OpenTofu fork created by community → https://opentofu.org
2025        →  IBM acquires HashiCorp
               RedHat/Ansible team takes over
```

**Why BSL matters for interviews:**
- Companies may switch to OpenTofu (open-source fork)
- Both use same HCL syntax — skills are 100% transferable
- OpenTofu docs: [opentofu.org/docs](https://opentofu.org/docs)

---

## 3. 🏗️ IaC — Why It Matters
📖 Docs: [developer.hashicorp.com/terraform/intro/core-workflow](https://developer.hashicorp.com/terraform/intro/core-workflow)

**Problems IaC solves:**

| Problem | Before | After (Terraform) |
|---------|--------|-------------------|
| Slow Deployment | Ticket → 2 weeks | terraform apply → 5 min |
| Human Error | Admin forgot SG → breach | Code reviewed + version controlled |
| Inconsistency | Dev ≠ Prod | Same code → identical envs |
| No Audit Trail | Who changed firewall? Nobody knows | Git history tracks everything |
| Disaster Recovery | Rebuild manually → weeks | terraform apply → minutes |

---

## 4. ⚔️ Terraform vs Ansible — Deep Dive
📖 Terraform docs: [developer.hashicorp.com/terraform/intro/vs/chef-puppet](https://developer.hashicorp.com/terraform/intro/vs/chef-puppet)
📖 Ansible docs: [docs.ansible.com](https://docs.ansible.com)

### Terraform (Provisioning / IaC)
```
Purpose:  CREATE and MANAGE infrastructure
Approach: Declarative — say WHAT you want
State:    YES — tracks what exists in terraform.tfstate
Tasks:    Create VPC, EC2, RDS, S3, EKS
```

### Ansible (Configuration Management / CFM)
```
Purpose:  CONFIGURE existing infrastructure
Approach: Procedural — step by step HOW
State:    NO — runs tasks every time
Tasks:    Install nginx, copy configs, start services
```

### Real-world combined workflow:
```
Step 1 (Terraform): terraform apply → Create EC2
Step 2 (Ansible):   ansible-playbook → Install Docker on EC2
Step 3 (Ansible):   ansible-playbook → Deploy app container
Step 4 (Terraform): terraform apply → Create ALB, point to EC2
```

---

## 5. ☁️ Terraform vs CloudFormation
📖 Terraform vs CFN: [developer.hashicorp.com/terraform/intro/vs/cloudformation](https://developer.hashicorp.com/terraform/intro/vs/cloudformation)
📖 CloudFormation docs: [docs.aws.amazon.com/cloudformation](https://docs.aws.amazon.com/cloudformation/index.html)

| | Terraform | CloudFormation |
|--|-----------|----------------|
| Vendor | HashiCorp (multi-cloud) | AWS (AWS-only) |
| Language | HCL (clean) | JSON/YAML (verbose) |
| Multi-cloud | ✅ AWS + Azure + GCP + k8s | ❌ AWS only |
| State management | Local file / S3 | AWS managed |
| Import existing | terraform import | Limited support |
| Community | Very large | AWS community only |
| Cost | Free (BSL) | Free (AWS service) |

---

## 6. 🌍 Terraform Multi-Cloud Providers
📖 All providers: [registry.terraform.io/browse/providers](https://registry.terraform.io/browse/providers)

```
registry.terraform.io has 3000+ providers:
    ├── AWS        → registry.terraform.io/providers/hashicorp/aws
    ├── Azure      → registry.terraform.io/providers/hashicorp/azurerm
    ├── GCP        → registry.terraform.io/providers/hashicorp/google
    ├── Kubernetes → registry.terraform.io/providers/hashicorp/kubernetes
    ├── GitHub     → registry.terraform.io/providers/integrations/github
    ├── Datadog    → registry.terraform.io/providers/datadog/datadog
    └── 3000+ more...
```

---

## 7. 🖥️ Setup Summary
📖 Install guide: [developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install)
📦 Downloads: [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/)

| Environment | Version | Status |
|------------|---------|--------|
| Windows PowerShell (Local) | v1.15.5 windows_amd64 | ✅ Done |
| Linux Ubuntu (AWS EC2) | v1.15.5 linux_amd64 | ✅ Done |

---

## 8. 🎯 Interview Questions — Terraform Day 1

**Q1: What is Terraform?**
IaC tool by HashiCorp for provisioning infrastructure using declarative HCL. Supports 3000+ providers. Docs: [developer.hashicorp.com/terraform/intro](https://developer.hashicorp.com/terraform/intro)

**Q2: Terraform vs Ansible?**
Terraform = provisioning (create infra). Ansible = configuration management (configure infra). Use both together. Reference: [developer.hashicorp.com/terraform/intro/vs](https://developer.hashicorp.com/terraform/intro/vs/chef-puppet)

**Q3: What is BSL license change?**
2023 — HashiCorp changed MPL → BSL restricting commercial use. Community forked as OpenTofu ([opentofu.org](https://opentofu.org)). Both use same HCL. FAQ: [hashicorp.com/license-faq](https://www.hashicorp.com/license-faq)

**Q4: What problems does IaC solve?**
Slow deployment, human errors, environment inconsistency, no audit trail, poor disaster recovery.

**Q5: What is declarative vs imperative?**
Declarative (Terraform): Say WHAT — tool decides HOW. Imperative (scripts): You specify each step HOW. Docs: [developer.hashicorp.com/terraform/language](https://developer.hashicorp.com/terraform/language)
