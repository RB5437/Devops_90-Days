
# Key Value pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-infra-app-key"
  public_key = file("terra-key-ec2.pub")
}

# VPC Default
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-infra-app-sg"
  description = "this is Inbound and outbound rules for your instance Security group"
  vpc_id      = aws_default_vpc.default.id

  # Inbound rules
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

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  
  }

  tags = {
    Name = "${var.env}-infra-app-sg"
  }

}

# EC2 instance
resource "aws_instance" "my_instance" {
  count  = var.instance_count # meta-argument to create multiple instances
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key_pair] # Ensure SG and Key Pair are created before EC2 
  ami                    = var.ami_id # OS AMI ID
  instance_type          = var.instance_type # Instance type
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  


  # root storage (EBS)
  root_block_device {
    volume_size = var.env == "prod" ? 20 : 10
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.env}-infra-app-instance"
    Environment = var.env
  }
}


