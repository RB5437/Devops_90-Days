# DAY-04 Commands Cheat Sheet

##  System Monitoring

### vmstat

Monitor CPU, memory, IO in real-time

```bash
vmstat 2
```

### htop

Interactive process viewer

```bash
htop
```

### uptime

Shows system running time and load

```bash
uptime
```

---

##  System Info

### uname

Shows OS info

```bash
uname
```

### date

Displays current date/time

```bash
date
```

### who

Shows logged-in users

```bash
who
```

### whoami

Shows current user

```bash
whoami
```

### id

Displays user ID info

```bash
id
```

### which

Find command location

```bash
which sudo
```

---

##  Networking

### nslookup

DNS lookup

```bash
nslookup amazon.com
```

### ip a

Show IP address

```bash
ip a
```

### route

Show routing table

```bash
route -n
```

### nc (netcat)

Check port connectivity

```bash
nc -zv amazon.com 80
```

---

##  File Processing

### awk

Print specific column

```bash
awk '{print $1}' text.txt
```

### sed

Replace text

```bash
sed 's/day/days/g' text.txt
```

---

##  Logs

### journalctl

View logs

```bash
journalctl
```

### journalctl cleanup

```bash
journalctl --vacuum-time=2d
journalctl --vacuum-size=500M
```

### dmesg

Kernel logs

```bash
dmesg
```

### Live logs

```bash
dmesg -w
```

---

##  Disk & Hardware

### fsck

Check disk filesystem

```bash
fsck -y /dev/nvme0n1
```

Disk must be unmounted

### smartctl

Check disk health

```bash
smartctl -a /dev/nvme0
```

