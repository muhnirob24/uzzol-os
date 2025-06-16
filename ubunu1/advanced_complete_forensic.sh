#!/bin/bash

# Description: This script performs an advanced forensic analysis on an Ubuntu laptop.
# It automatically collects various data, performs some basic analysis, and provides information for further investigation.
# Please remember that an automated script cannot replace the expertise of an experienced forensic specialist, and many cases will require manual investigation.
# This script will use root privileges (sudo). Instructions for using nano are included below.

# -------------------- CONFIGURATION --------------------
BACKUP_DIR="/tmp/advanced_complete_forensic_backup"
OUTPUT_FILE="$BACKUP_DIR/forensic_report.txt"
LOG_FILES=(
    "/var/log/auth.log"
    "/var/log/syslog"
    "/var/log/kern.log"
    "/var/log/dmesg"
    "/var/log/user.log"
    "/var/log/boot.log"
    "/var/log/faillog"
    "/var/log/account/summary.log"
    "/var/log/apache2/"
    "/var/log/nginx/"
    "/var/log/mysql.log"
    "/var/log/secure"
    "/var/log/audit/audit.log"
)
SUSPICIOUS_KEYWORD_LOG=(
    "failed password"
    "invalid user"
    "authentication failure"
    "denied"
    "error"
    "root login"
    "Accepted publickey"
    "reverse mapping"
    "command not found"
    "permission denied"
    "unauthorized access"
)
ROOTKIT_SCANNERS=(
    "chkrootkit"
    "rkhunter"
)
MEMORY_ANALYSIS_TOOL="volatility3"
NETWORK_CAPTURE_TOOL="tcpdump"
FILE_INTEGRITY_TOOL="aide"
SYSTEM_CONFIG_FILES=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/hosts"
    "/etc/resolv.conf"
    "/etc/network/interfaces"
    "/etc/fstab"
    "/etc/sudoers"
    "/etc/ssh/sshd_config"
    "/etc/apt/sources.list"
    "/etc/crontab"
    "/etc/security/passwdqc.conf"
    "/etc/pam.d/"
    "/etc/init/"
    "/etc/systemd/system/"
)
HIDDEN_DIRS_AND_FILES_TO_CHECK=(
    "/etc/.*"
    "/home/$USER/.*"
    "/var/tmp/.*"
    "/tmp/.*"
    "/dev/shm/.*"
    "/opt/.*"
    "/usr/local/.*"
)
CRYPTO_MINING_SUSPICIOUS_PROCESSES=(
    "xmrig"
    "cpuminer"
    "ethminer"
    "ccminer"
    "nicehash"
)

# -------------------- FUNCTIONS --------------------

function log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$OUTPUT_FILE"
}

