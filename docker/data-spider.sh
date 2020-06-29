#!/bin/bash

# Copy spider scripts from readonly folder to read-write folder
cp -r data-spider-ro/* data-spider

# Schedule spider to execute hourly
# Redirect to stdout and stderr of root process
CRONTAB="
PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 * * * * cd /mnt/data-spider && make --always-make 1>/proc/1/fd/1 2>/proc/1/fd/2
"
echo "$CRONTAB" | crontab

# Run crawler for the first time
cd data-spider
make --always-make

# Start Crontab in foreground
exec /usr/sbin/cron -f
