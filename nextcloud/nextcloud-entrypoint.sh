#!/bin/sh

####################
# My Special Sauce #
####################

#################################################################
# This script is to make the www-data in /entrypoint.sh to	#
# any user specified by $UID, so that your nextcloud can run	#
# properly.							#
#################################################################

set -eu

# default to UID=1000 if not set
TARGET_UID="${UID:-1000}"

# replace "www-data" with numeric UID/GID
sed -i "s/www-data/${TARGET_UID}/g" /entrypoint.sh

# execute the patched entrypoint with all args
exec /entrypoint.sh php-fpm
