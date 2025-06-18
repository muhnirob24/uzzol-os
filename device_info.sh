#!/bin/bash

echo "##################################################"
echo "# অ্যান্ড্রয়েড ফোন তথ্য সংগ্রাহক (রুটলেস টার্মিনাল)"
echo "##################################################"
echo ""

# অ্যান্ড্রয়েড সংস্করণ
echo "অ্যান্ড্রয়েড সংস্করণ:"
getprop ro.build.version.release
echo ""

# ডিভাইস মডেল এবং প্রস্তুতকারক
echo "ডিভাইস তথ্য:"
echo "  মডেল: $(getprop ro.product.model)"
echo "  প্রস্তুতকারক: $(getprop ro.product.manufacturer)"
echo "  ব্র্যান্ড: $(getprop ro.product.brand)"
echo "  ডিভাইস: $(getprop ro.product.device)"
echo ""

# সিপিইউ তথ্য
echo "সিপিইউ তথ্য:"
cat /proc/cpuinfo | grep "model name" | head -n 1
echo ""

# র‍্যাম তথ্য
echo "র‍্যাম তথ্য:"
free -h | grep "Mem"
echo ""

# অভ্যন্তরীণ স্টোরেজ
echo "অভ্যন্তরীণ স্টোরেজ:"
df -h | grep "/data"
echo ""

# বাহ্যিক স্টোরেজ (যদি থাকে)
echo "বাহ্যিক স্টোরেজ (যদি থাকে):"
df -h | grep "/storage/[0-9A-F]{4}-[0-9A-F]{4}" || echo "বাহ্যিক স্টোরেজ পাওয়া যায়নি।"
echo ""

# নেটওয়ার্ক তথ্য (ওয়াইফাই)
echo "নেটওয়ার্ক তথ্য (ওয়াইফাই):"
ip addr show wlan0 | grep "inet "
echo ""

# ব্যাটারি তথ্য
echo "ব্যাটারি তথ্য:"
if [ -f /sys/class/power_supply/battery/capacity ]; then
    echo "  চার্জের পরিমাণ: $(cat /sys/class/power_supply/battery/capacity)%"
fi
if [ -f /sys/class/power_supply/battery/status ]; then
    echo "  অবস্থা: $(cat /sys/class/power_supply/battery/status)"
fi
echo ""

# ইনস্টল করা প্যাকেজ (অ্যাপ্লিকেশন)
echo "ইনস্টল করা অ্যাপ্লিকেশন (প্রথম কয়েকটি):"
pm list packages | head -n 10
echo " (আরও অ্যাপ্লিকেশন দেখতে পুরো স্ক্রিপ্ট চালান)"
echo ""

# সেন্সর তালিকা (সম্পূর্ণ নাও হতে পারে রুটের অনুমতি ছাড়া)
echo "উপলভ্য সেন্সর (সম্পূর্ণ নাও হতে পারে):"
dumpsys sensor | grep "Sensor List:" -A 10
echo " (আরও বিস্তারিত তথ্য রুটের অনুমতি ছাড়া নাও পাওয়া যেতে পারে)"
echo ""

echo "##################################################"
echo "# তথ্য সংগ্রহ সম্পন্ন।"
echo "##################################################"
