#!/data/data/com.termux/files/usr/bin/bash

echo "# CPU Monitor Report" > ../reports/cpu_report.md
echo "## Uptime:" >> ../reports/cpu_report.md
uptime >> ../reports/cpu_report.md

echo "## CPU Info:" >> ../reports/cpu_report.md
cat /proc/cpuinfo | grep 'model name' >> ../reports/cpu_report.md

echo "## Load Average:" >> ../reports/cpu_report.md
cat /proc/loadavg >> ../reports/cpu_report.md
