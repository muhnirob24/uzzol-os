#!/data/data/com.termux/files/usr/bin/bash

LOG_DIR="$HOME/uzzol-os/logs"
FILENAME="device_fingerprint_$(date +%Y-%m-%d_%H-%M-%S).md"
FULL_PATH="$LOG_DIR/$FILENAME"

mkdir -p "$LOG_DIR"

echo "## Device Fingerprint - $(date)" > "$FULL_PATH"
echo "**Device:** $(getprop ro.product.model)" >> "$FULL_PATH"
echo "**Brand:** $(getprop ro.product.brand)" >> "$FULL_PATH"
echo "**Android:** $(getprop ro.build.version.release)" >> "$FULL_PATH"
echo "**CPU:** $(getprop ro.product.cpu.abi)" >> "$FULL_PATH"
echo "**Kernel:** $(uname -r)" >> "$FULL_PATH"
echo "**Uptime:** $(uptime -p)" >> "$FULL_PATH"
echo "**RAM:**" >> "$FULL_PATH"
free -h >> "$FULL_PATH"

cd "$HOME/uzzol-os"
git add "$FULL_PATH"
git commit -m "Device fingerprint added: $(date)"
git push origin master
