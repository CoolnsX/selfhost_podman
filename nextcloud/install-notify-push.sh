#!/bin/sh

echo "[*] Ensuring notify_push app is installed and enabled..."
php occ app:install notify_push || true
php occ app:enable notify_push || true
