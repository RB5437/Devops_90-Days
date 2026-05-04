
##  Connectivity

### ping
Check internet connectivity

```bash
ping netflix.com
```

---

##  DNS

### nslookup
Resolve domain to IP

```bash
nslookup netflix.com
```

### dig
Detailed DNS information

```bash
dig netflix.com
```

---

##  Network Path

### traceroute
Track network hops

```bash
traceroute netflix.com
```

### tracepath
Simple traceroute alternative

```bash
tracepath netflix.com
```

---

##  Interface & IP

### ip a
Show IP address

```bash
ip a
```

### ifconfig
Show network interface details

```bash
ifconfig
```

---

##  Ports & Services

### netstat
List listening ports

```bash
netstat -tulnp
```

### ss
Modern alternative to netstat

```bash
ss -tulnp
```

---

##  Port Testing

### telnet
Check port connectivity

```bash
telnet netflix.com 80
```

### nc (netcat)
Check port connectivity

```bash
nc -zv netflix.com 80
```

---

##  Routing

### route
Show routing table

```bash
route -n
```

---

##  ARP

### arp
Show MAC to IP mapping

```bash
arp -a
```

---

##  Packet Capture

### tcpdump
Capture network traffic

```bash
tcpdump -i ens5
```

---

##  Network Scan

### nmap
Scan open ports

```bash
nmap <IP>
```

---

##  Domain Info

### whois
Get domain details

```bash
whois netflix.com
```
