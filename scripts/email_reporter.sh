#!/bin/bash
# Send forensic report email hourly

REPORT_FILE="/data/data/com.termux/files/home/uzzol-os/forensic-ai/latest_report.md"
RECIPIENT="uzzolhassan38@gmail.com"
SUBJECT="Hourly Forensic Report from Uzzol OS"

if [ -f "$REPORT_FILE" ]; then
  mail -s "$SUBJECT" "$RECIPIENT" < "$REPORT_FILE"
fi
