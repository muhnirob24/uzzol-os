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
