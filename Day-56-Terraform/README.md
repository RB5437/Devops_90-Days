# 🟣 Day 56 — Terraform Day 5 | Custom Modules + EKS Cluster Project

## 📅 Date: 7 June 2026 | #90DaysOfDevOps

---

## 🔗 Official Resources

| Resource | Link |
|----------|------|
| 📦 Modules Overview | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| 🏗️ Module Structure | [developer.hashicorp.com/terraform/language/modules/develop](https://developer.hashicorp.com/terraform/language/modules/develop) |
| 📋 locals block | [developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals) |
| ☸️ EKS Module | [registry.terraform.io/modules/terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) |
| 🌐 VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |
| 🔌 AWS Provider v6 | [registry.terraform.io/providers/hashicorp/aws/latest](https://registry.terraform.io/providers/hashicorp/aws/latest) |


---

## ✅ What I Learned Today

| # | Topic | Timestamp | Status |
|---|-------|-----------|--------|
| 1 | Custom Modules — structure + best practices | [05:29:00](https://www.youtube.com/watch?v=S9mohJI_R34&t=19740s) | ✅ Done |
| 2 | Multi-environment modules — Dev/Staging/Prod | [05:46:37](https://www.youtube.com/watch?v=S9mohJI_R34&t=20797s) | ✅ Done |
| 3 | locals block — local computed values | [06:45:41](https://www.youtube.com/watch?v=S9mohJI_R34&t=24341s) | ✅ Done |
| 4 | EKS Cluster via Terraform + VPC module | [06:23:00](https://www.youtube.com/watch?v=S9mohJI_R34&t=22980s) | ✅ Done |
| 5 | EKS managed node groups + add-ons | Hands-on | ✅ Done |
| 6 | Plan: 66 resources for full EKS setup | Hands-on | ✅ Done |

---

## 📦 Project 1 — Custom Modules (Multi-Environment)

### Architecture:
```
DevOps Engineer
      │
      ├── Terraform (main.tf)
      │       │
      │       ├── module "dev-infra"     → Dev   (t3.nano,  1 instance)
      │       ├── module "prod-infra"    → Prod  (t3.micro, 2 instances)
      │       └── module "staging-infra" → Stg   (t3.small, 1 instance)
      │
      └── infra-app/ (custom module)
              ├── ec2.tf      → KeyPair + SG + EC2
              ├── s3.tf       → S3 bucket per env
              ├── dynamodb.tf → DynamoDB per env
              └── variable.tf → all input variables
```

### Project Structure:
```
modules-app/
├── main.tf           ← calls module 3 times (dev/prod/stg)
├── provider.tf
├── terraform.tf
└── infra-app/        ← custom reusable module
    ├── ec2.tf
    ├── s3.tf
    ├── dynamodb.tf
    └── variable.tf
```

### main.tf — 3 environments, 1 module:
```hcl
# Dev infrastructure
module "dev-infra" {
  source         = "./infra-app"
  env            = "dev"
  bucket_name    = "rbb-infra-app-bucket"
  instance_count = 1
  instance_type  = "t3.nano"
  ami_id         = "ami-091138d0f0d41ff90"
  hash_key       = "studentID"
}

# Prod infrastructure
module "prod-infra" {
  source         = "./infra-app"
  env            = "prod"
  bucket_name    = "rbb-infra-app-bucket"
  instance_count = 2
  instance_type  = "t3.micro"
  ami_id         = "ami-091138d0f0d41ff90"
  hash_key       = "studentID"
}

# Staging infrastructure
module "staging-infra" {
  source         = "./infra-app"
  env            = "staging"
  bucket_name    = "rbb-infra-app-bucket"
  instance_count = 1
  instance_type  = "t3.small"
  ami_id         = "ami-091138d0f0d41ff90"
  hash_key       = "studentID"
}
```

### infra-app/variable.tf — module inputs:
```hcl
variable "env"            { type = string }
variable "bucket_name"    { type = string }
variable "instance_count" { type = number }
variable "instance_type"  { type = string }
variable "ami_id"         { type = string }
variable "hash_key"       { type = string }
```

### infra-app/ec2.tf — dynamic naming per env:
```hcl
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-infra-app-key"  # dev-infra-app-key
  public_key = file("terra-key-ec2.pub")
}

resource "aws_security_group" "my_security_group" {
  name = "${var.env}-infra-app-sg"        # dev-infra-app-sg

  ingress { from_port = 22,  to_port = 22,  protocol = "tcp" }
  ingress { from_port = 80,  to_port = 80,  protocol = "tcp" }
  egress  { from_port = 0,   to_port = 0,   protocol = "-1"  }
}

resource "aws_instance" "my_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.env == "prod" ? 20 : 10  # prod=20GB, others=10GB
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.env}-infra-app-instance"
    Environment = var.env
  }
}
```

### Results — Apply complete! Resources: 19 added ✅

**4 EC2 instances created:**
| Instance | Type | Environment | IP |
|----------|------|-------------|-----|
| staging-infra-app | t3.small | Staging | 44.200.122.117 |
| prod-infra-app | t3.micro | Prod | 54.89.117.107 |
| prod-infra-app | t3.micro | Prod | 54.80.145.97 |
| dev-infra-app | t3.nano | Dev | 44.200.112.12 |

**4 S3 Buckets + 4 DynamoDB Tables created:**
- dev-rbb-infra-app-bucket
- prod-rbb-infra-app-bucket
- staging-rbb-infra-app-bucket
- rbb-remote-s3-bucket-1

---

## ☸️ Project 2 — EKS Cluster via Terraform

### What is EKS?
```
Terraform → EKS Cluster
              ├── K8s Control Plane (managed by AWS)
              │     ├── Cloud Controller Manager (AWS)
              │     ├── API Server
              │     ├── etcd
              │     ├── Scheduler
              │     └── Controller Manager
              │
              └── Worker Nodes (EC2 t2.medium SPOT)
                    ├── Node 1: Docker → Pods → Apps
                    └── Node 2: Docker → Pods → Apps
```

### EKS Project Structure:
```
terraform-eks/
├── eks.tf      ← EKS cluster + managed node groups
├── vpc.tf      ← VPC module (private/public/intra subnets)
├── locals.tf   ← local variables (name, region, CIDRs)
├── provider.tf
└── terraform.tf
```

### locals.tf — local variables:
```hcl
locals {
  region          = "us-east-1"
  name            = "rbb-eks-cluster"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  intra_subnets   = ["10.0.5.0/24", "10.0.6.0/24"]
  env             = "dev"
}
```

### eks.tf — EKS Cluster module:
```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name          # rbb-eks-cluster
  kubernetes_version = "1.35"
  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  # EKS Add-ons
  addons = {
    coredns                = { most_recent = true }
    kube-proxy             = { most_recent = true }
    vpc-cni                = { most_recent = true, before_compute = true }
    eks-pod-identity-agent = { most_recent = true, before_compute = true }
  }

  # Networking
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Managed Node Groups
  eks_managed_node_groups = {
    rbb_cluster_node_group = {
      min_size       = 2
      max_size       = 3
      desired_size   = 2
      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"      # cost saving!
    }
  }
}
```

### vpc.tf — VPC with intra subnets for EKS:
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets  # for EKS control plane

  enable_nat_gateway = true
  enable_vpn_gateway = true
}
```

**Plan: 66 resources to add** for complete EKS setup!

---

## 📊 Terraform Series Complete! ✅

| Day | Topic | Status |
|-----|-------|--------|
| Day 52 | Intro + Setup + IaC concepts | ✅ |
| Day 53 | HCL Syntax + Local file + S3 | ✅ |
| Day 54 | Variables + for_each + EC2 Project | ✅ |
| Day 55 | Remote Backend + Workspaces + Modules | ✅ |
| Day 56 | Custom Modules + EKS Cluster | ✅ |

**Next: Prometheus + Grafana (Day 57)** 🔄

---

## 📂 My GitHub
[https://github.com/RB5437/Devops_90-Days](https://github.com/RB5437/Devops_90-Days)
