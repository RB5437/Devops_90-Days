# Day 06 - Networking

##  What I Learned Today

- Basics of Networking  
- OSI Model (7 Layers)  
- TCP/IP Model  
- IP Protocol  
- Practical Networking Commands & Troubleshooting  

---

##  Basics of Networking

Networking is the process of connecting multiple systems to share data and resources.

Key Concepts:
- Communication between systems  
- Data transfer using protocols  
- Client ↔ Server model  

---

##  OSI Model (7 Layers)

OSI (Open Systems Interconnection) model defines how data flows in a network.

### Layers:

1. Application → User interaction (HTTP, FTP)  
2. Presentation → Data format & encryption  
3. Session → Connection management  
4. Transport → Data delivery (TCP/UDP)  
5. Network → Routing (IP)  
6. Data Link → MAC address  
7. Physical → Cables, signals  

 Easy Trick:  
**All People Seem To Need Data Processing**

---

##  TCP/IP Model

Simplified version of OSI (4 Layers):

1. Application  
2. Transport  
3. Internet  
4. Network Access  

---

##  OSI vs TCP/IP

| OSI Model | TCP/IP Model |
|----------|-------------|
| 7 Layers | 4 Layers |
| Theoretical | Practical |
| Detailed | Simplified |

---

##  IP Protocol

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

System is able to reach external network  

---

##  Package Installation Insight

- netstat not found → installed net-tools  
- traceroute not found → installed manually  
- whois, nmap installed when needed  

 Minimal systems require manual tool installation  

---

##  Port & Service Monitoring

- netstat -tulnp → shows listening ports  
- ss -tuln → faster alternative  

Example:
- Port 22 (SSH) is open → remote access enabled  

---

##  IP & Interface Understanding

- ip a / ifconfig → shows system IP  

Example:
- 172.31.x.x → private AWS EC2 IP  

Interfaces:
- lo → loopback  
- ens5 → main network interface  

---

##  Routing

- route -n → shows routing table  

Default route (0.0.0.0):
- Traffic goes via gateway  

---

##  Network Path Analysis

- traceroute netflix.com → shows hops  
- tracepath → alternative tool  
- mtr → real-time network analysis  

👉 Each hop = router between source and destination  

---

##  DNS Debugging

- nslookup netflix.com → resolves domain  
- dig netflix.com → detailed DNS info  

Insight:
- Multiple IPs → load balancing  

---

##  Port Connectivity

- telnet netflix.com 80 → HTTP port open  
- telnet netflix.com 443 → HTTPS port open  


---

##  Packet Capture

- tcpdump → capture live packets  

Used for:
- Debugging traffic  
- Analyzing network issues  

---

##  ARP & Network Mapping

- arp -a → shows MAC to IP mapping  

Useful for:
- LAN troubleshooting  

---

##  Domain Information

- whois netflix.com → domain details  

Includes:
- Registrar  
- Expiry  
- Name servers  

---

##  Network Scanning

- nmap → scan open ports  

Used for:
- Security  
- Service discovery  

---

##  Firewall

- iptables -L → shows firewall rules  

Insight:
- No rules → traffic allowed  

---

##  Final Learning

- Networking fundamentals (OSI, TCP/IP)  
- DNS & connectivity troubleshooting  
- Port & service monitoring  
- Network path tracing  
- Packet-level debugging  

---

##  Pro Tip

Use these commands together for full debugging:

```bash
ping google.com
ss -tuln
ip a
traceroute google.com
tcpdump -i ens5
