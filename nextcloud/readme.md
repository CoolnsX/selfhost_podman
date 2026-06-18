# Nextcloud

The nextcloud image is from official nextcloud docker image.

You Need to have Separate Web Server, as this image is based on PHP-FPM.

## Note
I have moved the postgres and valkey on host, to have unified Database engine for all the apps and to ease backup of Databases.

So, I have moved the nextcloud_db.container and nextcloud_valkey.container to .bak files, to not picked up by systemd.

## Major Problem
All Resolved :)
