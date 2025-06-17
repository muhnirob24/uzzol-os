#!/bin/bash
echo "1. Bootloader মোডে রিবুট"
echo "2. EDL মোডে রিবুট"
read -p "পছন্দ করুন (1 বা 2): " option

if [ "$option" == "1" ]; then
    adb reboot bootloader
elif [ "$option" == "2" ]; then
    adb reboot edl
else
    echo "ভুল অপশন"
fi
