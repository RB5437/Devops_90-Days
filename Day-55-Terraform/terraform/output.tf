#output "ec2_instance_public_ip" {
#value       = aws_instance.my_instance[*].public_ip
# description = "Public IP address of the EC2 instance"
#}


#output "ec2_instance_public_dns" {
#value       = aws_instance.my_instance[*].public_dns
# description = "Public DNS name of the EC2 instance"
#}

#output "ec2_arn" {
# value       = aws_instance.my_instance[*].arn
#description = "ARN of the EC2 instance"
#}

# output ofr FOR each instance
output "ec2_instance_public_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}