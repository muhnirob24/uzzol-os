#!/bin/bash

PROJECT_NAME="mi-unlock-gui-linux"

echo ">> প্রজেক্ট ফোল্ডার তৈরি: $PROJECT_NAME"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME || { echo "Error: Couldn't enter folder"; exit 1; }

echo ">> ফোল্ডার স্ট্রাকচার তৈরি..."
mkdir -p scripts app/templates app/static

echo ">> Bash স্ক্রিপ্ট তৈরি..."

cat > scripts/check_device.sh << 'EOF'
#!/bin/bash
adb devices | grep -v "List" | grep "device"
EOF

cat > scripts/reboot_modes.sh << 'EOF'
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
EOF

cat > scripts/unlock_request.sh << 'EOF'
#!/bin/bash
echo "ADB এর মাধ্যমে ফোন বুটলোডারে রিবুট করা হচ্ছে..."
adb reboot bootloader
echo "⚠️ ম্যানুয়ালি Mi Account লগইন করে আনলক করুন।"
EOF

chmod +x scripts/*.sh

echo ">> Flask অ্যাপ তৈরি..."

cat > app/app.py << 'EOF'
from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/check-device')
def check_device():
    output = os.popen("bash ../scripts/check_device.sh").read()
    return f"<pre>{output}</pre>"

@app.route('/bootloader')
def bootloader():
    os.system("adb reboot bootloader")
    return "Bootloader মোডে রিবুট করা হচ্ছে..."

@app.route('/edl')
def edl():
    os.system("adb reboot edl")
    return "EDL মোডে রিবুট করা হচ্ছে..."

@app.route('/unlock-request')
def unlock():
    os.system("bash ../scripts/unlock_request.sh")
    return "Unlock রিকোয়েস্ট পাঠানো হয়েছে, ফোন চেক করুন।"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
EOF

echo ">> HTML টেমপ্লেট তৈরি..."

cat > app/templates/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Mi Unlock GUI (Ubuntu)</title>
    <style>
        body { font-family: Arial, sans-serif; background:#fafafa; padding:30px; }
        h1 { color: #333; }
        button {
            padding: 12px 25px;
            margin: 10px 0;
            font-size: 18px;
            cursor: pointer;
            border: none;
            border-radius: 6px;
            background-color: #0078d7;
            color: white;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #005ea3;
        }
        pre {
            background: #eee;
            padding: 15px;
            border-radius: 6px;
            max-height: 300px;
            overflow-y: auto;
        }
    </style>
</head>
<body>
    <h1>🔓 Mi Unlock GUI (Ubuntu)</h1>
    <button onclick="location.href='/check-device'">ডিভাইস চেক করুন</button><br>
    <button onclick="location.href='/bootloader'">বুটলোডার মোডে রিবুট</button><br>
    <button onclick="location.href='/edl'">EDL মোডে রিবুট</button><br>
    <button onclick="location.href='/unlock-request'">আনলক রিকোয়েস্ট পাঠান</button>
</body>
</html>
EOF

echo ">> Python প্যাকেজ তালিকা তৈরি..."

cat > requirements.txt << EOF
Flask
EOF

echo ">> README.md তৈরি..."

cat > README.md << 'EOF'
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
EOF

cd ..
echo ">> পুরো প্রজেক্টকে ZIP করা হচ্ছে..."
zip -r ${PROJECT_NAME}.zip $PROJECT_NAME

echo -e "\n🎉 কাজ শেষ! ${PROJECT_NAME}.zip তৈরি হয়েছে।\n"

echo "================== ব্যবহার নির্দেশিকা =================="
echo "1. ZIP আনজিপ করুন।"
echo "2. প্রজেক্ট ফোল্ডারে প্রবেশ করুন।"
echo "3. স্ক্রিপ্ট এক্সিকিউটেবল করুন: chmod +x scripts/*.sh"
echo "4. প্রয়োজনীয় প্যাকেজ ইনস্টল করুন:"
echo "   sudo apt install adb python3 python3-pip"
echo "   pip3 install -r requirements.txt"
echo "5. Flask অ্যাপ চালান:"
echo "   cd app"
echo "   python3 app.py"
echo "6. ব্রাউজারে গিয়ে http://localhost:5050 এ যান"
echo "========================================================"
