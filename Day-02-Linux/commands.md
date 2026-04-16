

##  System Monitoring

```bash
vmstat 2
htop
uptime
```

##  System Info

```bash
uname
date
```

##  User Info

```bash
who
whoami
id
```

##  Command Location

```bash
which sudo
which apt
```

##  Network Commands

```bash
nslookup amazon.com
ip a
route -n
```

##  Network Check (Error Observed)

```bash
nc -zv amazon.com
```

Error: missing port number

---

##  Disk Monitoring

```bash
watch df -h
```

---

##  File & Text Processing

```bash
awk '{print $1}' text.txt
sed 's/day/days/g' text.txt
```

---

##  Log Management

```bash
journalctl --disk-usage
journalctl --vacuum-time=2d
journalctl --vacuum-size=500M
```

---

##  System Logs

```bash
dmesg
dmesg | grep USB
dmesg | grep audit
dmesg -w
```

---

##  Disk Check

```bash
fsck -y /dev/nvme0n1
```

Error: device is in use

---

##  Disk Health

```bash
smartctl -a /dev/nvme0
```
