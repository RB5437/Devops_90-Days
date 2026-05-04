#!/bin/bash

echo "===== SYSTEM HEALTH CHECK ====="

# CPU 
cpu=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - $1}')
cpu_int=${cpu%.*}
echo "CPU Usage: $cpu%"

# Memory
mem=$(free -m | awk 'NR==2 {print $3}')
echo "Memory Used: $mem MB"

# Disk
disk=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk Usage: $disk"

echo "===== STATUS ====="
echo "All systems normal "

# CPU Check
if [ "$cpu_int" -gt 80 ]; then
    echo "High CPU Usage "
fi

# Memory Check
if [ "$mem" -gt 1000 ]; then
    echo "High Memory Usage "
fi

# Disk Check
disk_val=$(echo "$disk" | tr -d '%')
if [ "$disk_val" -gt 80 ]; then
    echo "Disk Almost Full "
fi