function backup_files() {
    log_message "Starting file backup to directory: $BACKUP_DIR"
    sudo mkdir -p "$BACKUP_DIR/logs"
    for item in "${LOG_FILES[@]}"; do
        if [ -f "$item" ]; then
            sudo cp "$item" "$BACKUP_DIR/logs/$(basename "$item")"
            log_message "Backed up log file: $item"
        elif [ -d "$item" ]; then
            dir_name=$(basename "$item")
            sudo mkdir -p "$BACKUP_DIR/logs/$dir_name"
            sudo cp -r "$item"/* "$BACKUP_DIR/logs/$dir_name/"
            log_message "Backed up log directory: $item"
        fi
    done
    log_message "Log file backup complete."

    sudo mkdir -p "$BACKUP_DIR/config"
    for config_file in "${SYSTEM_CONFIG_FILES[@]}"; do
        if [ -f "$config_file" ]; then
            sudo cp "$config_file" "$BACKUP_DIR/config/$(basename "$config_file")"
            log_message "Backed up configuration file: $config_file"
        elif [ -d "$config_file" ]; then
            dir_name=$(basename "$config_file")
            sudo mkdir -p "$BACKUP_DIR/config/$dir_name"
            sudo cp -r "$config_file"/* "$BACKUP_DIR/config/$dir_name/"
            log_message "Backed up configuration directory: $config_file"
        fi
    done
    log_message "Configuration file backup complete."
}

function list_users() {
    log_message ""
    log_message "Listing system users:"
    cut -d':' -f1 /etc/passwd >> "$OUTPUT_FILE"
    log_message ""
    log_message "Last login information for users:"
    last -i >> "$OUTPUT_FILE"
    log_message "User listing and last login information complete."
}

function check_for_suspicious_logs() {
    log_message ""
    log_message "Searching for suspicious log messages:"
    for keyword in "${SUSPICIOUS_KEYWORD_LOG[@]}"; do
        log_message "Searching for keyword: $keyword"
        for log_file in "$BACKUP_DIR/logs/"*; do
            if [ -f "$log_file" ]; then
                sudo grep -i "$keyword" "$log_file" >> "$OUTPUT_FILE" 2>/dev/null
            fi
        done
    done
    log_message "Search for suspicious log messages complete."
}

function list_running_processes() {
    log_message ""
    log_message "Detailed listing of running processes:"
    ps auxww --sort=-%cpu,%mem,%nice >> "$OUTPUT_FILE"
    log_message ""
    log_message "Listing of running processes with full command:"
    ps -ef >> "$OUTPUT_FILE"
    log_message "Running processes listing complete."
}

function check_startup_services() {
    log_message ""
    log_message "Detailed listing of active systemd services:"
    systemctl list-units --type=service --state=active --full >> "$OUTPUT_FILE"
    log_message ""
    log_message "Listing of all systemd service unit files (active and inactive):"
    systemctl list-unit-files --type=service >> "$OUTPUT_FILE"
    log_message "Systemd services listing complete."
}

function check_cron_jobs() {
    log_message ""
    log_message "Cron jobs (user):"
    crontab -l >> "$OUTPUT_FILE" 2>/dev/null
    log_message ""
    log_message "Cron jobs (root):"
    sudo crontab -l >> "$OUTPUT_FILE" 2>/dev/null
    log_message ""
    log_message "System cron jobs:"
    sudo cat /etc/crontab /etc/cron.*/* >> "$OUTPUT_FILE" 2>/dev/null
    log_message "Cron job listing complete."
}

function run_rootkit_scanners() {
    log_message ""
    log_message "Starting rootkit scan..."
    for scanner in "${ROOTKIT_SCANNERS[@]}"; do
        log_message "Using scanner: $scanner"
        if command -v "$scanner" >/dev/null 2>&1; then
            sudo "$scanner" -c >> "$OUTPUT_FILE" 2>&1
        else
            log_message "Warning: $scanner is not installed. (You can install it with: sudo apt install $scanner)"
        fi
        log_message "Scan finished for: $scanner"
        log_message "--------------------"
    done
    log_message "Rootkit scan complete."
}

function check_listening_ports() {
    log_message ""
    log_message "Listing currently listening ports (IPv4 and IPv6):"
    sudo ss -tulnp4 >> "$OUTPUT_FILE"
    sudo ss -tulnp6 >> "$OUTPUT_FILE"
    log_message ""
    log_message "Listing all types of network sockets:"
    sudo ss -tunlp >> "$OUTPUT_FILE"
    log_message "Listening ports listing complete."
}

function check_network_config() {
    log_message ""
    log_message "Network Configuration:"
    echo "-------------------- /etc/hosts --------------------" >> "$OUTPUT_FILE"
    sudo cat /etc/hosts >> "$OUTPUT_FILE"
    echo "-------------------- /etc/resolv.conf --------------------" >> "$OUTPUT_FILE"
    sudo cat /etc/resolv.conf >> "$OUTPUT_FILE"
    echo "-------------------- /etc/network/interfaces --------------------" >> "$OUTPUT_FILE"
    sudo cat /etc/network/interfaces >> "$OUTPUT_FILE"
    log_message "Network configuration check complete."
}

function check_installed_packages() {
    log_message ""
    log_message "Listing installed packages:"
    dpkg --get-selections | grep -v deinstall >> "$OUTPUT_FILE"
    log_message ""
    log_message "Listing recently installed packages:"
    history | grep "apt install" >> "$OUTPUT_FILE"
    log_message "Installed packages listing complete."
}

