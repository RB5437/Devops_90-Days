# DAY-05 Commands Cheat Sheet

## File Search & Cleanup

find /var/ -type f -size +20M  

Find large files (>20MB)

find /var/log/ -name "*.log" -type f -delete  

Delete all log files


---

## File & Permission

touch file  

Create file

chmod 755 file  

Set permissions

ls -la file  

Check file permissions

---

## Disk Usage

du -sh /var/  

Check directory size

df -h  

Disk usage in human-readable format

---

## Archiving & Logs

tar -czvf logs.tar.gz /var/log/  

Compress logs

logrotate /etc/logrotate.conf --force  

Force log rotation

tail -f /var/log/syslog  

Live log monitoring

tail -n 50 /var/log/syslog  

Last 50 log lines

---

## Networking

ping amazon.com  

Check connectivity

nslookup google.com  

DNS lookup

ip route  

Show routing table

ip a  

Show IP address

netstat -tulnp  

Check open ports

ss -tulnp  

Modern netstat alternative

nc -zv google.com 443  

Check port connectivity

tcpdump -i ens5  

Capture packets

tcpdump -D  

List interfaces

---

## Firewall

iptables -L  

List firewall rules

ufw allow ssh  

Allow SSH

ufw status  

Check firewall status

---

## Process Monitoring

ps aux  

List processes

ps -aux --sort=-%cpu | head  

Top CPU usage

ps -aux --sort=-%mem | head  

Top memory usage

top  

Real-time monitoring

htop  

Advanced process viewer

iostat -x 2  

Disk performance (2 sec)

iostat -x 1  

Real-time disk stats

---

## Services

systemctl list-units --type=service  

List services

systemctl restart network  

Restart network

---

## User Management

useradd -m -d /home/ubuntu/ ritik  

Create user

usermod -s /bin/ ritik  

Change shell

passwd -l ritik  

Lock user

cat /etc/passwd | grep ritik  

Verify user

---

## File Transfer & Backup

rsync -av /var/log/ /home/backup  

Backup logs

---

## System Info

uname -a  

System details

lsb_release -a  

OS version


cat /etc/os-release  
OS info

free -m  

Memory usage

---

## Package Management

dpkg --get-selections  

List installed packages

apt install firewall  

Install package

---

## Logs & Debugging

dmesg | grep -i "oom"  

Check OOM errors

dmesg | grep "soft lockup"  

Check CPU issues

awk '/2025-01-20/,/2025-01-21/' /var/log/syslog  

Filter logs by date

---

## Kernel & Modules

lsmod  

List loaded modules

---

## Process Kill

kill <PID>  

Kill process by PID

pkill -f <process_name>  

Kill by name

---

## Misc

which ls  

Command path

hostname  

Show hostname
