#!/bin/bash

echo "Starting Mi Bootloader Unlock Script..."

if ! command -v adb &> /dev/null
then
    echo "adb not found, installing..."
    if command -v pkg &> /dev/null; then
        pkg update -y && pkg install android-tools -y
    else
        sudo apt update && sudo apt install android-tools-adb -y
    fi
fi

if ! command -v fastboot &> /dev/null
then
    echo "fastboot not found, installing..."
    if command -v pkg &> /dev/null; then
        pkg update -y && pkg install android-tools-fastboot -y
    else
        sudo apt update && sudo apt install android-tools-fastboot -y
    fi
fi

echo "Checking connected devices..."
adb devices

echo "Rebooting device to bootloader..."
adb reboot bootloader
sleep 10

echo "Starting fastboot unlock..."
fastboot flashing unlock

echo "Please confirm unlock on your device screen."

echo "Unlock process triggered. Rebooting device..."
fastboot reboot

echo "Done."
