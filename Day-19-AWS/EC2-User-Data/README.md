# EC2 User Data

EC2 User Data is a script that runs automatically when an EC2 instance is launched. It is used to automate instance configuration at boot time.

---

## Purpose

- Install software (Nginx, Apache, Docker)
- Configure applications
- Reduce manual setup

---

## Example Script

```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from EC2 User Data" > /var/www/html/index.html
