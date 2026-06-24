# Day 70 — Project 2 Planning: Terraform Multi-Environment AWS Infrastructure 🏗️

> **Status: Watched reference video + architecture understood — implementation not started yet**
> **Reference:** TrainWithShubham — "I coded Terraform to Create Multi-Environment AWS Infrastructure in 1 Hour (Hindi)"

---

## Project Name

**Terraform Multi-Environment Infrastructure**
*"One Codebase, Three Environments — Dev, Staging, Production"*

---

## Real World Problem It Solves

In every real company, an application never goes directly from a developer's laptop to production. It moves through stages:

```
Dev (developers test freely, break things)
   ↓
Staging (near-identical to production, final testing)
   ↓
Production (real users, must be stable and scaled)
```

**The problem:** Writing separate Terraform code for each environment leads to copy-paste duplication, drift between environments, and human error (e.g. forgetting to add a resource in staging that exists in prod). This project solves that by using **one reusable Terraform codebase** that provisions different-sized infrastructure per environment, just by changing input variables.

---

## Skills Used in This Project

| Skill | Where It's Used |
|-------|------------------|
| Terraform | Core IaC tool — modules, variables, workspaces |
| AWS | S3, RDS (DB), EC2 — provisioned per environment |
| Git/GitHub | Version-controlled infra code, environment branches/folders |
| Linux | Running Terraform CLI, managing state files |

---

## Architecture — Three Environments, One Codebase

As shown in the reference diagram, each environment gets its own isolated set of resources, scaled appropriately for its purpose:

### DEV Environment
| Resource | Count | Purpose |
|----------|-------|---------|
| S3 | 1 | Storage for dev artifacts/logs |
| DB (RDS) | 1 | Single small database instance |
| EC2 | 1 | Single small compute instance |

### STAGING Environment
| Resource | Count | Purpose |
|----------|-------|---------|
| S3 | 1 | Storage, same pattern as dev |
| DB (RDS) | 1 | Single database — mirrors prod schema |
| EC2 | 1 | Single instance — final testing before prod |

### PRODUCTION Environment
| Resource | Count | Purpose |
|----------|-------|---------|
| S3 | 2 | Redundant storage |
| DB (RDS) | 1 | Production database (typically with Multi-AZ in real setups) |
| EC2 | 3 | Multiple instances — high availability, load distribution |

```
                    Terraform (single codebase)
                            │
        ┌───────────────────┼───────────────────┐
        ▼                   ▼                   ▼
   ┌─────────┐         ┌─────────┐         ┌──────────┐
   │   DEV   │         │   STG   │         │   PROD   │
   │ S3 x1   │         │ S3 x1   │         │ S3 x2    │
   │ DB x1   │         │ DB x1   │         │ DB x1    │
   │ EC2 x1  │         │ EC2 x1  │         │ EC2 x3   │
   └─────────┘         └─────────┘         └──────────┘
```

---

## How This Will Be Built (Planned Approach)

### Option A — Terraform Workspaces
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
terraform workspace select dev
terraform apply -var-file="dev.tfvars"
```

### Option B — Folder-per-environment with shared modules
```
terraform-multi-env/
├── modules/
│   ├── ec2/
│   ├── s3/
│   └── rds/
├── environments/
│   ├── dev/
│   │   └── main.tf (calls modules with dev.tfvars)
│   ├── staging/
│   │   └── main.tf (calls modules with staging.tfvars)
│   └── prod/
│       └── main.tf (calls modules with prod.tfvars)
```

**Why modules matter here:** Instead of writing EC2/S3/RDS resource blocks three separate times, the same module is called three times with different variables (instance count, instance size) — this is the core Terraform concept (Day 55-56 from the original 90-day roadmap) being applied to a real multi-environment use case.

---

## Variables That Will Differ Per Environment

| Variable | Dev | Staging | Prod |
|----------|-----|---------|------|
| `ec2_instance_count` | 1 | 1 | 3 |
| `ec2_instance_type` | t2.micro | t2.micro | t3.medium |
| `s3_bucket_count` | 1 | 1 | 2 |
| `db_instance_class` | db.t3.micro | db.t3.micro | db.t3.medium |
| `environment_tag` | dev | staging | prod |

---

## Why This Project Matters for Interview

> "Most beginner Terraform projects provision a single environment. This one demonstrates understanding of how real teams manage infrastructure lifecycle — using a single, DRY (Don't Repeat Yourself) codebase with reusable modules to provision differently-sized environments for dev, staging, and production, rather than duplicating code three times."

This also directly connects to GitOps and CI/CD concepts already covered in the Day 68 capstone — in a real pipeline, merging to a `dev` branch could trigger `terraform apply` against the dev workspace, while merging to `main` triggers production.

---

## What's NOT Done Yet (Honest Status)

- ❌ No `.tf` files written yet
- ❌ No AWS resources provisioned
- ❌ No state file/backend configured
- ✅ Reference video watched and understood
- ✅ Architecture and environment-scaling logic mapped out

---

## Next Steps (Day 71 onwards for this project)

| Day | Task |
|-----|------|
| Next | Write base Terraform modules (EC2, S3, RDS) |
| Then | Create `dev.tfvars`, `staging.tfvars`, `prod.tfvars` |
| Then | Set up remote state backend (S3 + DynamoDB lock) |
| Then | Apply to dev first, verify, then staging, then prod |
| Finally | Document + LinkedIn post with live resource screenshots |

---

## Official Links

| Resource | Link |
|----------|------|
| Reference Video | TrainWithShubham — "I coded Terraform to Create Multi-Environment AWS Infrastructure in 1 Hour (Hindi)" |
| Terraform Workspaces Docs | https://developer.hashicorp.com/terraform/language/state/workspaces |
| Terraform Modules Docs | https://developer.hashicorp.com/terraform/language/modules |
