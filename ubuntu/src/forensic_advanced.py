#!/usr/bin/env python3
# forensic_advanced.py
# UZZOL OS - Advanced Ubuntu Cyber Forensic AI System
# Author: muhnirob24
# Date: 2025-06-16

import os
import sys
import platform
import json
import subprocess
import hashlib
import socket
import datetime
import re
from pathlib import Path

LOG_DIR = Path.home() / "uzzol-os" / "ubuntu" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)
REPORT_FILE = LOG_DIR / f"forensic_report_{datetime.datetime.now().strftime('%Y%m%d_%H%M%S')}.json"

def run_cmd(cmd):
    """Run shell command and return output."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=20)
        return result.stdout.strip()
    except Exception as e:
        return f"Error running {cmd}: {e}"

def hash_file(filepath):
    """Calculate SHA256 hash of a file."""
    try:
        sha256 = hashlib.sha256()
        with open(filepath, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                sha256.update(chunk)
        return sha256.hexdigest()
    except Exception as e:
        return f"Error hashing {filepath}: {e}"

def collect_system_info():
    info = {}
    info['platform'] = platform.platform()
    info['system'] = platform.system()
    info['release'] = platform.release()
    info['version'] = platform.version()
    info['machine'] = platform.machine()
    info['processor'] = platform.processor()
    info['hostname'] = socket.gethostname()
    info['ip_addresses'] = socket.gethostbyname_ex(socket.gethostname())[2]
    info['uptime'] = run_cmd("uptime -p")
    info['cpu_info'] = run_cmd("lscpu")
    info['memory_info'] = run_cmd("free -h")
    info['disk_usage'] = run_cmd("df -h --total | grep total")
    return info

def detect_hidden_files(dirs_to_scan=None):
    if dirs_to_scan is None:
        dirs_to_scan = [Path.home(), Path("/etc"), Path("/var"), Path("/opt")]
    hidden_files = {}
    for directory in dirs_to_scan:
        if directory.exists():
            try:
                # find all files and dirs starting with dot (hidden)
                result = run_cmd(f"find {directory} -name '.*' -print 2>/dev/null | head -n 1000")
                hidden_files[str(directory)] = result.splitlines()
            except Exception as e:
                hidden_files[str(directory)] = [f"Error scanning: {e}"]
    return hidden_files

def hash_important_files(files=None):
    if files is None:
        files = ["/etc/passwd", "/etc/shadow", "/etc/group", "/etc/hosts"]
    hashes = {}
    for f in files:
        path = Path(f)
        if path.exists():
            hashes[f] = hash_file(f)
        else:
            hashes[f] = "File not found"
    return hashes

def check_suspicious_processes():
    suspicious_keywords = ['miner', 'crypt', 'coin', 'hack', 'malware', 'bash', 'curl', 'wget', 'nc', 'netcat']
    output = run_cmd("ps aux")
    suspicious = []
    for line in output.splitlines():
        for keyword in suspicious_keywords:
            if re.search(rf'\b{keyword}\b', line, re.IGNORECASE):
                suspicious.append(line)
                break
    return suspicious

def extract_logs(log_files=None):
    if log_files is None:
        log_files = ["/var/log/auth.log", "/var/log/syslog", "/var/log/kern.log", "/var/log/dmesg"]
    logs = {}
    for logfile in log_files:
        try:
            path = Path(logfile)
            if path.exists():
                content = run_cmd(f"tail -n 100 {logfile}")
                logs[logfile] = content
            else:
                logs[logfile] = "Log file not found"
        except Exception as e:
            logs[logfile] = f"Error reading log: {e}"
    return logs

def scan_network_activity():
    net_info = {}
    net_info['open_ports'] = run_cmd("ss -tulnp")
    net_info['routing_table'] = run_cmd("route -n")
    net_info['iptables'] = run_cmd("sudo iptables -L -n -v || echo 'No iptables or permission denied'")
    net_info['network_interfaces'] = run_cmd("ip a")
    net_info['active_connections'] = run_cmd("netstat -tunap")
    return net_info

def detect_usb_pci_devices():
    devices = {}
    devices['usb_devices'] = run_cmd("lsusb")
    devices['pci_devices'] = run_cmd("lspci -v")
    return devices

def suspicious_folder_scan(paths=None):
    if paths is None:
        paths = [Path.home() / d for d in [".config", ".cache", ".ssh", ".gnupg"]]
    suspicious = {}
    for p in paths:
        if p.exists():
            try:
                suspicious[p.as_posix()] = run_cmd(f"ls -al {p}")
            except Exception as e:
                suspicious[p.as_posix()] = f"Error scanning folder: {e}"
        else:
            suspicious[p.as_posix()] = "Folder not found"
    return suspicious

def export_to_json(data):
    try:
        with open(REPORT_FILE, "w") as f:
            json.dump(data, f, indent=4)
        print(f"[+] Report saved to {REPORT_FILE}")
    except Exception as e:
        print(f"[-] Failed to save report: {e}")

def main():
    print("[*] Starting UZZOL OS Advanced Forensic Scan ...")
    report = {}

    report['system_info'] = collect_system_info()
    print("[*] Collected system info")

    report['hidden_files'] = detect_hidden_files()
    print("[*] Hidden files scanned")

    report['important_file_hashes'] = hash_important_files()
    print("[*] Important file hashes computed")

    report['suspicious_processes'] = check_suspicious_processes()
    print(f"[*] Suspicious processes found: {len(report['suspicious_processes'])}")

    report['logs'] = extract_logs()
    print("[*] Extracted system logs")

    report['network_activity'] = scan_network_activity()
    print("[*] Network activity scanned")

    report['usb_pci_devices'] = detect_usb_pci_devices()
    print("[*] USB and PCI devices scanned")

    report['suspicious_folders'] = suspicious_folder_scan()
    print("[*] Suspicious folder scan complete")

    export_to_json(report)
    print("[*] Forensic scan complete.")

if __name__ == "__main__":
    main()
