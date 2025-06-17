#!/data/data/com.termux/files/usr/bin/bash

echo "# RAM Monitor Report" > ../reports/ram_report.md
free -h >> ../reports/ram_report.md
