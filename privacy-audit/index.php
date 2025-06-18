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
