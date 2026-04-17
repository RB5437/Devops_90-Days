File Search & Cleanup
find

Search large files

find /var/ -type f -size +20M

Delete log files

find /var/log/ -name "*.log" -type f -delete
File & Permission
touch

Create file

touch file
chmod

Change permission

chmod 755 file
ls

Check file details

ls -la file
Disk Usage
du

Check directory size

du -sh /var/
df

Disk space usage

df -h
Archiving & Logs
tar

Compress logs

tar -czvf logs.tar.gz /var/log/
logrotate

Force log rotation

logrotate /etc/logrotate.conf --force
tail

Live logs

tail -f /var/log/syslog

Last 50 lines

tail -n 50 /var/log/syslog
Networking
ping

Check connectivity

ping amazon.com
nslookup

DNS lookup

nslookup google.com
ip route

Routing table

ip route
ip a

IP address

ip a
netstat

Check open ports

netstat -tulnp
ss

Modern netstat alternative

ss -tulnp
nc (netcat)

Check port connectivity

nc -zv google.com 443
tcpdump

Capture packets

tcpdump -i ens5

List interfaces

tcpdump -D
Firewall
iptables

View firewall rules

iptables -L
ufw

Allow SSH

ufw allow ssh

Check status

ufw status
Process Monitoring
ps

Show processes

ps aux

Top CPU processes

ps -aux --sort=-%cpu | head

Top memory processes

ps -aux --sort=-%mem | head
top

Real-time monitoring

top
htop

Interactive monitoring

htop
iostat

Disk performance

iostat -x 2
iostat -x 1
Services
systemctl

List services

systemctl list-units --type=service

Restart network

systemctl restart network
User Management
useradd

Create user

useradd -m -d /home/ubuntu/ ritik
usermod

Change shell

usermod -s /bin/ ritik
passwd

Lock user

passwd -l ritik
check user
cat /etc/passwd | grep ritik
File Transfer & Backup
rsync

Backup logs

rsync -av /var/log/ /home/backup
System Info
uname

System details

uname -a
lsb_release

OS info

lsb_release -a
os-release

Detailed OS

cat /etc/os-release
free

Memory usage

free -m
Package Management
dpkg

List installed packages

dpkg --get-selections
apt

Install package

apt install firewall
Logs & Debugging
dmesg

OOM logs

dmesg | grep -i "oom"

Soft lock issues

dmesg | grep "soft lockup"
awk

Filter logs

awk '/2025-01-20/,/2025-01-21/' /var/log/syslog
Kernel & Modules
lsmod

List kernel modules

lsmod
Process Kill
kill

Kill process

kill <PID>
pkill

Kill by name

pkill -f <process_name>
Misc
which

Command location

which ls
hostname

System hostname

hostname
