# Day 05 - Linux Monitoring, Logs & Networking Notes

## find Command Insights
Command:

find /var/ -type f -size +20M

Purpose:

Finds large files (>20MB)

Use Case:

Disk cleanup in production servers

---

## Log Cleanup

Command:

find /var/log/ -name "*.log" -type f -delete

Warning:

Deletes all log files 

Use carefully in production

---

## Disk Usage Understanding

Command:

du -sh /var/

Output:

579M /var/

Meaning:

Total space used by /var directory

---

## tar Command (Log Backup)

Command:

tar -czvf logs.tar.gz /var/log/

Purpose:

Compress logs for backup

Flags:

c → create  
z → gzip  
v → verbose  
f → file  

---

## Networking Debugging

### ping

Checks connectivity

### nslookup

Resolves domain → IP

### ip route

Shows default gateway

### nc (Netcat)
Command:

nc -zv google.com 443

Use:

Check port connectivity

---

## tcpdump Insight

Command:

tcpdump -i ens5

Purpose:

Capture live network packets

Fix:

Use correct interface (ens5 instead of eth0)

---

## Firewall Understanding

### iptables

Low-level firewall rules

### ufw
Easy firewall tool

Command:

ufw allow ssh

Note:

ufw status → shows firewall state

---

## Process Monitoring

Command:

ps -aux --sort=-%cpu | head

Purpose:

Shows top CPU consuming processes

Command:

ps -aux --sort=-%mem | head

Purpose:

Shows top memory consuming processes

---

## iostat Output Understanding

Command:

iostat -x 2

Field	Meaning

%user	User CPU usage
%system	System CPU usage
%iowait	Waiting for disk
%idle	Idle CPU

Insight:

High iowait = disk bottleneck

---

## systemctl Insight

Command:

systemctl list-units --type=service

Purpose:

List all running services

---

## User Management Issue

Command:

usermod -s /bin/ ritik

Error:

missing or non-executable shell

Reason:

Invalid shell path

Fix:

Use valid shell:
/bin/bash

---

## rsync Backup

Command:

rsync -av /var/log/ /home/backup

Purpose:

Fast and efficient backup

---

## Logs & Debugging

### dmesg

Kernel logs

### tail
Real-time log monitoring

Command:

tail -f /var/log/syslog

---

## Package Issue

Command:

apt install firewall

Error:

Could not get lock

Reason:

Another process (unattended-upgrades) running

Fix:

Wait or kill process carefully

---

## System Info

Commands:

free -m  

df -h  

uname -a  

lsb_release -a  

Purpose:

Check system health and OS details

---

## tcpdump Error Fix

Error:

tcpdump: eth0: No such device

Reason:

Wrong interface name

Fix:
Use:

ip a → find correct interface (ens5)

---

## Final Understanding

Practiced:


- File cleanup & disk usage analysis

- Log management & compression

- Network troubleshooting

- Firewall configuration

- Process & performance monitoring

- Backup using rsync

- Debugging using logs

---

## Pro Tip

Use these together for debugging:

top  

iostat -x 1  


tail -f /var/log/syslog  

ps -aux --sort=-%cpu  

 Gives complete system visibility
