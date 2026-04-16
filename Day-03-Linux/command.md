
##  File & Directory

mkdir dir1 dir2
touch file.txt
echo "text" | tee file.txt
cat file.txt

## Text Processing
awk '{print $1}' file.txt
awk '{print $1,$2,$3}' file.txt
sed 's/I/my/g' file.txt
grep "w" file.txt
⚙️ Process Monitoring
ps -aux | grep ubuntu
ps -ef
top
vmstat

## Disk & Memory
df -h
df -T
df -m
du -sh
du -h /mnt/
free -h

## LVM Setup
pvcreate /dev/nvme1n1 /dev/nvme2n1
vgcreate tws-vg /dev/nvme1n1 /dev/nvme2n1
lvcreate -L 9G -n tws-lv tws-vg

## LVM Info
pvs
vgs
lvs
pvdisplay
vgdisplay
lvdisplay

## Mount LVM
mkfs.ext4 /dev/tws-vg/tws-lv
mkdir /mnt/tws-lv-mount
mount /dev/tws-vg/tws-lv /mnt/tws-lv-mount

------ Extend LVM
lvextend -L +1G /dev/tws-vg/tws-lv

 ----Disk Mounting
mkfs -t ext4 /dev/nvme3n1
mount /dev/nvme3n1 /mnt/tws-disk-mount

## User & Group Management
useradd ritik
passwd
userdel ritik
groupadd devops
gpasswd -a ritik devops

## Permissions
chmod 755 dir1
chmod 757 dir1
chown ritik dir1
chgrp devops dir1

## Networking
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

## System Info
uname
uptime
date
who
whoami
id
which ls
hostname
