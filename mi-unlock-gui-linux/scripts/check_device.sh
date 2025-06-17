#!/bin/bash
adb devices | grep -v "List" | grep "device"
