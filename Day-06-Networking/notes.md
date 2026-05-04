# Day 06 Notes - Networking

## Basics of Networking

Networking is the process of connecting multiple systems to share data and resources.

Key Concepts:
- Communication between systems  
- Data transfer using protocols  
- Client ↔ Server model  

---

## OSI Model (7 Layers)

OSI (Open Systems Interconnection) model defines how data flows in a network.

Layers:

Application → User interaction (HTTP, FTP)  
Presentation → Data format & encryption  
Session → Connection management  
Transport → Data delivery (TCP/UDP)  
Network → Routing (IP)  
Data Link → MAC address  
Physical → Cables, signals  

Easy Trick:  
All People Seem To Need Data Processing  

---

## TCP/IP Model

Simplified version of OSI (4 Layers):

Application  
Transport  
Internet  
Network Access  

---

## OSI vs TCP/IP

OSI Model → 7 Layers (Theoretical, Detailed)  
TCP/IP → 4 Layers (Practical, Simplified)  

---

## IP Protocol

IP = Internet Protocol  

Used for:
- Identifying devices (IP Address)  
- Routing packets across networks  

Types:
- IPv4 → 192.168.x.x  
- IPv6 → Advanced version  

---

## Connectivity Check

ping netflix.com → Internet connectivity working  

If packets respond → network is reachable  
If no response → network/firewall issue  

---

## Package Installation Insight

netstat not found → installed using net-tools  
traceroute not found → installed manually  
whois, nmap installed when required  

Lesson:  
Minimal Linux systems don’t include all networking tools  

---

## Port & Service Monitoring

netstat -tulnp → shows listening ports  
ss -tuln → faster alternative  

Example:  
Port 22 (SSH) open → remote access enabled  

---

## IP & Interface Understanding

ip a / ifconfig → shows system IP  

Example:  
172.31.x.x → private AWS EC2 IP  

lo → loopback (127.0.0.1)  
ens5 → main network interface  

---

## Routing Concept

route -n → shows routing table  

0.0.0.0 → default route via gateway  

Meaning:  
All external traffic goes through gateway  

---

## Network Path Analysis

traceroute netflix.com → shows hops  
tracepath → alternative tool  
mtr → real-time analysis  

Insight:  
Each hop = router between source and destination  

---

## DNS Debugging

nslookup netflix.com → resolves domain  
dig netflix.com → detailed DNS info  

Insight:  
Multiple IPs → load balancing  

---

## Port Connectivity Testing

telnet netflix.com 80 → HTTP port open  
telnet netflix.com 443 → HTTPS port open  

nc error → missing port  

Fix:  
nc -zv netflix.com 80  

---

## Packet Analysis

tcpdump → captures live packets  

Useful for:
- debugging network issues  
- analyzing traffic  

---

## ARP & Network Mapping

arp -a → shows MAC to IP mapping  

Used for:
- identifying devices  
- LAN troubleshooting  

---

## Domain Information

whois netflix.com → domain details  

Includes:
- registrar  
- expiry  
- name servers  

---

## Network Scanning

nmap → scans open ports  

Used for:
- security checks  
- service discovery  

---

## Firewall Check

iptables -L → shows firewall rules  

Current state:  
No rules → all traffic allowed  

---

## Final Understanding

practiced:

- Connectivity Testing (ping, telnet, nc)  
- DNS Debugging (nslookup, dig)  
- Network Analysis (traceroute, mtr)  
- Port Monitoring (netstat, ss)  
- Packet Capture (tcpdump)  
- Security Scanning (nmap)  

---

## Pro Tip

Combine commands:

ping google.com  
ss -tuln  
ip a  
traceroute google.com  
tcpdump -i ens5  

This gives complete network visibility
