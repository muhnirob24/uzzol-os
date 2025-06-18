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
