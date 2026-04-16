

##  System Monitoring

### vmstat

* Shows CPU, memory, and process stats
* `vmstat 2` → updates every 2 seconds

--> Observation:

* CPU idle ~ 100% → system not busy

---

### htop

* Interactive process viewer
* Shows CPU, RAM usage in real-time

---

##  System Status

### uptime

* Shows system running time and load average

--> Example:

* Load average near 0 → low system usage

---

##  User Commands

* `who` → logged-in users
* `whoami` → current user
* `id` → user & group info

--> Observation:

* Logged in as root user

---

##  Networking

### nslookup

* Resolves domain to IP

### ip a

* Shows IP address and network interface

### route -n

* Displays routing table

--> Learning:

* Default gateway used for internet access

---

## --> Error Faced

### nc command

```bash
nc -zv amazon.com
```

 Error: missing port number

 Fix:

```bash
nc -zv amazon.com 80
```

---

##  Disk Monitoring

### watch df -h

* Continuously monitors disk usage

---

##  Text Processing

### awk

```bash
awk '{print $1}' text.txt
```

* Prints first column

### sed

```bash
sed 's/day/days/g' text.txt
```

* Replaces words in file

---

##  Log Management

### journalctl

* Used to view system logs

Commands:

* `--disk-usage` → log size
* `--vacuum-time` → delete old logs
* `--vacuum-size` → limit log size

---

##  dmesg

* Shows kernel logs
* Useful for troubleshooting boot and hardware issues

---

##  Disk Error

### fsck

```bash
fsck -y /dev/nvme0n1
```

 Error: device is in use

 Learning:

* Cannot check disk while mounted
* Need to unmount first

---

##  Disk Health

### smartctl

* Shows disk health status

 Observation:

* Disk health: PASSED

---

##  DevOps Connection

* Monitoring tools used in production servers
* Logs are critical for debugging issues
* Network commands used in troubleshooting
* Disk health important for system reliability

