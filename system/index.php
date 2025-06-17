<?php
// Displaying the current date and time
echo "<h2>Current Date and Time: " . date('Y-m-d H:i:s') . "</h2>";

// Getting the IP address of the client (your device)
$client_ip = $_SERVER['REMOTE_ADDR'];
echo "<h3>Your IP Address: $client_ip</h3>";

// Showing the Server Information
echo "<h3>Server Information</h3>";
echo "<pre>";
print_r($_SERVER);
echo "</pre>";

// Showing the PHP version and system information
echo "<h3>PHP Version: " . phpversion() . "</h3>";
echo "<h3>System Information</h3>";
echo "<pre>";
print_r(php_uname());
echo "</pre>";

// Displaying the PHP Configuration
echo "<h3>PHP Configuration (phpinfo())</h3>";
phpinfo();

// Show the file and directory list in the current directory
echo "<h3>File List in Current Directory</h3>";
$directory = __DIR__;
$files = scandir($directory);
echo "<ul>";
foreach($files as $file) {
    echo "<li>" . $file . "</li>";
}
echo "</ul>";

// Displaying the server's file permissions and ownership
echo "<h3>File Permissions and Ownership</h3>";
echo "<pre>";
echo "Current directory permissions: " . substr(sprintf('%o', fileperms($directory)), -4) . "\n";
echo "Owner of the current directory: " . fileowner($directory) . "\n";
echo "Group of the current directory: " . filegroup($directory) . "\n";
echo "</pre>";

// Showing the disk usage and free space available
echo "<h3>Disk Usage Information</h3>";
echo "<pre>";
echo "Disk space used: " . round(disk_total_space("/") / 1073741824, 2) . " GB\n";
echo "Disk space free: " . round(disk_free_space("/") / 1073741824, 2) . " GB\n";
echo "</pre>";
?>
