# DAY-05 Commands Cheat Sheet 

## File Search & Cleanup

### find large files

Find files larger than 20MB
```bash

find /var/ -type f -size +20M
```

### delete log files

Delete all .log files
```bash

find /var/log/ -name "*.log" -type f -delete
```

---

## File & Permission

### touch

Create file
```bash

touch file
```

### chmod

Set permissions
```bash

chmod 755 file
```

### ls -la

Check file permissions
```bash

ls -la file
```

---

## Disk Usage

### du

Check directory size
```bash

du -sh /var/
```

### df

Disk usage in human-readable format
```bash

df -h
```

---

## Archiving & Logs

### tar

Compress logs
```bash

tar -czvf logs.tar.gz /var/log/
```

### logrotate

Force log rotation
```bash

logrotate /etc/logrotate.conf --force
```

### tail (live logs)

Monitor logs in real-time
```bash

tail -f /var/log/syslog
```

### tail (last logs)

Show last 50 lines
```bash

tail -n 50 /var/log/syslog
```

---

## Networking

### ping

Check connectivity
```bash

ping amazon.com
```

### nslookup

DNS lookup
```bash

nslookup google.com
```

### ip route

Show routing table
```bash

ip route
```

### ip a

Show IP address
```bash

ip a
```

### netstat

Check open ports
```bash

netstat -tulnp
```

### ss

Modern netstat alternative
```bash

ss -tulnp
```

### nc (netcat)

Check port connectivity
```bash

nc -zv google.com 443
```

### tcpdump

Capture packets
```bash

tcpdump -i ens5
```

### tcpdump interfaces

List available interfaces
```bash

tcpdump -D
```

---

## Firewall

### iptables

List firewall rules
```bash

iptables -L
```

### ufw allow

Allow SSH
```bash

ufw allow ssh
```

### ufw status

Check firewall status
```bash

ufw status
```

---

## Process Monitoring

### ps aux

List all processes
```bash

ps aux
```

### top CPU usage
```bash

ps -aux --sort=-%cpu | head
```

### top memory usage
```bash

ps -aux --sort=-%mem | head
```

### top

Real-time monitoring
```bash

top
```

### htop

Advanced process viewer
```bash

htop
```

### iostat (2 sec)

Disk performance monitoring
```bash

iostat -x 2
```

### iostat (real-time)
```bash

iostat -x 1
```

---

## Services

### list services
```bash

systemctl list-units --type=service
```

### restart network
```bash

systemctl restart network
```

---

## User Management

### useradd

Create user
```bash

useradd -m -d /home/ubuntu/ ritik
```

### usermod

Change user shell
```bash

usermod -s /bin/ ritik
```

### passwd lock

Lock user account
```bash

passwd -l ritik
```

### verify user
```bash

cat /etc/passwd | grep ritik
```

---

## File Transfer & Backup

### rsync

Backup logs
```bash

rsync -av /var/log/ /home/backup
```

---

## System Info

### uname

System details
```bash

uname -a
```

### lsb_release

OS version
```bash

lsb_release -a
```

### os-release

Detailed OS info
```bash

cat /etc/os-release
```

### free

Memory usage
```bash

free -m
```

---

## Package Management

### dpkg

List installed packages
```bash

dpkg --get-selections
```

### apt install

Install package
```bash

apt install firewall
```

---

## Logs & Debugging

### check OOM errors
```bash

dmesg | grep -i "oom"
```

### check CPU lock issues
```bash

dmesg | grep "soft lockup"
```

### filter logs by date
```bash

awk '/2025-01-20/,/2025-01-21/' /var/log/syslog
```

---

## Kernel & Modules

### lsmod

List loaded kernel modules
```bash

lsmod
```

---

## Process Kill

### kill by PID
```bash

kill <PID>
```

### kill by name
```bash

pkill -f <process_name>
```

---

## Misc

### which

Find command path
```bash

which ls
```

### hostname

Show system hostname
```bash

hostname
```
