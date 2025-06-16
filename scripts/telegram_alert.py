#!/usr/bin/env python3
import requests
import sys

BOT_TOKEN = "YOUR_TELEGRAM_BOT_TOKEN"
CHAT_ID = "YOUR_TELEGRAM_CHAT_ID"

def send_telegram_message(message):
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    payload = {"chat_id": CHAT_ID, "text": message}
    requests.post(url, data=payload)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        send_telegram_message(sys.argv[1])
