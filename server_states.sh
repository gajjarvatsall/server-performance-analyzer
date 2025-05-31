#!/bin/bash

# =============================
# server-stats.sh
# Collects basic server performance stats
# =============================

echo "======== Server Performance Report ========"
echo "Generated on: $(date)"
echo "Hostname: $(hostname)"
echo "------------------------------------------"

# OS Version
echo "OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo "------------------------------------------"

# Uptime
echo "Uptime:"
uptime -p
echo "------------------------------------------"

# Load Average
echo "Load Average (1m, 5m, 15m):"
uptime | awk -F'load average: ' '{ print $2 }'
echo "------------------------------------------"

# Logged In Users
echo "Logged In Users:"
who | wc -l
echo "------------------------------------------"

# CPU Usage
echo "Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | \
awk '{print "Used: " $2 + $4 "%, Idle: " $8 "%"}'
echo "------------------------------------------"

# Memory Usage
echo "Memory Usage:"
free -h | awk '/Mem:/ {
  used=$3; free=$4; total=$2;
  printf("Used: %s, Free: %s, Total: %s, Usage: %.2f%%\n", used, free, total, ($3/$2)*100)
}'
echo "------------------------------------------"

# Disk Usage
echo "Disk Usage (/ partition):"
df -h / | awk 'NR==2 {
  printf("Used: %s, Free: %s, Total: %s, Usage: %s\n", $3, $4, $2, $5)
}'
echo "------------------------------------------"

# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo "------------------------------------------"

# Top 5 processes by Memory usage
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo "------------------------------------------"

# Failed Login Attempts (Optional Stretch Goal)
if [ -f /var/log/auth.log ]; then
  echo "Failed SSH Login Attempts:"
  grep "Failed password" /var/log/auth.log | wc -l
  echo "------------------------------------------"
fi

echo "========= End of Report ========="
