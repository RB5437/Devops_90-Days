# 🟣 Day 52 — Terraform Day 1 | Core Concepts + Setup

## 📅 Date: 3 June 2026 | #90DaysOfDevOps

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| 🌐 Official Website | [terraform.io](https://www.terraform.io) |
| 📚 Official Docs | [developer.hashicorp.com/terraform/docs](https://developer.hashicorp.com/terraform/docs) |
| 📥 Install Guide | [developer.hashicorp.com/terraform/install](https://developer.hashicorp.com/terraform/install) |
| 🧩 Terraform Registry | [registry.terraform.io](https://registry.terraform.io) |
| ☁️ AWS Provider Docs | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| 🎓 Official Tutorials | [developer.hashicorp.com/terraform/tutorials](https://developer.hashicorp.com/terraform/tutorials) |
| 🚀 AWS Get Started | [Terraform + AWS Tutorial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) |
| 💻 CLI Docs | [developer.hashicorp.com/terraform/cli](https://developer.hashicorp.com/terraform/cli) |
| 📦 Downloads | [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/) |
| 🐙 GitHub | [github.com/hashicorp/terraform](https://github.com/hashicorp/terraform) |
| 📝 Changelog | [CHANGELOG.md](https://github.com/hashicorp/terraform/blob/main/CHANGELOG.md) |
| 🔓 OpenTofu (OSS Fork) | [opentofu.org](https://opentofu.org) |
| 📜 BSL License FAQ | [hashicorp.com/license-faq](https://www.hashicorp.com/license-faq) |

## 🎥 Learning Resource

| Resource | Link |
|----------|------|
| 📹 Shubham Londhe — Terraform One Shot | [YouTube](https://www.youtube.com/watch?v=S9mohJI_R34) |
| 💾 Course Code Repository | [github.com/LondheShubham153/terraform-for-devops](https://github.com/LondheShubham153/terraform-for-devops) |
| 📂 My GitHub | [github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days) |

---

## ✅ What I Learned Today

| # | Topic | Timestamp | Status |
|---|-------|-----------|--------|
| 1 | Definition & History of Terraform | [00:00](https://www.youtube.com/watch?v=S9mohJI_R34) | ✅ Done |
| 2 | Current Trends & News in Terraform Development | [07:59](https://www.youtube.com/watch?v=S9mohJI_R34&t=479s) | ✅ Done |
| 3 | Infrastructure as Code (IaC) — Why It Matters | [12:35](https://www.youtube.com/watch?v=S9mohJI_R34&t=755s) | ✅ Done |
| 4 | Comparison with Other Tools | [22:26](https://www.youtube.com/watch?v=S9mohJI_R34&t=1346s) | ✅ Done |
| 5 | Terraform vs Ansible | [24:31](https://www.youtube.com/watch?v=S9mohJI_R34&t=1471s) | ✅ Done |
| 6 | Terraform vs CloudFormation | [27:58](https://www.youtube.com/watch?v=S9mohJI_R34&t=1678s) | ✅ Done |
| 7 | Setup on AWS EC2 & Local Machine (Windows) | [33:54](https://www.youtube.com/watch?v=S9mohJI_R34&t=2034s) | ✅ Done |

---

## 🟣 What is Terraform?

```
Terraform = IaC (Infrastructure as Code) Tool
           by HashiCorp

Provision → Create infrastructure
           (EC2, S3, VPC, RDS, EKS...)

Write code → terraform apply → Infrastructure ready!
```

- **Founded:** 2014 (HashiCorp)
- **Open Source:** 2014–2023 (MPL License)
- **License Change:** 2023 → BSL (Business Source License) → [FAQ](https://www.hashicorp.com/license-faq)
- **2025:** IBM acquired HashiCorp → RedHat/Ansible team
- **OpenTofu:** Community open-source fork → [opentofu.org](https://opentofu.org)

---

## 🏗️ Why IaC? — The Problem Before Terraform

### Old Way (Before 2019):
```
Business → Business Analyst → Solution Architect
                                      ↓
                          Infrastructure Team:
                          - Field Engineers
                          - System/NW Admins
                          - Storage Admins
                          - Backup Admins
                          - Application Team
                                      ↓
                             Data Center / VMware
```

**Problems with old way:**
| Problem | Impact |
|---------|--------|
| Slow Deployment | Weeks to provision servers |
| Expensive | Large infra team needed |
| Limited Automation | Manual clicks everywhere |
| Human Error | Wrong configs, missed steps |
| Inconsistency | Dev ≠ Staging ≠ Prod |
| Wasted Resources | Over-provisioning common |

### New Way (With Terraform):
```
Code → terraform plan → terraform apply → Infrastructure on AWS/Azure/GCP
         (preview)        (create)            (in minutes!)
```

---

## ⚔️ Terraform vs Ansible vs CloudFormation

| Feature | Terraform | Ansible | CloudFormation |
|---------|-----------|---------|----------------|
| Type | IaC (Provisioning) | Configuration Management | IaC (AWS only) |
| Language | HCL | YAML | JSON/YAML |
| State | Yes (stateful) | No (stateless) | Yes (AWS managed) |
| Cloud Support | Multi-cloud | Multi-cloud | AWS only |
| Agentless | Yes | Yes | Yes |
| Best for | Infrastructure creation | App config/deploy | AWS-only shops |
| Docs | [terraform.io](https://www.terraform.io) | [ansible.com](https://www.ansible.com) | [aws.amazon.com/cloudformation](https://aws.amazon.com/cloudformation) |

### Simple Rule:
```
Terraform = CREATE infrastructure (EC2, VPC, RDS)
Ansible   = CONFIGURE infrastructure (install nginx, set users)

They complement each other — use BOTH!
```

---

## 🖥️ Setup Done Today

### Windows (Local Machine) — PowerShell:
```powershell
# Download from: https://releases.hashicorp.com/terraform/
# Or: https://developer.hashicorp.com/terraform/install

terraform -version
# Terraform v1.15.5
# on windows_amd64
```

### Linux (AWS EC2 — Ubuntu):
```bash
# Full install guide: https://developer.hashicorp.com/terraform/install

# Step 1: Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Step 2: Add repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Step 3: Install
sudo apt update && sudo apt install terraform -y

# Verify
terraform --version
# Terraform v1.15.5
# on linux_amd64
```

---

## 🗺️ Progress Tracker

| Topic | Days | Status |
|-------|------|--------|
| Linux → Networking → Shell → Git → AWS → Docker → Jenkins → K8s → Helm → ArgoCD | Done | ✅ |
| **Terraform** | Day 52-56 | 🔄 Day 52 Today |
| Prometheus + Grafana | Day 57-60 | ⬜ |
| GenAI | Day 61-63 | ⬜ |

---

## 📂 My GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)
