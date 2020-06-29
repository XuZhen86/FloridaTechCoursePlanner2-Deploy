#!/bin/sh

# Delay httpd until data file shows up
while [ ! -f /mnt/www/assets/data/metaData.min.json ]; do
    sleep 5
done

# Start httpd in foreground
exec /bin/busybox httpd -fvv
