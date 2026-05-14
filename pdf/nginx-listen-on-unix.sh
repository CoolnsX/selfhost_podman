#!/bin/sh

set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

SOCKET="${NGINX_SOCKET:-/tmp/nginx.sock}"

entrypoint_log "[coolans] Changing Nginx listen port to $SOCKET"
sed -i -e "s|listen 8080;|listen unix:${SOCKET};|" -e "/listen \[::\]:8080;/d" /etc/nginx/nginx.conf
