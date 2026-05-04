
## Networking Basics
Concept	Meaning
Networking	System connection
Protocol	Rules of communication
Client-Server	Request ↔ Response

---

## IP & Subnet
Concept	Meaning
IP Address	Unique device ID
Subnet	Network division

Example:
172.31.x.x → Private AWS network

---

## OSI Model
Layer	Function
Application	User interaction
Presentation	Encryption
Session	Connection
Transport	TCP/UDP
Network	IP routing
Data Link	MAC
Physical	Hardware

Trick:
All People Seem To Need Data Processing

---

## TCP/IP Model
Layer	Function
Application	Top layers
Transport	TCP/UDP
Internet	IP
Network Access	Hardware

---

## DNS
Command	Use
nslookup	Resolve domain
dig	Detailed DNS

Insight:
Multiple IP → Load balancing

---

## Connectivity
ping → Check network

---

## Network Path
traceroute → Hops  
tracepath → Simple trace  

---

## Ports
netstat / ss → Show ports

Example:
Port 22 → SSH running

---

## Interface
ip a / ifconfig → Show IP

lo → Local  
ens5 → Network interface  

---

## Routing
route -n → Gateway info

---

## Packet Capture
tcpdump → Network traffic

---

## ARP
arp -a → MAC mapping

---

## Scan
nmap → Open ports

---

## Final Learning
Practiced:

IP & Subnet  
DNS  
Protocols  
Networking Commands  
Troubleshooting  

---

## Pro Tip
Combine:

ping google.com  
ss -tulnp  
ip a  
traceroute google.com  
tcpdump -i ens5  
