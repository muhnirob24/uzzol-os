#!/data/data/com.termux/files/usr/bin/bash

cd ../monitor
bash cpu_monitor.sh
bash ram_monitor.sh
bash net_monitor.sh

cd ../reports
mkdir -p html
pandoc cpu_report.md -o html/cpu_report.html
pandoc ram_report.md -o html/ram_report.html
pandoc net_report.md -o html/net_report.html

echo "All Reports Generated and Converted to HTML!"
