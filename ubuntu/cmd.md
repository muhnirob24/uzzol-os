# UZZOL OS - Advanced Ubuntu Forensic & Recon Command Set

```bash
# ------------------------
# SYSTEM & KERNEL DEEP INSPECTION
# ------------------------
uname -a
cat /proc/version
cat /proc/sys/kernel/osrelease
sysctl -a | grep kernel
cat /etc/issue
lsmod
modprobe -l
dmesg | grep -i error
dmesg | grep -i fail

# ------------------------
# MEMORY ANALYSIS & SWAP
# ------------------------
free -m
vmstat 1 5
cat /proc/swaps
smem -tk
sudo grep -i -r "OOM" /var/log/

# ------------------------
# PCI & USB DEVICES + VIRTUAL DEVICES
# ------------------------
lspci -vvv
lsusb -vvv
lsusb -t
udevadm info --query=all --name=/dev/sda
udevadm monitor --udev
ls /sys/class/net/
ls /sys/class/pci_bus/

# ------------------------
# FILESYSTEM & STORAGE DEEP SCAN
# ------------------------
find / -xdev -type f -name ".*" -exec ls -la {} \;
find / -xdev -type f -size +100M -exec ls -lh {} \;
find / -xdev -type f -perm -4000 -exec ls -la {} \;    # SUID files
find / -xdev -type f -perm -2000 -exec ls -la {} \;    # SGID files
lsattr -d -R /
df -i
tune2fs -l /dev/sda1

# ------------------------
# HIDDEN & MALICIOUS FILE DETECTION
# ------------------------
chkrootkit -q
rkhunter --check
lynis audit system
clamav-freshclam
clamscan -r --bell -i /
strings /usr/bin/* | grep -i password
find / -name '*.so' -exec ldd {} \; | grep 'not found'

# ------------------------
# NETWORK & CONNECTIONS ADVANCED
# ------------------------
ip a
ip route show
ss -tupan
netstat -tulnp
iptables -L -v -n
ip6tables -L -v -n
nmap -sS -O -sV localhost
nmap -sS -O -sV <target-ip>
tcpdump -i any -nn -s0 -c 1000 -w /tmp/packets.pcap
tshark -r /tmp/packets.pcap -q -z conv,ip
curl --interface eth0 ifconfig.me
nmcli general status
nmcli device show

# ------------------------
# PROCESSES & SERVICES INSPECTION
# ------------------------
ps aux --sort=-%mem | head -20
pstree -p
top -b -n 1 | head -40
pgrep -laf sshd
lsof -i -n -P | grep LISTEN
systemctl list-units --type=service --state=running
systemctl status <service-name>
journalctl -xe --no-pager

# ------------------------
# USER & AUTHENTICATION AUDIT
# ------------------------
last -F | head -20
lastb -F | head -20
who -a
w
id <user>
groups <user>
getent passwd
getent shadow
getent group
sudo cat /etc/sudoers
sudo cat /etc/security/access.conf
sudo cat /etc/pam.d/common-auth
faillog -u <user>
lastlog -u <user>
pam_tally2 --user <user>

# ------------------------
# CRON, AT, & SCHEDULED TASKS
# ------------------------
crontab -l -u root
crontab -l -u <user>
ls -la /etc/cron.*
cat /etc/crontab
systemctl list-timers --all
atq
batch

# ------------------------
# LOGS & AUDIT TRAILS
# ------------------------
journalctl --since "2 days ago" --no-pager
tail -100 /var/log/syslog
tail -100 /var/log/auth.log
tail -100 /var/log/kern.log
auditctl -s
ausearch -ts recent
ausearch -m USER_LOGIN,USER_LOGOUT
ausearch -i -m EXECVE
ausearch -i -m SYSCALL --success no

# ------------------------
# SOFTWARE PACKAGES & VULNERABILITY
# ------------------------
dpkg -l
apt list --upgradable
apt policy <package>
snap list
flatpak list
sudo apt update && sudo apt upgrade -y
sudo apt install -y lynis chkrootkit rkhunter clamav clamtk tcpdump tshark net-tools htop git curl wget strace ltrace lsof auditd fail2ban

# ------------------------
# KERNEL MODULE & CONFIGURATION
# ------------------------
cat /boot/config-$(uname -r)
lsmod
modinfo <module>
sysctl -a | grep net.ipv4.tcp
sysctl -a | grep fs.inotify

# ------------------------
# ENVIRONMENT & LIMITS
# ------------------------
printenv
ulimit -a
cat /etc/security/limits.conf

# ------------------------
# USB & EXTERNAL DEVICE MONITORING
# ------------------------
lsusb
lsusb -t
udevadm monitor
dmesg | grep usb
usb-devices

# ------------------------
# BACKUPS & SNAPSHOTS
# ------------------------
ls /var/backups
ls /etc/backup
timeshift --list
rsnapshot config show

# ------------------------
# FILE INTEGRITY MONITORING
# ------------------------
aide --check
tripwire --check
lsattr -R /
chattr +i /etc/passwd

# ------------------------
# MALWARE & ROOTKIT SCANS
# ------------------------
chkrootkit -q
rkhunter --check --sk
clamscan -r -i /home
lynis audit system

# ------------------------
# VIRTUALIZATION & CONTAINERIZATION
# ------------------------
systemctl status docker
docker ps -a
lxc-ls --fancy
virsh list --all

# ------------------------
# SUSPICIOUS ACTIVITY & TIMESTAMPS
# ------------------------
find / -type f -ctime -7 -exec ls -lh {} \;
find / -type f -mtime -7 -exec ls -lh {} \;

# ------------------------
# NETWORK PACKET CAPTURE
# ------------------------
sudo tcpdump -i any -nn -s0 -c 1000 -w /tmp/packets.pcap
sudo tshark -r /tmp/packets.pcap -q -z conv,ip

# ------------------------
# DEBUGGING & SYSTEM CALL TRACE
# ------------------------
strace -p $(pgrep <process>)
ltrace -p $(pgrep <process>)

# ------------------------
# SUSPICIOUS STRINGS & BINARIES
# ------------------------
strings /usr/bin/* | grep -i password
ldd /usr/bin/<binary> | grep 'not found'

# ------------------------
# FIREWALL & IPTABLES
# ------------------------
sudo ufw status verbose
sudo iptables -L -v -n
sudo ip6tables -L -v -n

# ------------------------
# NETWORK SCANNING
# ------------------------
nmap -sS -O -sV localhost
nmap -sS -O -sV <target-ip>

# ------------------------
# TIPS
# ------------------------
echo "Run freshclam regularly to update ClamAV DB"
echo "Use auditd for detailed system auditing"
echo "Use lynis for security auditing and hardening"
echo "Regularly check critical logs and network captures"
echo "Keep your system and tools updated"
