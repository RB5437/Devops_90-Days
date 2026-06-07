variable "env" {
    description = "This is  environment  for my infra"
    type        = string
  
}

variable  "bucket_name" {
    description = "This is  bucket name for my s3 bucket"
    type        = string
  
}


variable "instance_count" {
    description = "Number of EC2 instances "
    type        = number
}


variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type        = string
}

variable "hash_key" {
    description = "Hash key for DynamoDB table"
    type        = string
}