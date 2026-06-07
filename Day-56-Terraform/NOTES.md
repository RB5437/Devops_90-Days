# 📝 Day 56 — Terraform Notes (Custom Modules + EKS)

## 🔗 Quick Reference Links

| Topic | Official Doc |
|-------|-------------|
| Modules | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| Module Structure | [developer.hashicorp.com/terraform/language/modules/develop/structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) |
| locals | [developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals) |
| Module Sources | [developer.hashicorp.com/terraform/language/modules/sources](https://developer.hashicorp.com/terraform/language/modules/sources) |
| EKS Module | [registry.terraform.io/modules/terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) |
| VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |
| EKS Docs | [docs.aws.amazon.com/eks](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) |

---

## 1. 📦 Custom Modules — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/modules/develop

### What is a custom module?
```
Custom module = Your own reusable terraform code

Like a function in programming:
  def create_infra(env, instance_type, count):
      # creates EC2, S3, DynamoDB
      pass

  create_infra("dev",  "t3.nano",  1)
  create_infra("prod", "t3.micro", 2)
  create_infra("stg",  "t3.small", 1)

Equivalent in Terraform:
  module "dev-infra"  { source = "./infra-app", env = "dev"  }
  module "prod-infra" { source = "./infra-app", env = "prod" }
  module "stg-infra"  { source = "./infra-app", env = "stg"  }
```

### Module directory structure:
```
infra-app/          ← module folder
├── ec2.tf          ← EC2, SG, KeyPair resources
├── s3.tf           ← S3 bucket resource
├── dynamodb.tf     ← DynamoDB table resource
└── variable.tf     ← ALL input variables declared here

main.tf             ← root module (calls infra-app)
```

### Module source types:
```hcl
# Local path (what we built today)
source = "./infra-app"

# Terraform Registry (used yesterday)
source = "terraform-aws-modules/vpc/aws"

# GitHub
source = "github.com/username/repo"

# Git with tag
source = "git::https://github.com/user/repo.git?ref=v1.0.0"
```

---

## 2. 🔡 locals block — Deep Dive
📖 Docs: https://developer.hashicorp.com/terraform/language/values/locals

### What are locals?
```
locals = computed values inside Terraform
       = like const variables in programming

vs variables:
  variable = INPUT from outside (user provides)
  local    = COMPUTED inside your code (you define)
```

### locals syntax:
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

# Reference locals with local.<name>:
name = local.name        # "rbb-eks-cluster"
cidr = local.vpc_cidr    # "10.0.0.0/16"
```

### locals vs variables — when to use:
```
Use variable when:    value comes from outside (user/tfvars)
Use local when:       value is computed from other values

Example:
variable "env" { default = "prod" }

locals {
  full_name = "${var.env}-my-cluster"  # computed from variable
  is_prod   = var.env == "prod"        # boolean computed value
}
```

---

## 3. 🏗️ Custom Module Design — Best Practices
📖 Docs: https://developer.hashicorp.com/terraform/language/modules/develop/structure

### Module design pattern used today:
```
Pattern: One module → Multiple environments

infra-app module accepts:
  env            → used in resource naming (${var.env}-infra-app-sg)
  instance_count → how many EC2s
  instance_type  → what size EC2
  bucket_name    → S3 bucket name
  ami_id         → which Ubuntu AMI
  hash_key       → DynamoDB partition key

Benefits:
✅ Write once, deploy many
✅ Environment-specific naming (dev-sg vs prod-sg)
✅ Different configs per env (prod gets 20GB, others 10GB)
✅ Count-based EC2 (prod=2, dev=1, staging=1)
```

### Dynamic resource naming:
```hcl
# Instead of hardcoding:
name = "my-security-group"  ← same for all envs!

# Use variable interpolation:
name = "${var.env}-infra-app-sg"
# → "dev-infra-app-sg"
# → "prod-infra-app-sg"
# → "staging-infra-app-sg"
```

---

## 4. ☸️ EKS — Elastic Kubernetes Service

### What is EKS?
```
EKS = AWS managed Kubernetes service

Without EKS (self-managed):
  - Install kubeadm manually
  - Set up etcd, API server, controller manager
  - Manage upgrades yourself
  - Very complex!

With EKS:
  - AWS manages control plane
  - You just define worker node groups
  - Automatic upgrades available
  - Highly available by default
```

### EKS Architecture:
```
AWS Cloud
  │
  └── EKS Cluster
        │
        ├── Control Plane (AWS managed — you don't see these)
        │     ├── Cloud Controller Manager (AWS-specific)
        │     ├── API Server (kubectl talks to this)
        │     ├── etcd (cluster state database)
        │     ├── Scheduler (assigns pods to nodes)
        │     └── Controller Manager (manages resources)
        │
        └── Worker Nodes (EC2 — you manage these)
              ├── Node 1 (t2.medium SPOT)
              │     └── Docker → Pods → Apps
              └── Node 2 (t2.medium SPOT)
                    └── Docker → Pods → Apps
```

### EKS Add-ons explained:
```
coredns             → DNS for pods (service discovery)
kube-proxy          → Network rules on each node
vpc-cni             → AWS VPC networking for pods
                      (before_compute = true: deploy before nodes!)
eks-pod-identity-agent → IAM permissions at pod level
                         (replaces old IRSA approach)
```

### EKS Node Group — SPOT vs ON-DEMAND:
```
ON-DEMAND:
  - Always available
  - Fixed price
  - For production critical workloads

SPOT (what we used):
  - Up to 90% cheaper
  - Can be interrupted by AWS
  - For dev/test/batch workloads
  - capacity_type = "SPOT"
```

### Subnet types for EKS:
```
public_subnets  → Load balancers, NAT gateway
private_subnets → Worker nodes (EC2) — no direct internet
intra_subnets   → EKS control plane communication
                  (isolated, no internet access)
```

---

## 5. 🔁 Terraform Ansible Integration
📖 Reference: https://github.com/LondheShubham153/terraform-ansible-multi-env

```
Shubham's project diagram:

Inventories (dev, stg, prod)
      │
      ├── Ansible (configuration)
      │
DevOps Engineer
      │
      ├── Terraform (provisioning)
      │       │
      │       ├── Dev    → t2.micro
      │       ├── Stg    → t2.micro
      │       └── Prod   → t2.micro
      │
      └── (Terraform creates infra,
           Ansible configures it)
```

---

## 6. 🎯 Interview Questions — Terraform Day 5

**Q1: What is a Terraform module?**
A reusable group of resources. Write once, use multiple times with different variables. Can be local (./my-module) or from Terraform Registry (terraform-aws-modules/vpc/aws).

**Q2: Difference between locals and variables?**
Variables are inputs provided from outside (user/tfvars). Locals are values computed inside Terraform code — like constants or derived values. Both referenced differently: `var.name` vs `local.name`.

**Q3: What is EKS and why use it?**
Elastic Kubernetes Service — AWS managed K8s. AWS manages the control plane (etcd, API server, scheduler). You only manage worker nodes via managed node groups. Eliminates operational overhead of self-managed K8s.

**Q4: What are EKS managed node groups?**
Auto Scaling Groups of EC2 instances managed by EKS. AWS handles node provisioning, updates, and termination. Can use SPOT instances for cost savings. Configured with min/max/desired sizes.

**Q5: Why use SPOT instances in EKS node groups?**
SPOT instances are up to 90% cheaper than ON-DEMAND. Best for dev/test environments and fault-tolerant workloads. Risk: AWS can reclaim them with 2 minutes notice. Set min_size ensures cluster remains functional.

**Q6: What are EKS add-ons?**
Operational software installed on EKS cluster: coredns (DNS), kube-proxy (network rules), vpc-cni (AWS networking), eks-pod-identity-agent (IAM for pods). `before_compute = true` ensures vpc-cni installs before worker nodes start.
