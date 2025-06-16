#!/bin/bash

# পুরাতন ubuntu/ ডিলিট করা
echo "[+] Removing old ubuntu/ folder..."
rm -rf ubuntu
git rm -r --cached ubuntu

# নতুন ubuntu/ ফোল্ডার তৈরি করা
echo "[+] Creating fresh ubuntu/ forensic module..."
mkdir -p ubuntu/{docs,logs,src,tests,utils}
touch ubuntu/{README.md,docs/.gitkeep,logs/.gitkeep,src/forensic_advanced.py,tests/.gitkeep,utils/.gitkeep}

# প্রাথমিক README ফাইল লেখা
cat <<EOF > ubuntu/README.md
# Ubuntu Forensic Module

This module is part of the **UZZOL OS Cyber Forensic System**. It contains advanced forensic scripts, logs, test cases, and utilities specifically designed for Ubuntu Linux systems.

## Structure
- \`docs/\` : Documentation
- \`logs/\` : Generated forensic logs
- \`src/\` : Python-based forensic tools
- \`tests/\` : Testing scripts
- \`utils/\` : Utility helpers

---

Developed with ❤️ for Linux Forensic Automation.
EOF

# Git add, commit, and push
echo "[+] Adding to Git and pushing to GitHub..."
git add ubuntu
git commit -m "Recreated ubuntu forensic module from scratch"
git push origin master

echo "[✓] Ubuntu forensic module created and pushed successfully."
