# Load Balancer

A Load Balancer distributes incoming traffic across multiple EC2 instances to ensure high availability, fault tolerance, and better performance.

---

## Types of Load Balancer in AWS

### 1. Application Load Balancer (ALB)

ALB works at **Layer 7 (Application Layer)** of the OSI model.

### Key Features:
- Handles HTTP and HTTPS traffic
- Path-based routing (e.g., /api → server1, /login → server2)
- Host-based routing (e.g., app.example.com, admin.example.com)
- Supports WebSockets and HTTP/2

### Use Case:
- Web applications
- Microservices architecture
- REST APIs

### Example:
- /images → EC2-1  
- /videos → EC2-2  

### Interview Point:
ALB is **intelligent routing** based on URL or domain.

---

### 2. Network Load Balancer (NLB)

NLB works at **Layer 4 (Transport Layer)**.

### Key Features:
- Handles TCP and UDP traffic
- Very high performance
- Ultra-low latency
- Can handle millions of requests per second
- Supports static IP

### Use Case:
- Real-time systems (gaming, trading apps)
- High-performance applications
- When low latency is critical

### Example:
- Direct traffic to EC2 based on IP and port

### Interview Point:
NLB is **fast and simple routing** (no content-based routing).

---

### 3. Classic Load Balancer (CLB)

CLB is the **old/legacy load balancer**.

### Key Features:
- Supports both Layer 4 and Layer 7 (limited)
- Basic load balancing
- No advanced routing features

### Limitations:
- No path-based routing
- No host-based routing
- Less flexible than ALB/NLB

### Use Case:
- Older applications (not recommended for new systems)

### Interview Point:
CLB is deprecated for modern architectures.

---

## Key Differences (Important for Interview)

| Feature            | ALB                  | NLB                  | CLB            |
|------------------|---------------------|----------------------|----------------|
| Layer            | Layer 7             | Layer 4              | Layer 4 & 7    |
| Protocols        | HTTP/HTTPS          | TCP/UDP              | HTTP/TCP       |
| Routing Type     | Path & Host based   | IP & Port based      | Basic          |
| Performance      | Moderate            | Very High            | Low            |
| Use Case         | Web apps/APIs       | High performance     | Legacy         |

---

## How It Works with Auto Scaling

1. User sends request → Load Balancer  
2. Load Balancer distributes traffic → EC2 instances  
3. Auto Scaling adds/removes instances  
4. Load Balancer automatically routes to healthy instances  

---

## Real-World Scenario

- Website gets heavy traffic  
- Load Balancer distributes requests  
- Auto Scaling launches more EC2 instances  
- If one instance fails → traffic is redirected automatically  

---

## Interview Tips

- ALB = Smart routing (Layer 7)
- NLB = High performance (Layer 4)
- CLB = Old (avoid in new projects)

🔥 Most Asked:
- ALB vs NLB difference  
- Which LB for microservices? → ALB  
- Which LB for low latency? → NLB  

---

## Summary

AWS Load Balancers improve application availability, distribute traffic efficiently, and work with Auto Scaling to handle dynamic workloads.
