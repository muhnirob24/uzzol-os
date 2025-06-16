#!/usr/bin/env python3
import platform
import socket

def get_device_fingerprint():
    info = {
        "hostname": socket.gethostname(),
        "platform": platform.system(),
        "platform_version": platform.version(),
        "processor": platform.processor()
    }
    return info

if __name__ == "__main__":
    fingerprint = get_device_fingerprint()
    for k,v in fingerprint.items():
        print(f"{k}: {v}")
