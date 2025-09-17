#!/bin/sh

NC_PATH="/var/www/html"
CONFIG="$NC_PATH/config/config.php"
NOTIFY_BIN="$NC_PATH/apps/notify_push/bin/x86_64/notify_push"
SOCKET_PATH="${SOCKET_PATH:-/tmp/docker/notify_push.sock}"

# Clean shutdown handler
cleanup() {
	echo "[*] Stopping notify_push..."
	kill -TERM "$NOTIFY_PID" 2>/dev/null && echo "[*] notify push stopped.." || echo "Unable to Kill Notify Push.."
	echo "[*] Bye"
}
trap 'cleanup' TERM INT

echo "[*] Ensuring notify_push app is installed and enabled..."
php occ app:install notify_push || true
php occ app:enable notify_push || true

echo "[*] Starting notify_push binary..."
"$NOTIFY_BIN" "$CONFIG" &
NOTIFY_PID=$!

# Wait for the socket to appear, max 30 seconds
i=0
while [ $i -lt 6 ]; do
	echo "[*] Waiting 5 seconds for notify_push to be ready... (try $i/6)"
	sleep 5
	if [ -S "$SOCKET_PATH" ]; then
		echo "[*] Socket found, running occ notify_push:setup"
		php occ notify_push:setup "${NEXTCLOUD_URL}/push" || true
		break
	fi
	: $((i += 1))
done

# Keep container alive while notify_push runs
wait
