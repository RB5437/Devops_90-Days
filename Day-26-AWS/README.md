# Day-03 AWS Learning Notes

# Topics Learned Today

Today I learned and practiced the following AWS services and concepts:

- VPC (Virtual Private Cloud)
- Public and Private Subnets
- Internet Gateway
- Route Tables
- NAT Gateway
- VPC Peering
- Amazon CloudWatch
- CloudWatch Agent Installation and Troubleshooting

---

# 1. Amazon VPC

## What is VPC?

Amazon VPC (Virtual Private Cloud) allows us to create a logically isolated network in AWS where we can launch AWS resources securely.

## Key Components Learned

- CIDR Block
- Subnets
- Route Tables
- Internet Gateway
- NAT Gateway
- Security Groups
- Network Isolation

## VPC Architecture

```text
VPC (10.0.0.0/16)
│
├── Public Subnet
│   ├── EC2 Instance
│   └── Internet Gateway
│
└── Private Subnet
    └── Database / Internal Servers
```

## Official AWS Documentation

- https://docs.aws.amazon.com/vpc/
- https://aws.amazon.com/vpc/

---

# 2. Public and Private Subnets

## Public Subnet

A public subnet has a route to the Internet Gateway.

### Use Cases

- Web Servers
- Bastion Host
- Load Balancer

## Private Subnet

A private subnet does not have direct internet access.

### Use Cases

- Databases
- Internal Applications
- Backend Servers

## Learned Concepts

- Public subnet uses Internet Gateway
- Private subnet uses NAT Gateway for outbound internet
- Better security using subnet isolation

## Official Documentation

- https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html

---

# 3. Internet Gateway

## What is Internet Gateway?

Internet Gateway enables communication between VPC resources and the internet.

## Learned

- Attach Internet Gateway to VPC
- Configure Route Table
- Allow internet access to public subnet

## Route Example

```text
Destination: 0.0.0.0/0
Target: Internet Gateway
```

## Official Documentation

- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html

---

# 4. Route Tables

## What is Route Table?

A Route Table contains rules that determine where network traffic is directed.

## Learned

- Public Route Table
- Private Route Table
- Subnet Association
- Default Routes

## Example Routes

| Destination | Target |
|---|---|
| 10.0.0.0/16 | local |
| 0.0.0.0/0 | igw-id |

## Official Documentation

- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html

---

# 5. NAT Gateway

## What is NAT Gateway?

NAT Gateway allows instances in private subnets to access the internet securely without exposing them publicly.

## Learned

- NAT Gateway created in Public Subnet
- Elastic IP required
- Private subnet route points to NAT Gateway

## Benefits

- Secure outbound internet access
- Keeps private servers hidden

## Official Documentation

- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html

---

# 6. VPC Peering

## What is VPC Peering?

VPC Peering connects two VPCs privately using AWS network infrastructure.

## Learned

- Create Peering Connection
- Accept Peering Request
- Update Route Tables
- Private communication between VPCs

## Use Cases

- Multi-environment architecture
- Shared services
- Inter-VPC communication

## Official Documentation

- https://docs.aws.amazon.com/vpc/latest/peering/

---

# 7. Amazon CloudWatch

## What is CloudWatch?

Amazon CloudWatch is a monitoring and observability service for AWS resources and applications.

## Learned

- Monitoring EC2 metrics
- CPU Utilization
- Memory Monitoring
- CloudWatch Dashboards
- CloudWatch Logs
- CloudWatch Alarms

## Metrics Monitored

- CPU Usage
- Disk Usage
- Network Traffic
- Memory Utilization

## Official Documentation

- https://docs.aws.amazon.com/cloudwatch/
- https://aws.amazon.com/cloudwatch/

---

# 8. CloudWatch Agent Installation

## Installed CloudWatch Agent on EC2

### Installation

```bash
sudo yum install -y amazon-cloudwatch-agent
```

### Configuration Wizard

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

### Start Service

```bash
sudo systemctl start amazon-cloudwatch-agent

sudo systemctl enable amazon-cloudwatch-agent

sudo systemctl status amazon-cloudwatch-agent
```

---

# 9. CloudWatch Agent Troubleshooting

## Issue Faced

CloudWatch Agent service failed to start.

### Error

```text
amazon-cloudwatch-agent.json does not exist or cannot read
```

## Root Cause

CloudWatch configuration file was missing.

## Solution

Ran configuration wizard to create config file.

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

Then restarted service successfully.

## Learned

- How to check logs using journalctl
- How to troubleshoot systemd services
- Importance of CloudWatch Agent configuration

### Log Command

```bash
sudo journalctl -u amazon-cloudwatch-agent -n 50 --no-pager
```

---

# Commands Practiced Today

## Check VPCs

```bash
aws ec2 describe-vpcs
```

## Check Subnets

```bash
aws ec2 describe-subnets
```

## Check Route Tables

```bash
aws ec2 describe-route-tables
```

## Check Internet Gateways

```bash
aws ec2 describe-internet-gateways
```

## Check NAT Gateways

```bash
aws ec2 describe-nat-gateways
```

---

# Key Learnings

- Understanding AWS networking fundamentals
- Difference between public and private subnet
- Internet connectivity in AWS
- Secure networking architecture
- Monitoring AWS infrastructure using CloudWatch
- Installing and troubleshooting CloudWatch Agent
- Route table and NAT Gateway configuration

---

# Real-World Concepts Learned

- Network Isolation
- Secure Cloud Architecture
- Monitoring and Observability
- Infrastructure Troubleshooting
- High Availability Design
- Private Resource Protection

---

# GitHub Repository Name

```text
aws-networking-cloudwatch-notes
```

---

# Useful AWS Official Links

| Service | Official Link |
|---|---|
| Amazon VPC | https://aws.amazon.com/vpc/ |
| VPC Documentation | https://docs.aws.amazon.com/vpc/ |
| CloudWatch | https://aws.amazon.com/cloudwatch/ |
| CloudWatch Docs | https://docs.aws.amazon.com/cloudwatch/ |
| NAT Gateway | https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html |
| VPC Peering | https://docs.aws.amazon.com/vpc/latest/peering/ |

---

# Conclusion

Today I gained hands-on experience with AWS networking and monitoring services. I practiced configuring VPC networking components, internet connectivity, subnet architecture, CloudWatch monitoring, and troubleshooting CloudWatch Agent issues on EC2 instances.
