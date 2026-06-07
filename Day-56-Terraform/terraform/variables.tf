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
  description = "The environment for the resources (e.g., dev, staging, prod)"
  default     = "prod"
  type        = string
}