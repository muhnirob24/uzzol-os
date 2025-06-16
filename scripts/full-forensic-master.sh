#!/data/data/com.termux/files/usr/bin/bash

# ===============================
# MUH-Nirob's Full Android Forensic Master Script
# Project Root: ~/uzzol-os
# ===============================

echo "[*] Starting Full Forensic Master Scan..."

PROJECT_ROOT="$HOME/uzzol-os"
REPORT_DIR="$PROJECT_ROOT/forensic-reports"
LOG_DIR="$PROJECT_ROOT/logs"
MARKDOWN_FILE="$REPORT_DIR/device_fingerprint_$(date +%F_%H-%M-%S).md"
mkdir -p $REPORT_DIR $LOG_DIR

# ---------- System Preparation ----------
echo "[*] Installing required packages..."
pkg update -y && pkg upgrade -y
pkg install curl zip net-tools termux-api nmap git -y

# ---------- Basic Info ----------
SIM_JSON="$REPORT_DIR/sim_info.json"
CALL_JSON="$REPORT_DIR/call_log.json"
SYS_TXT="$REPORT_DIR/system_info.txt"
NET_TXT="$REPORT_DIR/network_info.txt"
BAT_JSON="$REPORT_DIR/battery.json"
WIFI_JSON="$REPORT_DIR/wifi_info.json"
LOC_JSON="$REPORT_DIR/location.json"
MINER_TXT="$REPORT_DIR/miner_check.txt"
VPN_JSON="$REPORT_DIR/vpn_status.json"
MAL_IP_TXT="$REPORT_DIR/malicious_ping.txt"
USER_TXT="$REPORT_DIR/user_meta.txt"

# ---------- Collect Data ----------
echo "[*] Collecting SIM & Call Log..."
termux-telephony-deviceinfo > $SIM_JSON
termux-telephony-call-log > $CALL_JSON

echo "[*] Collecting System Info..."
uname -a > $SYS_TXT
df -h >> $SYS_TXT
top -n 1 | head -20 >> $SYS_TXT

echo "[*] Network & Port Info..."
ip addr show > $NET_TXT
netstat -tulnp >> $NET_TXT
nmap -sV -T4 localhost >> $NET_TXT

echo "[*] Battery / WiFi / Location..."
termux-battery-status > $BAT_JSON
termux-wifi-scaninfo > $WIFI_JSON
termux-location > $LOC_JSON

echo "[*] Checking for miner processes..."
ps -A | grep -Ei 'minerd|xmrig|crypto' > $MINER_TXT

echo "[*] VPN Leak Test..."
curl -s https://am.i.mullvad.net/json > $VPN_JSON

echo "[*] Malicious IP Ping Test..."
mal_ips=( "45.9.148.35" "185.38.175.132" "185.225.69.69" )
> $MAL_IP_TXT
for ip in "${mal_ips[@]}"; do
  echo "[*] $ip" >> $MAL_IP_TXT
  ping -c 3 $ip >> $MAL_IP_TXT
  echo "---" >> $MAL_IP_TXT
done

echo "[*] Adding Metadata..."
echo "SIM: 01737776956" > $USER_TXT
echo "Email: uzzolhassan38@gmail.com" >> $USER_TXT
date >> $USER_TXT
whoami >> $USER_TXT

# ---------- Create Markdown Report ----------
echo "[*] Creating Markdown Report..."
cat <<EOF > $MARKDOWN_FILE
# 📱 Android Forensic Report

**SIM:** 01737776956  
**Email:** uzzolhassan38@gmail.com  
**Time:** $(date)

---

## 🔐 SIM Info
\`\`\`json
$(cat $SIM_JSON)
\`\`\`

## ☎️ Call Log
\`\`\`json
$(cat $CALL_JSON)
\`\`\`

## 🖥️ System Info
\`\`\`
$(cat $SYS_TXT)
\`\`\`

## 🌐 Network + Ports
\`\`\`
$(cat $NET_TXT)
\`\`\`

## 🔋 Battery
\`\`\`json
$(cat $BAT_JSON)
\`\`\`

## 📶 WiFi
\`\`\`json
$(cat $WIFI_JSON)
\`\`\`

## 📍 Location
\`\`\`json
$(cat $LOC_JSON)
\`\`\`

## 💀 Miner Detection
\`\`\`
$(cat $MINER_TXT)
\`\`\`

## 🔍 VPN / DNS Leak
\`\`\`json
$(cat $VPN_JSON)
\`\`\`

## ⚠️ Malicious IP Ping
\`\`\`
$(cat $MAL_IP_TXT)
\`\`\`

## 🧾 Metadata
\`\`\`
$(cat $USER_TXT)
\`\`\`

EOF

# ---------- Zip All ----------
ZIP_NAME="device_fingerprint_$(date +%F_%H-%M-%S).zip"
zip -r $LOG_DIR/$ZIP_NAME $REPORT_DIR/

# ---------- Optional GitHub Auto Push ----------
if [ -f "$PROJECT_ROOT/scripts/auto-readme-push.sh" ]; then
  echo "[*] Running GitHub Push Script..."
  bash $PROJECT_ROOT/scripts/auto-readme-push.sh
else
  echo "[!] GitHub Push Script Not Found: scripts/auto-readme-push.sh"
fi

# ---------- Done ----------
echo "[✓] Report Ready: $MARKDOWN_FILE"
echo "[✓] ZIP Saved: $LOG_DIR/$ZIP_NAME"
