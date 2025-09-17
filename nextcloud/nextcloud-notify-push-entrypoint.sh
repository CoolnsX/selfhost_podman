#!/bin/sh
set -e

NC_PATH="/var/www/html"
CONFIG="$NC_PATH/config/config.php"
NOTIFY_BIN="$NC_PATH/apps/notify_push/bin/x86_64/notify_push"
SOCKET_PATH="${SOCKET_PATH:-/tmp/docker/notify_push.sock}"

# Clean shutdown handler
cleanup() {
    echo "[*] Stopping notify_push..."
    kill -TERM "$NOTIFY_PID" 2>/dev/null || true
    wait "$NOTIFY_PID" 2>/dev/null || true
}
trap 'cleanup' TERM INT

echo "[*] Ensuring notify_push app is installed/updated..."
php occ app:install notify_push 2>/dev/null || true
php occ app:update notify_push 2>/dev/null || true

echo "[*] Starting notify_push binary..."
"$NOTIFY_BIN" "$CONFIG" &
NOTIFY_PID=$!

# Wait for the socket to appear, max 30 seconds
echo "[*] Waiting for notify_push to be ready..."
i=0
while [ $i -lt 30 ]; do
    if [ -S "$SOCKET_PATH" ]; then
        echo "[*] Socket found, running occ notify_push:setup"
        php occ notify_push:setup "${NEXTCLOUD_URL}/push" || true
        break
    fi
    i=$((i+1))
    sleep 1
done

# Keep container alive while notify_push runs
wait "$NOTIFY_PID"

