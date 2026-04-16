

##  vmstat Output Understanding

| Field      | Meaning           |
| ---------- | ----------------- |
| r          | Running processes |
| free       | Free memory       |
| buff/cache | Memory usage      |
| us         | User CPU          |
| sy         | System CPU        |
| id         | Idle CPU          |



---

##  uptime

Example:

```
up 17 min, load average: 0.00, 0.00, 0.01
```

 System is almost idle
No CPU stress

---

##  Networking Insights

* `nslookup` resolved amazon.com → DNS working
* `ip a` → shows private IP (AWS EC2)
* `route` → default gateway configured

---

##  nc Error Fix

You got:

```
nc: missing port number
```

Correct usage:

```bash
nc -zv amazon.com 80
```

---

##  awk vs sed

| Tool | Use                     |
| ---- | ----------------------- |
| awk  | Column-based processing |
| sed  | Text replacement        |

---

##  journalctl

* Stores system logs
* Can clean logs using:

```bash
--vacuum-time
--vacuum-size
```

---

##  dmesg

* Shows kernel boot logs
* Useful for:

  * hardware issues
  * driver errors

---

##  fsck Issue

Error:

```
device is in use
```

 Reason: Disk is mounted
 Fix:

* Run in recovery mode OR
* Unmount disk first

---

##  smartctl Insight

 Disk health: PASSED
 No errors
 AWS EBS volume detected

---

##  Final Understanding

 practiced:

* System Monitoring 
* Networking Debugging 
* Log Analysis 
* Disk Health Checking 


---

##  Pro Tip

Combine commands for debugging:

```bash
uptime
vmstat 1
htop
journalctl -xe
```

This gives full system visibility

