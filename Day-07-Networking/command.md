# DAY-06 Commands Cheat Sheet

## Connectivity

### ping
Check internet connectivity
```bash
ping netflix.com

DNS
nslookup
```bash
Resolve domain to IP

nslookup netflix.com

dig
```bash
Detailed DNS info

dig netflix.com

Network Path
```bash
traceroute

Track network hops

traceroute netflix.com


tracepath
```bash
Simple traceroute alternative

tracepath netflix.com

Interface & IP
```bash

ip a

Show IP address

ip a

ifconfig

Show network interface
```bash
ifconfig

Ports & Services
```bash
netstat

List listening ports
```bash
netstat -tulnp
ss

Modern alternative
```bash
ss -tulnp

Port Testing
```bash
telnet

Check port connectivity
```bash
telnet netflix.com 80

nc (netcat)

Check port
```bash
nc -zv netflix.com 80

Routing
```bash
route

Show routing table
```bash
route -n

ARP

arp

Show MAC mapping
```bash
arp -a

Packet Capture
```bash
tcpdump

Capture network traffic
```bash
tcpdump -i ens5

Network Scan
```bash
nmap

Scan open ports
```bash
nmap <IP>

Domain Info
```bash
whois

Domain details

```bash
whois netflix.com
