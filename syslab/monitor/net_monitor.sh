#!/data/data/com.termux/files/usr/bin/bash

echo "# Network Monitor Report" > ../reports/net_report.md
ip addr >> ../reports/net_report.md
ping -c 3 google.com >> ../reports/net_report.md
