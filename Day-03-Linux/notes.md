#  Day 03 - Notes

##  File & Text Processing
- `awk` → Extracts columns from text
- `sed` → Used for find & replace
- `grep` → Searches patterns

 Example:
- awk prints columns
- sed replaces words globally

---

##  Process Monitoring
- `ps -ef` → Shows all running processes
- `top` → Real-time CPU & memory usage
- `vmstat` → System performance stats

---

##  Disk Monitoring
- `df -h` → Disk usage (human readable)
- `du -sh` → Folder size
- `free -h` → Memory usage

---

##  LVM (Important DevOps Concept)

### Steps:
1. Create Physical Volume (PV)
2. Create Volume Group (VG)
3. Create Logical Volume (LV)

### Benefits:
- Easy resizing
- Flexible storage management
- Used in production environments

---

##  Mounting
- Filesystem must be created before mounting
- Mounted under `/mnt`

---

##  LVM Extension
- Extended logical volume from 9GB → 10GB
- Shows scalability in real systems

---

##  User Management
- Users created using `useradd`
- Groups created using `groupadd`
- Users added to group using `gpasswd`

---

##  Permissions
- `755` → Owner full, others read+execute
- `757` → Others get write access (less secure)

---

##  Networking Commands
- `ping` → Connectivity check
- `netstat` / `ss` → Port & service info
- `traceroute` → Path to destination
- `nslookup` → DNS resolution
- `telnet` → Port connectivity test

---

##  Observations
- Missing tools like netstat required installation
- LVM naming mistakes can cause errors
- Some commands require root privileges

---

##  Real DevOps Learning
This day covered:
- Storage scaling (LVM)
- System monitoring
- Network troubleshooting

These are **real tasks performed by Linux/DevOps Engineers daily**.
