
# Key Value pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC Default
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
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
}

# EC2 instance
resource "aws_instance" "my_instance" {
  # count                  = 2 # meta-argument to create multiple instances
  for_each = tomap({
    "instance1" = "t2.micro",
    "instance3" = "t3.small"
  })                                  # meta-argument to create multiple instances with unique identifiers
  ami                    = var.ami_id # OS AMI ID
  instance_type          = each.value # Instance type
  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data              = file("install_nginx.sh")


  # root storage (EBS)
  root_block_device {
    volume_size = var.env == "prod" ? var.ec2_default_root_volume_size * 2 : var.ec2_default_root_volume_size 
    volume_type = "gp3"
  }

  tags = {
    Name = "each.key" # Tagging each instance with its unique identifier
  }
}


