#!/bin/bash

# --- Ask for GitHub repo details ---
read -p "Enter your GitHub repo name (e.g. ubuntu-forensic-advanced): " repo_name
read -p "Enter your GitHub repo description: " repo_desc

# --- Create GitHub repo using gh CLI ---
echo "[*] Creating GitHub repo: $repo_name ..."
gh repo create "$repo_name" --public --description "$repo_desc" --confirm || { echo "Repo creation failed"; exit 1; }

# --- Create project folder structure ---
mkdir -p "$repo_name"/{src,logs,docs,utils,tests}
cd "$repo_name" || exit 1

# --- Create advanced forensic python script ---
cat > src/forensic_advanced.py << 'EOF'
#!/usr/bin/env python3
import os
import platform
import subprocess
import hashlib
from datetime import datetime

def run_cmd(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, universal_newlines=True, stderr=subprocess.DEVNULL)
    except Exception as e:
        return f"Error executing '{cmd}': {e}"

def gather_system_info():
    data = {
        "OS": platform.platform(),
        "Hostname": platform.node(),
        "Kernel": platform.release(),
        "Uptime": run_cmd("uptime -p"),
        "CPU Info": run_cmd("lscpu"),
        "Memory Usage": run_cmd("free -h"),
        "Disk Usage": run_cmd("df -h"),
        "PCI Devices": run_cmd("lspci -vv"),
        "USB Devices": run_cmd("lsusb"),
        "Loaded Kernel Modules": run_cmd("lsmod"),
        "Network Interfaces": run_cmd("ip addr show"),
        "Open Ports": run_cmd("ss -tuln"),
        "Top Processes": run_cmd("ps aux --sort=-%mem | head -20"),
        "Recent Logins": run_cmd("last -a | head -20"),
        "Mounted Drives": run_cmd("mount | grep ^/dev"),
        "Virtual Devices": run_cmd("ls /dev | grep -E 'loop|ram|fd|null|zero'"),
        "Sudo Log (last 20)": run_cmd("ausearch -m USER_CMD | tail -20") if os.path.exists("/var/log/audit/audit.log") else "auditd not found",
    }
    return data

def file_sha256(path):
    try:
        hasher = hashlib.sha256()
        with open(path, 'rb') as f:
            while chunk := f.read(8192):
                hasher.update(chunk)
        return hasher.hexdigest()
    except Exception as e:
        return f"Error hashing file {path}: {e}"

def scan_hidden_files(path="/"):
    hidden = []
    for root, dirs, files in os.walk(path):
        # skip some virtual/proc filesystems for speed and errors
        if root.startswith("/proc") or root.startswith("/sys") or root.startswith("/run"):
            continue
        try:
            for d in dirs:
                if d.startswith('.'):
                    hidden.append(os.path.join(root, d))
            for f in files:
                if f.startswith('.'):
                    hidden.append(os.path.join(root, f))
        except Exception:
            continue
    return hidden[:100]  # limit to first 100 hidden files/dirs

def critical_files_hash():
    files = [
        "/etc/passwd",
        "/etc/shadow",
        "/etc/hosts",
        "/etc/ssh/sshd_config",
        "/boot/grub/grub.cfg",
        "/etc/fstab",
    ]
    hashes = {}
    for file in files:
        if os.path.exists(file):
            hashes[file] = file_sha256(file)
        else:
            hashes[file] = "Not found"
    return hashes

def suspicious_process_check():
    suspicious_words = ['malware','cryptominer','keylogger','exploit','backdoor','ransom','botnet','minerd']
    try:
        ps = run_cmd("ps aux").lower()
        suspects = [w for w in suspicious_words if w in ps]
        if suspects:
            return suspects
        else:
            return "No suspicious processes detected"
    except:
        return "Error checking processes"

def get_recent_logs():
    logfiles = [
        "/var/log/syslog",
        "/var/log/auth.log",
        "/var/log/kern.log",
        "/var/log/dpkg.log"
    ]
    logs = {}
    for log in logfiles:
        if os.path.exists(log):
            logs[log] = run_cmd(f"tail -n 30 {log}")
        else:
            logs[log] = "Log file missing"
    return logs

def main():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    os.makedirs("logs", exist_ok=True)
    report_path = f"logs/forensic_report_{timestamp}.txt"

    with open(report_path, "w") as f:
        f.write("=== Ubuntu Advanced Forensic Report ===\n")
        f.write(f"Generated: {timestamp}\n\n")

        sysinfo = gather_system_info()
        for k,v in sysinfo.items():
            f.write(f"--- {k} ---\n{v}\n\n")

        f.write("--- Critical Files SHA256 ---\n")
        cf = critical_files_hash()
        for file, hsh in cf.items():
            f.write(f"{file}: {hsh}\n")
        f.write("\n")

        f.write("--- Hidden Files (first 100) ---\n")
        hidden = scan_hidden_files()
        for h in hidden:
            f.write(f"{h}\n")
        f.write("\n")

        f.write("--- Suspicious Processes ---\n")
        suspicious = suspicious_process_check()
        if isinstance(suspicious, list):
            for s in suspicious:
                f.write(f"{s}\n")
        else:
            f.write(f"{suspicious}\n")
        f.write("\n")

        f.write("--- Recent Logs (last 30 lines) ---\n")
        logs = get_recent_logs()
        for logfile, content in logs.items():
            f.write(f"*** {logfile} ***\n{content}\n\n")

    print(f"Report saved: {report_path}")

if __name__ == "__main__":
    main()
EOF

chmod +x src/forensic_advanced.py

# --- Create README.md ---
cat > README.md << EOF
# $repo_name

$repo_desc

## Overview

Advanced Ubuntu forensic project to collect detailed system info, device info, hidden files, suspicious process checks, sudo logs, and generate timestamped reports.

## Requirements

- python3
- pciutils (for lspci)
- usbutils (for lsusb)
- auditd (for sudo command audit logs)
- sudo privileges to run

## Installation

\`\`\`bash
sudo apt update && sudo apt install -y python3 pciutils usbutils auditd
sudo systemctl enable auditd && sudo systemctl start auditd
\`\`\`

## Usage

Run the main forensic script with sudo:

\`\`\`bash
sudo python3 src/forensic_advanced.py
\`\`\`

Reports saved in \`logs/\` directory.

## License

MIT License
EOF

# --- Create .gitignore ---
cat > .gitignore << EOF
logs/
__pycache__/
*.pyc
EOF

# --- Initialize Git and push ---
git init
git add .
git commit -m "Initial commit - Advanced Ubuntu forensic with hidden files, devices, sudo audit and logs"
git remote add origin $(gh repo view "$repo_name" --json sshUrl -q .sshUrl)
git branch -M main
git push -u origin main

echo "=============================="
echo "Project '$repo_name' created & pushed!"
echo "Run forensic with:"
echo "  sudo python3 src/forensic_advanced.py"
echo "=============================="
