#!/bin/bash
apt update -y
apt install nginx -y
systemctl start nginx
systemctl enable nginx

echo "Hello from Terraform on Ubuntu!" > /var/www/html/index.html