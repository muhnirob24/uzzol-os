#!/bin/bash

# ✅ সেটআপ
PROJECT_DIR="$HOME/uzzol-os"
EMAIL="uzzolhassan38@gmail.com"
AUTHOR="MUH Nirob"
DATE=$(date)

cd "$PROJECT_DIR" || { echo "❌ Folder Not Found!"; exit 1; }

# ✅ Header template
readme_template() {
  echo "## 📁 $1

This directory is part of the **UZZOL OS** system, built by [$AUTHOR](mailto:$EMAIL).

> 📅 Last Updated: $DATE

### 🔍 Description:
$2

---
"
}

# ✅ ডিরেক্টরি-ডেসক্রিপশন পেয়ার
declare -A descriptions
descriptions[ai-bot-backend]="AI Bot backend logic and API connectors"
descriptions[api]="API integration handlers for forensic & automation"
descriptions[apk-exe-deb]="Software packages, builds & binaries"
descriptions[automation-panel]="Auto system setup and workflow automation"
descriptions[bdtech]="Bangla tech project demo and government solutions"
descriptions[bin]="Compiled scripts, tools and executable bash files"
descriptions[client-data]="Client records, logs, and sensitive configurations"
descriptions[database]="Database schema, tables, dumps and ORM models"
descriptions[docs]="Technical documentation, diagrams, research"
descriptions[ebook]="Guides, books, PDF for learning & selling"
descriptions[forensic-ai]="AI-based forensic detection system"
descriptions[forensic-reports]="Device reports and digital forensic case results"
descriptions[iot-defense]="IoT monitoring and device-level security modules"
descriptions[localhost]="Local test panel and frontend dashboards"
descriptions[logs]="Error log files, monitoring records, runtime dumps"
descriptions[payment-system]="Secure payment system & crypto gateway"
descriptions[scripts]="Shell scripts to automate every module"
descriptions[smart-spy-device]="Raspberry/ESP32-based spying and audio tracking"
descriptions[store]="Digital product and service marketplace"
descriptions[test-lab]="Offline lab testing and R&D experimental zone"
descriptions[tools]="Essential CLI/GUI tools and testing binaries"
descriptions[ui-kit]="Frontend assets: CSS/JS/HTML UI design elements"
descriptions[users]="User profile, permission, access and API keys"

# ✅ প্রতিটি ডিরেক্টরিতে README আপডেট
for dir in "${!descriptions[@]}"; do
  subdir="$PROJECT_DIR/$dir"
  if [ -d "$subdir" ]; then
    readme_file="$subdir/README.md"
    readme_template "$dir" "${descriptions[$dir]}" > "$readme_file"
    echo "[✔] Updated: $dir/README.md"
  fi
done

# ✅ লোকালহোস্ট ড্যাশবোর্ড স্পেশাল
DASH="$PROJECT_DIR/localhost/dashboard"
mkdir -p "$DASH"
echo "## 🌐 Localhost Dashboard

This dashboard shows live Forensic Email Log and Android Device Info Charts.
Visit: [http://127.0.0.1:8080](http://127.0.0.1:8080)

> Maintained by $AUTHOR" > "$DASH/README.md"

# ✅ GitHub Push
cd "$PROJECT_DIR"
git add .
git commit -m "🔄 Auto Updated All README.md files via script"
git push origin master

echo -e "\n✅ All done! Check your repo at: https://github.com/muhnirob24/uzzol-os"
