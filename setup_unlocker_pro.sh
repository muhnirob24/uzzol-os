#!/bin/bash

echo "Unlocker Pro Project Setup শুরু হচ্ছে..."

# প্রজেক্ট ফোল্ডার তৈরি
mkdir -p unlocker-pro/{scripts,templates,static/css}
cd unlocker-pro || { echo "Failed to enter unlocker-pro dir"; exit 1; }

# app.py ফাইল লেখা
cat > app.py << 'EOF'
from flask import Flask, render_template, request, jsonify
import subprocess

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/check_device', methods=['GET'])
def check_device():
    try:
        output = subprocess.check_output(['adb', 'devices']).decode()
        devices = [line for line in output.strip().split('\n')[1:] if line.strip()]
        if devices:
            return jsonify({'status': 'connected', 'devices': devices})
        else:
            return jsonify({'status': 'no_device'})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

@app.route('/unlock', methods=['POST'])
def unlock():
    try:
        result = subprocess.check_output(['bash', './scripts/mi_unlock.sh']).decode()
        return jsonify({'status': 'started', 'output': result})
    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
EOF

# mi_unlock.sh স্ক্রিপ্ট লেখা
cat > scripts/mi_unlock.sh << 'EOF'
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
EOF

# index.html লেখা
cat > templates/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Unlocker Pro - Mi Bootloader Unlock</title>
    <link rel="stylesheet" href="/static/css/style.css" />
</head>
<body>
    <h1>Unlocker Pro - Mi Bootloader Unlock Tool</h1>
    <button onclick="checkDevice()">Check Device Connection</button>
    <p id="deviceStatus"></p>
    <button onclick="startUnlock()">Start Unlock</button>
    <pre id="output"></pre>

<script>
async function checkDevice() {
    let res = await fetch('/check_device');
    let data = await res.json();
    if(data.status === 'connected'){
        document.getElementById('deviceStatus').innerText = 'Device connected: ' + data.devices.join(', ');
    } else if(data.status === 'no_device'){
        document.getElementById('deviceStatus').innerText = 'No device connected.';
    } else {
        document.getElementById('deviceStatus').innerText = 'Error: ' + data.message;
    }
}

async function startUnlock() {
    document.getElementById('output').innerText = 'Unlocking... Please wait.';
    let res = await fetch('/unlock', {method: 'POST'});
    let data = await res.json();
    if(data.status === 'started'){
        document.getElementById('output').innerText = data.output;
    } else {
        document.getElementById('output').innerText = 'Error: ' + data.message;
    }
}
</script>
</body>
</html>
EOF

# style.css লেখা
cat > static/css/style.css << 'EOF'
body {
    font-family: Arial, sans-serif;
    margin: 2rem;
    background: #f0f0f0;
}
h1 {
    color: #333;
}
button {
    padding: 10px 15px;
    margin: 5px;
    background: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
button:hover {
    background: #0056b3;
}
pre {
    background: #222;
    color: #eee;
    padding: 10px;
    border-radius: 5px;
    max-height: 300px;
    overflow-y: auto;
}
EOF

# requirements.txt লেখা
cat > requirements.txt << EOF
Flask==2.3.2
EOF

# executable পারমিশন দেওয়া
chmod +x scripts/mi_unlock.sh

echo "Setup complete!"
echo "Run the following commands to start your project:"
echo "  cd unlocker-pro"
echo "  pip install -r requirements.txt"
echo "  python app.py"
echo ""
echo "Open your browser at http://localhost:5001 to use the Unlocker Pro web interface."
