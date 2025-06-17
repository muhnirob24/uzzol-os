#!/data/data/com.termux/files/usr/bin/bash

clear
figlet "SysLab"
echo "Date: $(date)"
echo ""
echo "[CPU Load]:"
cat /proc/loadavg
echo ""
echo "[Memory Info]:"
free -h
echo ""
echo "[IP Info]:"
ip addr | grep inet
