#!/bin/bash
# Basic Android device info grabber using adb (must be connected)

adb shell getprop > android_device_info.txt
echo "Android device info saved to android_device_info.txt"
