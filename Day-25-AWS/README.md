# ☁️ AWS Networking & Monitoring Practice

## 📅 Topics Covered

* Amazon VPC
* Public & Private Subnets
* Internet Gateway (IGW)
* Route Tables
* NAT Gateway
* VPC Peering
* Amazon CloudWatch

---

# 🎯 Objective

To understand AWS networking fundamentals and monitoring services used in real-world cloud and DevOps environments.

---

# 🧠 Key Learnings

## 🌐 Amazon VPC

* Created a custom Virtual Private Cloud (VPC)
* Understood CIDR block usage
* Learned VPC isolation and networking basics

### Example

```text id="mq2jol"
VPC CIDR: 10.0.0.0/16
```

---

## 📂 Subnets

### Public Subnet

* Has route to Internet Gateway
* Used for public-facing resources

### Private Subnet

* No direct internet access
* Used for databases and internal servers

### Example

```text id="bdxbnf"
Public Subnet: 10.0.1.0/24
Private Subnet: 10.0.2.0/24
```

---

## 🌍 Internet Gateway (IGW)

* Attached IGW to VPC
* Enabled internet access for public subnet

### Key Learning

Public subnet requires:

* Internet Gateway
* Route to `0.0.0.0/0`

---

## 🛣️ Route Tables

Configured routes for:

* Public subnet → Internet Gateway
* Private subnet → NAT Gateway

### Example Routes

```text id="m6n0od"
0.0.0.0/0 → IGW
0.0.0.0/0 → NAT Gateway
```

---

## 🔄 NAT Gateway

* Created NAT Gateway in public subnet
* Allowed private subnet instances to access internet securely

### Use Case

* Software updates
* Package installations
* Secure outbound traffic

---

## 🔗 VPC Peering

* Learned communication between two VPCs
* Configured route table updates for peering

### Key Learning

* VPC peering enables private communication
* No internet required between peered VPCs

---

# 📊 Amazon CloudWatch

## Learned:

* Monitoring EC2 metrics
* CPU Utilization
* Memory & disk monitoring basics
* Viewing logs and alarms

### Important Metrics

* CPUUtilization
* NetworkIn
* NetworkOut
* StatusCheckFailed

---

# 🚀 Real DevOps Connection

## Why VPC is Important

* Network isolation
* Security
* Production architecture

## Why CloudWatch is Important

* Monitoring servers and applications
* Alerting and troubleshooting
* Production observability

---

# 🛠️ Services Practiced

* Amazon VPC
* EC2
* CloudWatch
* NAT Gateway
* Route Tables
* Internet Gateway

---

# 💡 Interview Revision Notes

## Difference Between Public & Private Subnet

| Public Subnet         | Private Subnet     |
| --------------------- | ------------------ |
| Has internet access   | No direct internet |
| Uses Internet Gateway | Uses NAT Gateway   |
| Hosts web servers     | Hosts databases    |

---

## NAT Gateway

* Placed in public subnet
* Provides outbound internet to private subnet

---

## VPC Peering

* Connects two VPCs privately
* Requires route table updates

---

## CloudWatch

* AWS monitoring service
* Used for metrics, logs, and alarms

---

# ✅ Outcome

Successfully practiced AWS networking components and CloudWatch monitoring concepts essential for AWS & DevOps Engineer roles.
