#!/bin/sh

# env exports
export NEXTCLOUD_URL="${NEXTCLOUD_URL:-$OVERWRITECLIURL}"
export REDIS_URL="redis+unix://${REDIS_HOST}"
export DATABASE_URL="mysql://${MARIADB_USER}:${MARIADB_PASSWORD}@localhost/${MARIADB_DATABASE}?socket=${MARIADB_HOST}"
export DATABASE_PREFIX="oc_"

# Clean shutdown handler
cleanup() {
	echo "[*] Stopping notify_push..."
	kill -TERM "$NOTIFY_PID" 2>/dev/null && echo "[✓] notify push stopped.." || echo "Unable to Kill Notify Push.."
	echo "[✓] Bye..."
}
trap 'cleanup' TERM INT

echo "[*] Checking Nextcloud Host Presence..."
while ! curl -s --fail --max-time 15 "$NEXTCLOUD_URL/status.php" >/dev/null; do
	echo "[*] Waiting for Nextcloud to start..."
	sleep 5
done

echo "[✓] Nextcloud Host is UP and Serving."
echo "[*] Ensuring notify_push app is installed and enabled..."
php occ app:install notify_push || true
php occ app:enable notify_push || true

echo "[*] Starting notify_push binary..."
/var/www/html/custom_apps/notify_push/bin/x86_64/notify_push &
NOTIFY_PID=$!

# Posix compliance check to ensure notify_push is running
if kill -0 "$PID" 2>/dev/null; then
	echo "[✓] Notify Push is UP and running."
else
	echo "[X] Notify Push is not Running!! Exiting.."
	exit 1
fi

# Wait for the socket to active and respond, max 30 seconds
i=1
while [ $i -le 6 ]; do
	if [ -S "$SOCKET_PATH" ]; then
		echo "[*] Socket file exists, testing HTTP response..."
		if curl -s --max-time 5 --unix-socket "$SOCKET_PATH" http://localhost/ -o /dev/null; then
			echo "[*] Running occ notify_push:setup"
			php occ notify_push:setup "${NEXTCLOUD_URL}/push" || true
			break
		else
			echo "[!] Socket exists, but no HTTP response yet"
		fi
	fi

	echo "[*] Waiting 5 seconds for notify_push to be ready... (try $i/6)"
	sleep 5
	: $((i += 1))
done

# Keep container alive while notify_push runs
wait
