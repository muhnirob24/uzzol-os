# 🛡️ UZZOL OS - Cyber Forensic AI System

**UZZOL OS** হলো একটি লিনাক্স-ভিত্তিক আধুনিক সাইবার ফরেনসিক এবং AI অটোমেশন সিস্টেম যা রুটলেস মোবাইল এবং উবুন্টু উভয়েই কাজ করতে সক্ষম। এটি হার্ডওয়্যার এনালাইসিস, হিডেন ডিভাইস, ম্যালওয়্যার, ভাইরাস, মিনার এবং নেটওয়ার্ক একটিভিটি ট্র্যাকিংসহ একাধিক ফরেনসিক ফিচার সাপোর্ট করে।

---

## 🔍 মূল ফিচারসমূহ

- ✅ AI Device Fingerprint & System Audit
- ✅ USB, PCI, Hidden File/Folder Scan
- ✅ Suspicious Process, Miner & Malware Detection
- ✅ Network Scan (Public IP, DNS, VPN, WiFi)
- ✅ JSON, Markdown & HTML রিপোর্ট জেনারেশন
- ✅ Auto GitHub Integration & Backup
- ✅ Telegram বা Email Alert System (Optional)

---

## 📁 প্রোজেক্ট স্ট্রাকচার

```
uzzol-os/
└── ubuntu/
    ├── README.md
    ├── docs/
    ├── logs/
    │   └── forensic_report.json
    ├── src/
    │   └── forensic_advanced.py
    ├── tests/
    └── utils/
```

---

## ⚙️ প্রয়োজনীয় টুলস

```bash
sudo apt update && sudo apt install -y \
pciutils usbutils net-tools curl git gh lsof \
chkrootkit rkhunter nmap
```

---

## 🚀 রান করার নিয়ম

```bash
cd ~/uzzol-os/ubuntu/src
chmod +x forensic_advanced.py
./forensic_advanced.py
```

✅ রিপোর্ট পাওয়া যাবে: `../logs/forensic_report.json`

---

## 🐙 GitHub Auto Push (Optional)

```bash
cd ~/uzzol-os
gh repo create muhnirob24/uzzol-os --public --source=. --remote=origin --push
git add .
git commit -m "Initial commit: UZZOL OS Forensic AI System"
git push origin master
```

---

## 🔧 ভবিষ্যৎ উন্নয়ন

| ফিচার                         | টুল / স্ক্রিপ্ট                    | অবস্থা |
|------------------------------|------------------------------------|--------|
| Memory Dump & Live Forensics | `utils/memory_dump.sh`             | ⏳ উন্নয়নে |
| Rootkit Detection            | `chkrootkit`, `rkhunter`           | ✅ |
| Telegram Alert               | `scripts/telegram_alert.py`        | ✅ |
| HTML Report Viewer           | `tools/html_report.html`           | ⏳ |
| Web Dashboard Integration    | `localhost/dashboard/`             | ✅ |

---

## 📡 সিকিউরিটি লেয়ারে ফোকাস

- 🔒 **Hardware Level Scan:** PCI, USB, Virtual Block Devices
- 🧠 **AI Fingerprinting:** System identity + anomaly detection
- 📊 **Network Layer:** Public IP, VPN, DNS leak test
- 🐚 **Process Analysis:** Suspicious CPU/Mem heavy processes
- 🕵️ **Miner Detection:** Crypto miner এবং unusual background daemon check

---

## 📚 লেখক ও যোগাযোগ

**👨‍💻 MUH-Nirob-24**  
📧 Email: `nirobtch@gmail.com`  
🔗 GitHub: [github.com/muhnirob24](https://github.com/muhnirob24)

---

## 📄 লাইসেন্স

This project is licensed under the MIT License.  
© 2025 - UZZOL OS Project, maintained by MUH-Nirob.

---

> "নিরাপত্তা কোন বিলাসিতা নয় — এটা অধিকার।"
