#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/muhnirob24/uzzol-os.git"
PROJECT_DIR="uzzol-os"
BRANCH="master"

echo "=== Starting GitHub upload and forensic report generation ==="

# 1. GitHub রিপোজিটরি ক্লোন বা আপডেট
if [ -d "$PROJECT_DIR" ]; then
    echo "Project folder found, updating repository..."
    cd "$PROJECT_DIR"
    git fetch origin "$BRANCH"
    git reset --hard origin/"$BRANCH"
else
    echo "Cloning repository..."
    git clone "$REPO_URL" --branch "$BRANCH" "$PROJECT_DIR"
    cd "$PROJECT_DIR"
fi

# 2. লোকাল কাজের ফাইলগুলো রিপোজিটরিতে কপি (যদি তুমি অন্য কোথাও কাজ করো)
# /bin/cp -r ../uzzol-os/* ./   # যদি একই ফোল্ডারে কাজ করো তাহলে এই লাইনটি কমেন্ট আউট করো

# 3. Git add, commit, push
echo "Adding changes..."
git add --all

if git diff --cached --quiet; then
    echo "No changes detected. Nothing to commit."
else
    echo "Committing changes..."
    git commit -m "Update project files and forensic scripts: $(date +'%Y-%m-%d %H:%M:%S')"
    echo "Pushing to remote..."
    git push origin "$BRANCH"
fi

# 4. ফরেনসিক রিপোর্ট জেনারেট করার স্ক্রিপ্ট চালাও (নিজের অনুযায়ী স্ক্রিপ্ট নাম বদলাও)
if [ -f "./scripts/full-forensic-master.sh" ]; then
    echo "Running forensic report generation script..."
    chmod +x ./scripts/full-forensic-master.sh
    ./scripts/full-forensic-master.sh
else
    echo "Warning: forensic script not found, skipping report generation."
fi

# 5. রিপোর্ট আপডেট হলে আবার গিট এড, কমিট, পুশ করো
git add forensic-reports/
if git diff --cached --quiet; then
    echo "No new forensic reports to commit."
else
    git commit -m "Update forensic reports: $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin "$BRANCH"
fi

echo "=== Upload and forensic process completed! ==="