function find_hidden_files_folders() {
    log_message ""
    log_message "Searching for hidden files and folders:"
    for item in "${HIDDEN_DIRS_AND_FILES_TO_CHECK[@]}"; do
        sudo find / -path "$item" -ls >> "$OUTPUT_FILE" 2>/dev/null
    done
    sudo find / -type f -name ".*" -print >> "$OUTPUT_FILE" 2>/dev/null # More general hidden files
    sudo find / -type d -name ".*" -print >> "$OUTPUT_FILE" 2>/dev/null # More general hidden folders
    log_message "Search for hidden files and folders complete."
}

function check_virtual_devices() {
    log_message ""
    log_message "Possible listing of virtual devices:"
    echo "Virtual network interfaces:" >> "$OUTPUT_FILE"
    ip addr show | grep -E 'tun|tap|veth' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo "Other virtual devices (review needed):" >> "$OUTPUT_FILE"
    ls /dev/virtio* 2>/dev/null >> "$OUTPUT_FILE"
    ls /dev/mapper/* 2>/dev/null >> "$OUTPUT_FILE"
    log_message "Virtual devices listing complete."
}

function check_crypto_mining_processes() {
    log_message ""
    log_message "Searching for suspicious processes related to crypto mining:"
    for process in "${CRYPTO_MINING_SUSPICIOUS_PROCESSES[@]}"; do
        pgrep -afi "$process" >> "$OUTPUT_FILE" 2>/dev/null
    done
    top -bn1 | grep -i -E "${CRYPTO_MINING_SUSPICIOUS_PROCESSES[*]}" >> "$OUTPUT_FILE" 2>/dev/null
    log_message "Search for suspicious crypto mining processes complete."
}

function perform_memory_analysis_check() {
    log_message ""
    log_message "Memory Analysis Check:"
    if command -v "$MEMORY_ANALYSIS_TOOL" >/dev/null 2>&1; then
        log_message "Suggestion: '$MEMORY_ANALYSIS_TOOL' is installed for memory analysis."
        log_message "You will need to first capture a memory dump (e.g., using লিbreoffice, fmem)."
        log_message "Then you can analyze the dump file using '$MEMORY_ANALYSIS_TOOL'."
        log_message "Example: sudo $MEMORY_ANALYSIS_TOOL -f /path/to/memory_dump windows.info"
        log_message "See '$MEMORY_ANALYSIS_TOOL --help' for more details."
    else
        log_message "Suggestion: Consider installing '$MEMORY_ANALYSIS_TOOL' for advanced memory analysis."
        log_message "To install: sudo apt update && sudo apt install -y python3-pip && pip3 install $MEMORY_ANALYSIS_TOOL"
    fi
    log_message "Memory Analysis Check complete."
}

function perform_network_analysis_guidance() {
    log_message ""
    log_message "Network Traffic Analysis Guidance:"
    if command -v "$NETWORK_CAPTURE_TOOL" >/dev/null 2>&1; then
        log_message "Suggestion: '$NETWORK_CAPTURE_TOOL' is installed for capturing network traffic."
        log_message "You can capture network traffic using the following command:"
        log_message "sudo $NETWORK_CAPTURE_TOOL -i any -s 0 -w $BACKUP_DIR/network_capture.pcap"
        log_message "(This will capture traffic from all interfaces and save it to '$BACKUP_DIR/network_capture.pcap')"
        log_message "After capturing, you can analyze the file using Wireshark or tshark."
    else
        log_message "Suggestion: Consider installing '$NETWORK_CAPTURE_TOOL' for network traffic analysis."
        log_message "To install: sudo apt update && sudo apt install -y $NETWORK_CAPTURE_TOOL"
    fi
    log_message "Network Traffic Analysis Guidance complete."
}

function perform_file_integrity_check() {
    log_message ""
    log_message "File Integrity Check (using aide):"
    if command -v "$FILE_INTEGRITY_TOOL" >/dev/null 2>&1; then
        if [ -f /var/lib/aide/aide.db.gz ]; then
            log_message "AIDE database found. Starting integrity check..."
            sudo aide --check >> "$OUTPUT_FILE" 2>&1
            log_message "AIDE integrity check complete."
        else
            log_message "Warning: AIDE database (/var/lib/aide/aide.db.gz) not found."
            log_message "You need to initialize the database first with: sudo aide --init"
        fi
    else
        log_message "Suggestion: Consider installing '$FILE_INTEGRITY_TOOL' for file integrity monitoring."
        log_message "To install: sudo apt update && sudo apt install -y $FILE_INTEGRITY_TOOL"
    fi
    log_message "File Integrity Check complete."
}

function check_suid_sgid_files() {
    log_message ""
    log_message "Checking for unusual SUID and SGID files:"
    find / -perm -4000 -o -perm -2000 -type f -print0 | xargs -0 ls -l >> "$OUTPUT_FILE" 2>/dev/null
    log_message "Check for unusual SUID and SGID files complete."
}

function check_dns_configuration() {
    log_message ""
    log_message "Checking DNS Configuration:"
    echo "Contents of /etc/resolv.conf:" >> "$OUTPUT_FILE"
    sudo cat /etc/resolv.conf >> "$OUTPUT_FILE" 2>/dev/null
    log_message "DNS Configuration check complete."
}

function hardware_malware_warning() {
    log_message ""
    log_message "Important Warning: Hardware malware detection is beyond the scope of this script."
    log_message "Detecting hardware-level malware requires specialized equipment and expertise."
    log_message "If you are concerned about hardware malware, please consult with a specialist."
}

function iot_security_reminder() {
    log_message ""
    log_message "IOT (Internet of Things) Device Security Reminder:"
    log_message "This script running on your Ubuntu laptop cannot directly analyze the security of your IoT devices."
    log_message "To ensure the security of your IoT devices, consider the following steps:"
    log_message "- Strengthen the security of your Wi-Fi router."
    log_message "- Keep the firmware of your IoT devices updated."
    log_message "- Use strong and unique passwords."
    log_message "- Disable or disconnect unnecessary IoT devices."
    log_message "- Monitor the network activity of your IoT devices through your router."
}

# -------------------- MAIN EXECUTION --------------------

echo "Starting Advanced Complete Ubuntu Laptop Forensic Script..."
log_message "Starting Advanced Complete Ubuntu Laptop Forensic Script..."
log_message "Backup directory: $BACKUP_DIR"
sudo mkdir -p "$BACKUP_DIR"

backup_files
list_users
check_for_suspicious_logs
list_running_processes
check_startup_services
check_cron_jobs
run_rootkit_scanners
check_listening_ports
check_network_config
check_installed_packages
find_hidden_files_folders
check_virtual_devices
check_crypto_mining_processes
perform_memory_analysis_check
perform_network_analysis_guidance
perform_file_integrity_check
check_suid_sgid_files
check_dns_configuration
hardware_malware_warning
iot_security_reminder

log_message "Advanced Complete Forensic Script finished. Output file: $OUTPUT_FILE"
echo "Advanced Complete Forensic Script finished. See '$OUTPUT_FILE' for detailed information."

# -------------------- USAGE INSTRUCTIONS --------------------
echo ""
echo "Usage Instructions:"
echo "1. Save this script to a text file (e.g., advanced_complete_forensic.sh)."
echo "   You can do this using nano: nano advanced_complete_forensic.sh"
echo "2. Open your terminal and navigate to the directory where you saved the script."
echo "3. Give the script execute permissions: chmod +x advanced_complete_forensic.sh"
echo "4. Run the script: sudo ./advanced_complete_forensic.sh"
echo "   You may be prompted for your sudo password for certain tasks like rootkit scans and accessing root's cron jobs."
echo ""
echo "Important Notes:"
echo "This script is designed to collect a wide range of information and perform some basic checks."
echo "However, a thorough and accurate forensic analysis often requires manual investigation, specialized tools, and expert knowledge."
echo "Pay close attention to the output file ('$OUTPUT_FILE') and consult with a cybersecurity professional if you find anything unusual or suspicious."
echo "For further information and resources on cyber security, you can visit nirobtech.com."
