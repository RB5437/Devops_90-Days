# DAY-06 Commands Cheat Sheet (Networking)

## Connectivity Check

### ping

Check internet connectivity

```bash
ping netflix.com
```

---

## Network Tools Installation

### netstat (net-tools)

Install missing networking tools

```bash
apt install net-tools
```

### traceroute

Install traceroute utility

```bash
apt install traceroute
```

### whois

Install domain lookup tool

```bash
apt install whois
```

### nmap

Install network scanner

```bash
apt install nmap
```

---

## Port & Service Monitoring

### netstat

Check listening ports and services

```bash
netstat -tulnp
```

### ss

Modern alternative to netstat

```bash
ss -tuln
```

---

## IP & Interface Info

### ifconfig

Show network interfaces

```bash
ifconfig
```

### ip a

Detailed IP information

```bash
ip a
```

### hostname

Show system hostname

```bash
hostname
```

---

## Routing

### route

Show routing table

```bash
route -n
```

---

## Network Path Analysis

### traceroute

Trace route to destination

```bash
traceroute netflix.com
```

### tracepath

Alternative route tracing

```bash
tracepath netflix.com
```

### mtr

Real-time network diagnostics

```bash
mtr netflix.com
```

---

## DNS & Domain Info

### nslookup

DNS resolution

```bash
nslookup netflix.com
```

### dig

Detailed DNS query

```bash
dig netflix.com
```

### whois

Domain registration details

```bash
whois netflix.com
```

---

## Port Connectivity

### telnet

Test port connectivity

```bash
telnet netflix.com 80
telnet netflix.com 443
```

### nc (netcat)

Check port connectivity

```bash
nc -zv netflix.com 80
```

---

## Packet Capture

### tcpdump

Capture network packets

```bash
tcpdump -i ens5
```

### tcpdump interfaces

List available interfaces

```bash
tcpdump -D
```

---

## ARP & Network Mapping

### arp

Check ARP table

```bash
arp -a
```

### nmap

Scan network / host

```bash
nmap 172.31.32.1
```

---

## Wireless Info

### iwconfig

Check wireless interfaces

```bash
iwconfig
```

---

## Firewall

### iptables

View firewall rules

```bash
iptables -L
```

---

## Monitoring

### watch

Monitor command output in real-time

```bash
watch df -h
```

---

## Key Learnings

- Installed missing networking tools (net-tools, traceroute, nmap)
- Understood port monitoring using netstat & ss
- Learned DNS debugging (nslookup, dig)
- Practiced connectivity testing (ping, telnet, nc)
- Explored routing and path tracing
- Used packet capture for deep network analysis
