#!/bin/bash

REPORT_DIR="$HOME/uzzol-os/forensic-reports"
SCRIPT_DIR="$HOME/uzzol-os/scripts"

echo "[*] Collecting IP address info..."
mkdir -p "$REPORT_DIR"
IP_INFO="$REPORT_DIR/ip_info.txt"
echo "[*] IP Address Info:" > "$IP_INFO"
ip addr show >> "$IP_INFO" 2>/dev/null

echo "[*] Collecting ifconfig info..."
IFCONFIG_INFO="$REPORT_DIR/ifconfig_info.txt"
echo "[*] Interface Info (ifconfig):" > "$IFCONFIG_INFO"
ifconfig >> "$IFCONFIG_INFO" 2>/dev/null

echo "[*] Reading DNS resolver info..."
DNS_INFO="$REPORT_DIR/dns_info.txt"
echo "[*] DNS Servers:" > "$DNS_INFO"
cat /etc/resolv.conf >> "$DNS_INFO" 2>/dev/null

echo "[*] Getting routing table..."
ROUTE_INFO="$REPORT_DIR/route_info.txt"
echo "[*] Routing Table:" > "$ROUTE_INFO"
ip route >> "$ROUTE_INFO" 2>/dev/null || echo "ip route not available" >> "$ROUTE_INFO"

echo "[*] Pinging 8.8.8.8 to check connectivity..."
PING_INFO="$REPORT_DIR/ping_info.txt"
echo "[*] Ping to 8.8.8.8:" > "$PING_INFO"
ping -c 4 8.8.8.8 >> "$PING_INFO" 2>/dev/null || echo "Ping failed" >> "$PING_INFO"

echo "[*] Getting MAC addresses..."
MAC_INFO="$REPORT_DIR/mac_info.txt"
echo "[*] MAC Addresses:" > "$MAC_INFO"
ip link show | grep ether >> "$MAC_INFO"

echo "[*] Fetching public IP..."
PUBLIC_IP_INFO="$REPORT_DIR/public_ip.txt"
echo "[*] Public IP:" > "$PUBLIC_IP_INFO"
curl -s https://ipinfo.io/ip >> "$PUBLIC_IP_INFO"

# Generate combined Markdown report
MD_REPORT="$REPORT_DIR/report.md"
echo "# Forensic Network Report - $(date)" > "$MD_REPORT"
cat "$IP_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$IFCONFIG_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$DNS_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$ROUTE_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$PING_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$MAC_INFO" >> "$MD_REPORT"
echo -e "\n" >> "$MD_REPORT"
cat "$PUBLIC_IP_INFO" >> "$MD_REPORT"

cd "$HOME/uzzol-os" || exit

echo "[*] Adding forensic reports to git..."
git add forensic-reports/*

echo "[*] Committing changes..."
git commit -m "Update forensic report: $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"

echo "[*] Pushing to GitHub using gh..."
gh repo push origin master

echo "[✔] Report generated and pushed."
echo "Markdown report path: $MD_REPORT"
