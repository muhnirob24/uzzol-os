#!/bin/bash

# Author: MUH Nirob
# Email: uzzolhassan38@gmail.com
# Website: https://nirobtech.com/bdtech/
# Purpose: Generate 20 Bengali content Markdown posts with English URL slug inside ~/uzzol-os/bdtech for GitHub repo.

BASE_DIR=~/uzzol-os/bdtech
POSTS_DIR="$BASE_DIR/posts"

mkdir -p "$POSTS_DIR"

declare -a keywords=(
  "ওয়াইফাই হ্যাক কিভাবে রক্ষা পেতে হয়"
  "মোবাইল ভাইরাস চেক করার অ্যাপ"
  "ল্যাপটপ স্পিড বাড়ানোর সহজ উপায়"
  "ফেসবুক একাউন্ট সিকিউরিটি"
  "কম্পিউটার ভাইরাস ডিলিট করার উপায়"
  "আইওটি ডিভাইস সুরক্ষা"
  "হ্যাকিং থেকে রক্ষা পেতে টিপস"
  "মোবাইলে সাইবার আক্রমণ কিভাবে হয়"
  "ফিশিং অ্যাটাক কি এবং কিভাবে বাঁচবেন"
  "বিটকয়েন কি এবং কিভাবে কাজ করে"
  "পাসওয়ার্ড ম্যানেজার কি এবং ব্যবহার"
  "কিভাবে ফ্রি ওয়াইফাই ব্যবহার করবেন সুরক্ষিত"
  "ইউটিউব থেকে ভিডিও ডাউনলোড করার অ্যাপ"
  "মোবাইলে অ্যাপ ডাউনলোড নিরাপদ কিভাবে"
  "ওয়েবসাইট হ্যাক কিভাবে করা হয়"
  "পিসি ফাস্ট করার উপায়"
  "গুগল ড্রাইভ সিকিউরিটি টিপস"
  "ওয়াইফাই পাসওয়ার্ড চেঞ্জ কিভাবে"
  "সাইবার নিরাপত্তা কোর্স বাংলা"
  "ফেসবুক পেজ ম্যানেজমেন্ট টিপস"
)

# Bengali to simple ascii slug generator function
generate_slug() {
  local input="$1"
  local slug=$(echo "$input" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null | \
    tr '[:upper:]' '[:lower:]' | \
    sed -E 's/[^a-z0-9]+/-/g' | \
    sed -E 's/^-+|-+$//g')
  echo "$slug"
}

echo "# BD Tech Blog Posts List" > "$BASE_DIR/README.md"
echo "" >> "$BASE_DIR/README.md"
echo "এই রেপোজিটরিতে ২০টি বাংলা ব্লগ পোস্টের টেমপ্লেট আছে। পোস্টের URL ইংরেজিতে এবং কন্টেন্ট বাংলায়।" >> "$BASE_DIR/README.md"
echo "" >> "$BASE_DIR/README.md"
echo "## পোস্ট লিস্ট ও ডেমো URL" >> "$BASE_DIR/README.md"
echo "" >> "$BASE_DIR/README.md"

for keyword in "${keywords[@]}"
do
  slug=$(generate_slug "$keyword")
  filename="$POSTS_DIR/$slug.md"
  post_url="https://nirobtech.com/bdtech/$slug"

  cat > "$filename" <<EOF
---
title: "$keyword"
description: "$keyword নিয়ে বিস্তারিত তথ্য ও সমাধান।"
author: "MUH Nirob"
email: "uzzolhassan38@gmail.com"
website: "https://nirobtech.com/bdtech/"
date: $(date +%Y-%m-%d)
tags: [Bangla, Technology, Cybersecurity, "$keyword"]
slug: "$slug"
---

# $keyword

## পরিচিতি
এই পোস্টে আমরা বিস্তারিতভাবে আলোচনা করব "$keyword" বিষয়টি। এখানে সমস্যার কারণ, প্রতিরোধ এবং সহজ সমাধান জানানো হবে।

## কেন এটি গুরুত্বপূর্ণ?
বাংলাদেশের মতো উন্নয়নশীল দেশে "$keyword" সম্পর্কিত সচেতনতা খুব জরুরি, কারণ এটি আমাদের ডিজিটাল নিরাপত্তাকে সুরক্ষিত রাখতে সাহায্য করে।

## মূল বিষয়বস্তু

### সমস্যা ও ঝুঁকি
- এখানে "$keyword" নিয়ে সম্ভাব্য ঝুঁকিসমূহ এবং সমস্যাগুলো তুলে ধরা হবে।
- উদাহরণস্বরূপ, হ্যাকিং, ডাটা চুরি, ভাইরাস ইত্যাদি।

### কীভাবে সুরক্ষা পাবেন
- সহজ এবং কার্যকর পদ্ধতি সম্পর্কে আলোচনা করা হবে।
- সফটওয়্যার, সেটিংস, ও অ্যাপ্লিকেশন বেছে নেওয়ার টিপস।

### ব্যবহারিক টিপস ও ট্রিকস
- ধাপে ধাপে নির্দেশনা, অ্যাপ্লিকেশন বা টুলস রিকমেন্ডেশন।
- নিয়মিত আপডেট ও সাইবার নিরাপত্তার জন্য অভ্যাস।

## উপসংহার
"$keyword" বিষয়ে সচেতন থাকা আমাদের সকলের জন্য অপরিহার্য। নিয়মিত সতর্কতা এবং সঠিক ব্যবস্থাপনা দ্বারা আমরা ডিজিটাল আক্রমণ থেকে বাঁচতে পারি।

---

*এই পোস্টটি MUH Nirob কর্তৃক রচিত। আরও তথ্যের জন্য যোগাযোগ করুন:*  
- ইমেইল: uzzolhassan38@gmail.com  
- ওয়েবসাইট: [https://nirobtech.com/bdtech/](https://nirobtech.com/bdtech/)

EOF

  echo "- [$keyword]($post_url)" >> "$BASE_DIR/README.md"
  echo "Created: $filename"
done

echo ""
echo "======================================"
echo "  ২০টি পোস্ট ফাইল তৈরি হয়েছে: $POSTS_DIR"
echo "  README.md আপডেট হয়েছে: $BASE_DIR/README.md"
echo "======================================"
