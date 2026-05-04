
##  What I Learned

- Networking Basics  
- IP & Subnet  
- OSI Model  
- TCP/IP Model  
- DNS  
- Networking Commands  

---

##  Networking Basics

Networking connects systems to share data.

Key:
- Communication  
- Protocols  
- Client ↔ Server  

---

##  OSI Model

7 Layers:
Application → User  
Presentation → Encryption  
Session → Connection  
Transport → TCP/UDP  
Network → IP  
Data Link → MAC  
Physical → Hardware  

---

##  TCP/IP Model

4 Layers:
Application  
Transport  
Internet  
Network Access  

---

##  IP & Subnet

- IP → Device identity  
- Subnet → Network division  

Example:
172.31.x.x → Private network  

---

##  DNS

- nslookup → Resolve domain  
- dig → Detailed info  

---

##  Commands Practiced

ping → Connectivity  
nslookup → DNS  
traceroute → Path  
tracepath → Alternative  
ip a → IP info  
ifconfig → Interface  
ss -tulnp → Ports  

---

##  Key Learning

- Understood network flow  
- Learned troubleshooting  
- Practiced real commands  
- Built strong networking base  

---

##  Pro Tip

Use together:

```bash
ping google.com
ss -tulnp
ip a
traceroute google.com
tcpdump -i ens5
