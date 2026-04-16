#  DAY-03 Commands Cheat Sheet

##  File & Directory Management

Create directories

```bash
mkdir dir1 dir2
```

Create file

```bash
touch file.txt
```

Write into file

```bash
echo "text" | tee file.txt
```

View file content

```bash
cat file.txt
```

---

##  Text Processing

Print first column

```bash
awk '{print $1}' file.txt
```

Print multiple columns

```bash
awk '{print $1,$2,$3}' file.txt
```

Replace text

```bash
sed 's/I/my/g' file.txt
```

Search text

```bash
grep "w" file.txt
```

---

##  Process Monitoring

Search process

```bash
ps -aux | grep ubuntu
```

Full process list

```bash
ps -ef
```

Real-time monitoring

```bash
top
```

System stats

```bash
vmstat
```

---

##  Disk & Memory

Disk usage

```bash
df -h
```

Disk type

```bash
df -T
```

Disk in MB

```bash
df -m
```

Directory size

```bash
du -sh
```

Check specific path

```bash
du -h /mnt/
```

Memory usage

```bash
free -h
```

---

##  LVM Setup

Create physical volumes

```bash
pvcreate /dev/nvme1n1 /dev/nvme2n1
```

Create volume group

```bash
vgcreate tws-vg /dev/nvme1n1 /dev/nvme2n1
```

Create logical volume

```bash
lvcreate -L 9G -n tws-lv tws-vg
```

---

##  LVM Information

```bash
pvs
vgs
lvs
pvdisplay
vgdisplay
lvdisplay
```

---

##  Mount LVM

Format filesystem

```bash
mkfs.ext4 /dev/tws-vg/tws-lv
```

Create mount directory

```bash
mkdir /mnt/tws-lv-mount
```

Mount volume

```bash
mount /dev/tws-vg/tws-lv /mnt/tws-lv-mount
```

---

##  Extend LVM

```bash
lvextend -L +1G /dev/tws-vg/tws-lv
```

---

## 🔹 Disk Mounting

Format disk

```bash
mkfs -t ext4 /dev/nvme3n1
```

Mount disk

```bash
mount /dev/nvme3n1 /mnt/tws-disk-mount
```

---

##  User & Group Management

Create user

```bash
useradd ritik
```

Set password

```bash
passwd
```

Delete user

```bash
userdel ritik
```

Create group

```bash
groupadd devops
```

Add user to group

```bash
gpasswd -a ritik devops
```

---

##  Permissions

```bash
chmod 755 dir1
chown ritik dir1
chgrp devops dir1
```

---

##  Networking

```bash
ping google.com
ifconfig
ip a
netstat -tulnp
ss -tulnp
traceroute google.com
tracepath google.com
nslookup google.com
telnet google.com 80
arp -a
```

---

##  System Information

```bash
uname
uptime
date
who
whoami
id
which ls
hostname
```
