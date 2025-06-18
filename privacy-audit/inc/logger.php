<?php
$log = "[".date("Y-m-d H:i:s")."] IP: ".$_SERVER['REMOTE_ADDR']." | UA: ".$_SERVER['HTTP_USER_AGENT']."\n";
file_put_contents("../logs/access.log", $log, FILE_APPEND);
?>
