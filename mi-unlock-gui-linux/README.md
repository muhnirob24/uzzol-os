# Mi Unlock GUI for Ubuntu

এটি একটি সহজ Python Flask ওয়েব অ্যাপ যা Android ADB এর মাধ্যমে Mi ফোনের বুটলোডার/EDL মোডে রিবুট এবং আনলক রিকোয়েস্ট সহজেই পাঠানোর জন্য তৈরি।

## প্রয়োজনীয়তা

- Ubuntu বা Linux সিস্টেম
- ADB ইনস্টল করা (sudo apt install adb)
- Python3 এবং pip3
- Flask (pip3 install -r requirements.txt)

## ফোল্ডার কাঠামো

- scripts/ : ADB কমান্ডের Bash স্ক্রিপ্ট
- app/ : Flask অ্যাপ ও টেমপ্লেট
- requirements.txt : Python লাইব্রেরি তালিকা

## ব্যবহারের ধাপ

1. স্ক্রিপ্ট রান করুন যা সব তৈরি করে:
    ```bash
    chmod +x setup_mi_unlock_project.sh
    ./setup_mi_unlock_project.sh
    ```
2. তৈরি `.zip` আনজিপ করুন
3. প্রজেক্ট ফোল্ডারে ঢুকে স্ক্রিপ্ট এক্সিকিউটেবল কিনা দেখুন:
    ```bash
    chmod +x scripts/*.sh
    ```
4. প্রয়োজনীয় প্যাকেজ ইনস্টল করুন:
    ```bash
    sudo apt install adb python3 python3-pip
    pip3 install -r requirements.txt
    ```
5. Flask অ্যাপ চালান:
    ```bash
    cd app
    python3 app.py
    ```
6. ব্রাউজারে গিয়ে http://localhost:5050 এ যান
7. ডিভাইস ম্যানেজ করুন।

## নোট

- ফোনে USB ডিবাগিং চালু থাকতে হবে
- Mi Account দিয়ে ম্যানুয়ালি আনলক সম্পন্ন করতে হবে ফোন থেকে
