# DAY-06 Commands Cheat Sheet

## Connectivity

### ping
Check internet connectivity

ping netflix.com

DNS
nslookup

Resolve domain to IP

nslookup netflix.com
dig

Detailed DNS info

dig netflix.com
Network Path
traceroute

Track network hops

traceroute netflix.com
tracepath

Simple traceroute alternative

tracepath netflix.com
Interface & IP
ip a

Show IP address

ip a
ifconfig

Show network interface

ifconfig
Ports & Services
netstat

List listening ports

netstat -tulnp
ss

Modern alternative

ss -tulnp
Port Testing
telnet

Check port connectivity

telnet netflix.com 80
nc (netcat)

Check port

nc -zv netflix.com 80
Routing
route

Show routing table

route -n
ARP
arp

Show MAC mapping

arp -a
Packet Capture
tcpdump

Capture network traffic

tcpdump -i ens5
Network Scan
nmap

Scan open ports

nmap <IP>
Domain Info
whois

Domain details

whois netflix.com
