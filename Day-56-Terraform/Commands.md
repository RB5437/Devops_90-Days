# ⚡ Day 56 — Terraform Commands 

## 🔗 Official References

| Command/Topic | Official Doc |
|--------------|-------------|
| Module Sources | [developer.hashicorp.com/terraform/language/modules/sources](https://developer.hashicorp.com/terraform/language/modules/sources) |
| locals | [developer.hashicorp.com/terraform/language/values/locals](https://developer.hashicorp.com/terraform/language/values/locals) |
| EKS Module | [registry.terraform.io/modules/terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) |
| VPC Module | [registry.terraform.io/modules/terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) |
| terraform init | [developer.hashicorp.com/terraform/cli/commands/init](https://developer.hashicorp.com/terraform/cli/commands/init) |
| terraform plan | [developer.hashicorp.com/terraform/cli/commands/plan](https://developer.hashicorp.com/terraform/cli/commands/plan) |

---

## 📋 TODAY'S EXACT COMMANDS

### Project 1 — Custom Module (Multi-Environment)
```bash
# Navigate to modules-app
cd Day-56-Terraform/modules-app

# Initialize (loads local module from ./infra-app)
terraform init
# Terraform has been successfully initialized!

# Plan — preview all 3 environments
terraform plan
# Plan: 19 to add, 0 to change, 0 to destroy.
# Creates: 4 EC2 + 4 S3 buckets + 4 DynamoDB tables + KeyPairs + SGs

# Apply
terraform apply
# Enter a value: yes
# module.staging-infra.aws_instance.my_instance[0]: Creation complete [id=i-05663fa2786db1f7c]
# module.prod-infra.aws_instance.my_instance[0]: Creation complete [id=i-043e0aed6cae7c8aa]
# module.dev-infra.aws_instance.my_instance[0]: Creation complete [id=i-0d16441547e133fa9]
# module.prod-infra.aws_instance.my_instance[1]: Creation complete [id=i-08744e7f45b9ef7d7]
# Apply complete! Resources: 19 added, 0 changed, 0 destroyed.

# View state
terraform state list
```

### Project 2 — EKS Cluster
```bash
# Navigate to EKS folder
cd ../eks

# Initialize — downloads EKS + VPC modules
terraform init
# Downloading terraform-aws-modules/eks/aws ~> 21.0
# Downloading terraform-aws-modules/vpc/aws
# Terraform has been successfully initialized!

# Plan — preview EKS resources
terraform plan
# Plan: 66 to add, 0 to change, 0 to destroy.
# Creates: VPC + subnets + EKS cluster + node groups + add-ons + IAM roles...

# Apply (takes 15-20 minutes!)
terraform apply
# Enter a value: yes
# Note: EKS cluster creation takes ~15 minutes

# After apply — configure kubectl
aws eks update-kubeconfig --region us-east-1 --name rbb-eks-cluster

# Verify cluster
kubectl get nodes
kubectl get pods -A
```

---

## 📁 CUSTOM MODULE — HCL TEMPLATES

### modules-app/main.tf — call same module 3 times
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

### infra-app/variable.tf — module inputs
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/values/variables
variable "env"            { description = "Environment name";      type = string }
variable "bucket_name"    { description = "S3 bucket name";        type = string }
variable "instance_count" { description = "Number of EC2s";        type = number }
variable "instance_type"  { description = "EC2 instance type";     type = string }
variable "ami_id"         { description = "AMI ID for EC2";        type = string }
variable "hash_key"       { description = "DynamoDB partition key"; type = string }
```

### infra-app/ec2.tf — complete EC2 module
```hcl
# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-infra-app-key"
  public_key = file("terra-key-ec2.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-infra-app-sg"
  description = "Inbound and outbound rules for your instance Security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = { Name = "${var.env}-infra-app-sg" }
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  count      = var.instance_count
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key_pair]

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

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

---

## ☸️ EKS — HCL TEMPLATES

### eks/locals.tf — local variables
```hcl
# Docs: https://developer.hashicorp.com/terraform/language/values/locals
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

### eks/vpc.tf — VPC with intra subnets
```hcl
# Docs: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets  # required for EKS control plane

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = local.env
  }
}
```

### eks/eks.tf — EKS Cluster module
```hcl
# Docs: https://registry.terraform.io/modules/terraform-aws-modules/eks/aws
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                    = local.name
  kubernetes_version      = "1.35"
  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  # Add-ons
  addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true, before_compute = true }
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
      capacity_type  = "SPOT"

      tags = {
        Environment = local.env
        Terraform   = "true"
      }
    }
  }
}
```

---

## 🔧 KUBECTL COMMANDS (After EKS apply)

```bash
# Configure kubectl to use EKS cluster
aws eks update-kubeconfig --region us-east-1 --name rbb-eks-cluster

# Check cluster nodes
kubectl get nodes
kubectl get nodes -o wide

# Check all pods
kubectl get pods -A

# Check cluster info
kubectl cluster-info

# Check namespaces
kubectl get namespaces

# Check add-ons (coredns, kube-proxy etc.)
kubectl get pods -n kube-system
```

---

## 🧹 DESTROY ORDER

```bash
# Step 1: Destroy EKS (takes ~10 minutes)
cd eks/
terraform destroy -auto-approve

# Step 2: Destroy modules app
cd ../modules-app/
terraform destroy -auto-approve

# Step 3: Destroy remote-infra last
cd ../remote-infra/
terraform destroy -auto-approve
```

---

## 📊 Resources Created Today

| Project | Resources | Count |
|---------|-----------|-------|
| Custom Modules App | EC2 + SG + KeyPair + S3 + DynamoDB | 19 total |
| EKS Cluster | VPC + Subnets + EKS + NodeGroup + IAM + Add-ons | 66 total |
| **Grand Total** | | **85 resources** |
