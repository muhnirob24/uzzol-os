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
