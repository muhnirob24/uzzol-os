#!/bin/bash
set -euo pipefail

# প্রকল্প মূল ডিরেক্টরি (ইখানে তুমি যে ডিরেক্টরিতে আছো)
PROJECT_ROOT="$(pwd)"
REPORT_DIR="$PROJECT_ROOT/forensic-reports"
LOG_FILE="$PROJECT_ROOT/forensic-auto-report.log"
DATE_STR=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_MD="$REPORT_DIR/forensic_report_$DATE_STR.md"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
COMMIT_MSG="Auto forensic report update $DATE_STR"

mkdir -p "$REPORT_DIR"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

log "===== Starting forensic auto report ====="

# -- System info --
log "Collecting system info..."
{
  echo "# Forensic Report - $DATE_STR"
  echo "## System Info"
  echo "- Hostname: $(hostname)"
  echo "- OS: $(grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '\"')"
  echo "- Kernel: $(uname -r)"
  echo "- CPU: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)"
  echo "- Memory: $(free -h | grep Mem: | awk '{print $2}')"
  echo "- Uptime: $(uptime -p)"
  echo "- Logged in users:"
  who
} >> "$REPORT_MD"

# -- Network info --
log "Collecting network info..."
{
  echo -e "\n## Network Info"
  echo "### IP Addresses"
  ip -4 addr show | grep inet | awk '{print $2}' 
  echo -e "\n### MAC Addresses"
  ip link show | grep link/ether
  echo -e "\n### ARP Table"
  arp -n
  echo -e "\n### Active TCP/UDP Connections"
  ss -tunap
} >> "$REPORT_MD"

# -- Storage info --
log "Collecting storage info..."
{
  echo -e "\n## Storage Info"
  df -h
  echo -e "\nMounted Devices"
  lsblk
} >> "$REPORT_MD"

# -- IoT device scan with nmap --
log "Scanning for IoT devices (if nmap installed)..."
{
  echo -e "\n## IoT Devices Scan"
  if command -v nmap >/dev/null 2>&1; then
    DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    LOCAL_IP=$(ip -4 addr show dev "$DEFAULT_IFACE" | grep inet | awk '{print $2}' | cut -d/ -f1)
    IFS='.' read -r i1 i2 i3 i4 <<< "$LOCAL_IP"
    LAN_RANGE="$i1.$i2.$i3.0/24"
    echo "Scanning local network range: $LAN_RANGE"
    nmap -sP "$LAN_RANGE" | grep 'Nmap scan report for' || echo "No devices found or nmap scan failed."
  else
    echo "nmap not installed."
  fi
} >> "$REPORT_MD"

# -- Crypto mining process check --
log "Checking for crypto mining processes..."
{
  echo -e "\n## Crypto Mining Detection"
  ps aux | grep -iE 'miner|xmrig|cryptonight|cgminer|minerd' | grep -v grep || echo "No crypto mining processes found."
} >> "$REPORT_MD"

# -- Virtual machine detection --
log "Detecting if running inside VM..."
{
  echo -e "\n## Virtual Machine Detection"
  if command -v dmidecode >/dev/null 2>&1; then
    dmidecode | grep -iE 'vmware|virtualbox|kvm|qemu|hyper-v' || echo "No VM signatures detected."
  else
    echo "dmidecode not installed."
  fi
} >> "$REPORT_MD"

# -- Malware scan with clamav --
log "Running malware scan (clamav)..."
{
  echo -e "\n## Malware Scan"
  if command -v clamscan >/dev/null 2>&1; then
    clamscan --infected --recursive --quiet --log=/tmp/clamav_scan.log "$PROJECT_ROOT"
    if [ -s /tmp/clamav_scan.log ]; then
      cat /tmp/clamav_scan.log
    else
      echo "No malware found in project directory."
    fi
  else
    echo "clamav not installed."
  fi
} >> "$REPORT_MD"

# -- Hardware info --
log "Collecting hardware info..."
{
  echo -e "\n## Hardware Info"
  echo "PCI devices:"
  lspci
  echo -e "\nUSB devices:"
  lsusb
} >> "$REPORT_MD"

log "Scan completed. Report saved: $REPORT_MD"

# -- Git commit & push --
log "Checking git status..."
cd "$PROJECT_ROOT"

git add "$REPORT_MD" || log "Warning: failed to add report file"

if git diff --cached --quiet; then
  log "No changes to commit."
else
  git commit -m "$COMMIT_MSG"
  git push origin "$BRANCH"
  log "Changes pushed to GitHub on branch $BRANCH."
fi

log "===== Forensic auto report finished ====="
