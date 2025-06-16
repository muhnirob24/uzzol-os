#!/data/data/com.termux/files/usr/bin/bash

# Config
REPO_DIR="$HOME/uzzol-os"
REPORT_DIR="$REPO_DIR/forensic-reports"
HTML_REPORT="$REPORT_DIR/network_report.html"
MD_REPORT="$REPORT_DIR/report.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

mkdir -p "$REPORT_DIR"
cd "$REPO_DIR" || { echo "Repo dir not found!"; exit 1; }

echo "[*] Collecting IP address info..."
IP_INFO=$(ip addr show 2>/dev/null)

echo "[*] Collecting ifconfig info..."
IFCONFIG_INFO=$(ifconfig 2>/dev/null)

echo "[*] Reading DNS resolver info..."
DNS_INFO=$(cat /etc/resolv.conf 2>/dev/null)

echo "[*] Getting routing table..."
ROUTE_INFO=$(ip route 2>/dev/null)

echo "[*] Pinging 8.8.8.8 to check connectivity..."
PING_INFO=$(ping -c 4 8.8.8.8 2>/dev/null)

echo "[*] Getting MAC addresses..."
MAC_ADDRESSES=$(ip link show | grep -E 'link/ether' | awk '{print $2}')

echo "[*] Fetching public IP..."
PUB_IP=$(curl -s https://api.ipify.org || echo "Public IP fetch failed")

echo "[*] Fetching WiFi connection info (termux-api)..."
if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
    WIFI_INFO=$(termux-wifi-connectioninfo)
else
    WIFI_INFO="termux-wifi-connectioninfo not found"
fi

echo "[*] Fetching location info (termux-api)..."
if command -v termux-location >/dev/null 2>&1; then
    LOCATION_INFO=$(termux-location -p network -r 1)
else
    LOCATION_INFO="termux-location not found or permission denied"
fi

echo "[*] Scanning nearby WiFi (termux-api)..."
if command -v termux-wifi-scaninfo >/dev/null 2>&1; then
    WIFI_SCAN=$(termux-wifi-scaninfo)
else
    WIFI_SCAN="termux-wifi-scaninfo not found or permission denied"
fi

echo "[*] Fetching signal strength info..."
if command -v dumpsys >/dev/null 2>&1; then
    SIGNAL_INFO=$(dumpsys telephony.registry | grep -i signalstrength)
else
    SIGNAL_INFO="dumpsys not available"
fi

# Generate HTML report
cat > "$HTML_REPORT" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Advanced Network Forensic Report</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; background: #f9f9f9; color: #333; }
    h1 { background: #007BFF; color: white; padding: 10px; border-radius: 8px; }
    section { background: white; padding: 15px; margin-bottom: 20px; border-radius: 8px;
      box-shadow: 0 0 5px rgba(0,0,0,0.1); }
    pre { background: #eee; padding: 10px; border-radius: 5px; overflow-x: auto; white-space: pre-wrap; word-wrap: break-word; }
  </style>
</head>
<body>
  <h1>📡 Advanced Network Forensic Report</h1>
  <p><strong>Generated:</strong> $DATE</p>

  <section>
    <h2>🌐 IP Address Info</h2>
    <pre>$IP_INFO</pre>
  </section>

  <section>
    <h2>📶 Interface Info (ifconfig)</h2>
    <pre>$IFCONFIG_INFO</pre>
  </section>

  <section>
    <h2>🧠 DNS Resolver</h2>
    <pre>$DNS_INFO</pre>
  </section>

  <section>
    <h2>🚦 Routing Table</h2>
    <pre>$ROUTE_INFO</pre>
  </section>

  <section>
    <h2>📡 Ping Test (8.8.8.8)</h2>
    <pre>$PING_INFO</pre>
  </section>

  <section>
    <h2>🆔 MAC Addresses</h2>
    <pre>$MAC_ADDRESSES</pre>
  </section>

  <section>
    <h2>🌍 Public IP</h2>
    <pre>$PUB_IP</pre>
  </section>

  <section>
    <h2>📶 WiFi Connection Info</h2>
    <pre>$WIFI_INFO</pre>
  </section>

  <section>
    <h2>📍 Location Info</h2>
    <pre>$LOCATION_INFO</pre>
  </section>

  <section>
    <h2>📡 Nearby WiFi Scan</h2>
    <pre>$WIFI_SCAN</pre>
  </section>

  <section>
    <h2>📶 Signal Strength</h2>
    <pre>$SIGNAL_INFO</pre>
  </section>

</body>
</html>
EOF

# Generate markdown report
cat > "$MD_REPORT" <<EOF
# 🌐 Advanced Network Forensic Report

**Generated on:** $DATE

## 🌐 IP Address Info
\`\`\`
$IP_INFO
\`\`\`

## 📶 Interface Info (ifconfig)
\`\`\`
$IFCONFIG_INFO
\`\`\`

## 🧠 DNS Resolver
\`\`\`
$DNS_INFO
\`\`\`

## 🚦 Routing Table
\`\`\`
$ROUTE_INFO
\`\`\`

## 📡 Ping Test (8.8.8.8)
\`\`\`
$PING_INFO
\`\`\`

## 🆔 MAC Addresses
\`\`\`
$MAC_ADDRESSES
\`\`\`

## 🌍 Public IP
\`\`\`
$PUB_IP
\`\`\`

## 📶 WiFi Connection Info
\`\`\`
$WIFI_INFO
\`\`\`

## 📍 Location Info
\`\`\`
$LOCATION_INFO
\`\`\`

## 📡 Nearby WiFi Scan
\`\`\`
$WIFI_SCAN
\`\`\`

## 📶 Signal Strength
\`\`\`
$SIGNAL_INFO
\`\`\`
EOF

# Git commit and push
git add "$HTML_REPORT" "$MD_REPORT"
git commit -m "Update forensic report: $DATE"
git push origin main || git push origin master

echo "[✔] Report generated and pushed."
echo "HTML report path: $HTML_REPORT"
echo "Markdown report path: $MD_REPORT"
