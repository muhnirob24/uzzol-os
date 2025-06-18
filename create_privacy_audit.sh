#!/bin/bash

# 📍 Working Directory
cd /data/data/com.termux/files/home/uzzol-os || exit
echo "📁 Working Directory: $(pwd)"

# 🛠️ Create Project Structure
mkdir -p privacy-audit/{assets,inc,logs,api}
cd privacy-audit || exit

# 📝 index.php
cat << 'EOF' > index.php
<?php include("inc/device_info.php"); ?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>🛡️ Privacy Audit - Ultra Pro</title>
  <link href="assets/style.css" rel="stylesheet">
</head>
<body class="bg-gradient-to-br from-gray-900 to-black text-white min-h-screen p-6">
  <div class="max-w-2xl mx-auto bg-gray-800 p-6 rounded-xl shadow-lg">
    <h1 class="text-3xl font-bold mb-4">🔍 Privacy Audit Report</h1>
    <?php echo $deviceInfo; ?>
    <p class="text-sm mt-6">📅 <?php echo date("Y-m-d H:i:s"); ?></p>
  </div>
  <script src="api/client_data.js"></script>
</body>
</html>
EOF

# 📋 device_info.php
cat << 'EOF' > inc/device_info.php
<?php
function get_ip() {
    return $_SERVER['REMOTE_ADDR'] ?? 'Unknown';
}
$deviceInfo = "
<ul class='space-y-2'>
  <li><strong>IP Address:</strong> " . get_ip() . "</li>
  <li><strong>User Agent:</strong> " . $_SERVER['HTTP_USER_AGENT'] . "</li>
  <li><strong>Server OS:</strong> " . PHP_OS . "</li>
  <li><strong>Browser Info:</strong> " . ($_SERVER['HTTP_SEC_CH_UA'] ?? 'Unknown') . "</li>
</ul>
";
?>
EOF

# 🧾 Logger
cat << 'EOF' > inc/logger.php
<?php
$log = "[".date("Y-m-d H:i:s")."] IP: ".$_SERVER['REMOTE_ADDR']." | UA: ".$_SERVER['HTTP_USER_AGENT']."\n";
file_put_contents("../logs/access.log", $log, FILE_APPEND);
?>
EOF

# 🎨 Tailwind (CDN based)
cat << 'EOF' > assets/style.css
@import url('https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css');
EOF

# 📡 JavaScript (placeholder)
cat << 'EOF' > api/client_data.js
console.log("🧠 Collecting client-side sensor info...");
EOF

# 📘 README
cat << 'EOF' > README.md
# 🛡️ Privacy Audit (Ultra Pro)
A PHP-based local forensic tool to gather client browser/device information.
EOF

# 🔀 Git Init + Commit + Push using GitHub CLI
cd ..
echo "🔃 Initializing Git..."
git init
gh repo create privacy-audit --public --source=privacy-audit --remote=origin --push
cd privacy-audit
git add .
git commit -m "🚀 Initial Ultra Pro Privacy Audit Tool"
git push -u origin main

# 🌐 Start PHP Server (localhost:1234)
echo "🚀 Launching localhost at http://localhost:1234 ..."
php -S 127.0.0.1:1234
