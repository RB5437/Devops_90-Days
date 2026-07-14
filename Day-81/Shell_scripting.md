# 🐚 Shell Scripting for DevOps

Shell scripting is one of the most important skills for every DevOps Engineer. It helps automate repetitive tasks, monitor systems, manage users, and perform backups efficiently.

---

# 1. Disk Space Monitoring Script

## Objective
Monitor disk usage and alert if usage exceeds a specified threshold.

### Script

```bash
#!/bin/bash

THRESHOLD=80
# alert if data usage is more than 80%
USAGE=$(df -P / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "Disk usage is ${USAGE}%. Please check immediately!"
else
    echo "Disk usage is ${USAGE}%. All good."
fi
```

### Output

```
Disk usage is 42%. All good.
```

or

```
Disk usage is 91%. Please check immediately!
```

### Use Case

- Monitor production servers
- Trigger email alerts using cron
- Prevent disk exhaustion

---

# 2. Log File Cleanup Script

## Objective

Delete log files older than 7 days.

### Script

```bash
#!/bin/bash

LOG_DIR="/var/log/myapp"
DAYS=7

find "$LOG_DIR" -type f -name "*.log" -mtime +"$DAYS" -exec rm -f {} \;

echo "Old log files deleted successfully."
```

### Use Case

- Automatic log cleanup
- Free disk space
- Schedule using Cron

---

# 3. Service Health Check Script

## Objective

Check whether a service is running. If not, restart it.

### Script

```bash
#!/bin/bash

SERVICE_NAME="nginx"

if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "$SERVICE_NAME is running."
else
    echo "$SERVICE_NAME is not running. Restarting..."

    systemctl restart "$SERVICE_NAME"

    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "$SERVICE_NAME restarted successfully."
    else
        echo "Failed to restart $SERVICE_NAME."
    fi
fi
```

### Use Case

- Service monitoring
- Automatic recovery
- Cron-based health checks

---

# 4. Automated Backup Script

## Objective

Create a compressed backup of a directory.

### Script

```bash
#!/bin/bash

BACKUP_DIR="/backup"
SOURCE_DIR="/data"

DATE=$(date +%F)

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/backup-$DATE.tar.gz" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup completed successfully."
else
    echo "Backup failed."
fi
```

### Use Case

- Daily backups
- Disaster recovery
- Scheduled using Cron

---

# 5. User Management Script

## Objective

Create a Linux user and add it to the sudo group.

### Script

```bash
#!/bin/bash

USERNAME=$1

if [ -z "$USERNAME" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

if id "$USERNAME" &>/dev/null; then
    echo "User already exists."
    exit 1
fi

useradd "$USERNAME"

echo "$USERNAME:Welcome123" | chpasswd

usermod -aG sudo "$USERNAME"

echo "User $USERNAME created successfully and added to sudo group."
```

### Example

```bash
sudo ./create_user.sh ritik
```

### Use Case

- Automate user onboarding
- Assign sudo privileges
- Reduce manual administration

---

# Cron Examples

Run disk monitoring every hour:

```cron
0 * * * * /home/ec2-user/scripts/disk_monitor.sh
```

Run log cleanup daily at midnight:

```cron
0 0 * * * /home/ec2-user/scripts/log_cleanup.sh
```

Run backup every day at 2 AM:

```cron
0 2 * * * /home/ec2-user/scripts/backup.sh
```

Run service health check every 5 minutes:

```cron
*/5 * * * * /home/ec2-user/scripts/service_check.sh
```

---

# Skills Demonstrated

- Bash Scripting
- Linux Administration
- System Monitoring
- Log Management
- User Management
- Backup Automation
- Cron Jobs
- Process Management
- DevOps Automation

---

# Author

**Ritik Bawane**

- AWS Certified Solutions Architect – Associate
- RHCSA Certified
- DevOps Engineer

GitHub: https://github.com/RB5437

---
⭐ If you found this repository helpful, don't forget to Star it!
