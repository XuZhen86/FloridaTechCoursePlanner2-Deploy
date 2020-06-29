#!/bin/bash

# Stop operation
./stop.sh

# Create volumes
docker volume create cp2-code
docker volume create cp2-data

# Build client code
docker run \
    --init \
    --memory 1536M \
    --mount type=bind,src="$PWD/../web-client",dst='/mnt/web-client',ro \
    --mount type=bind,src="$PWD/build.sh",dst='/mnt/build.sh',ro \
    --mount type=bind,src='/etc/timezone',dst='/etc/timezone',ro \
    --mount type=volume,src=cp2-code,dst='/mnt/build/dist/FloridaTechCoursePlanner2' \
    --mount type=volume,src=cp2-data,dst='/mnt/build/dist/FloridaTechCoursePlanner2/assets/data' \
    --name cp2-build \
    --pids-limit 64 \
    -w '/mnt' \
    node:lts-stretch-slim \
    bash '/mnt/build.sh'

# Build scrapy image
docker build --pull --tag scrapy scrapy

# Start data spider
docker run \
    --cpus 1 \
    --detach \
    --init \
    --memory 128M \
    --mount type=bind,src="$PWD/../data-spider",dst='/mnt/data-spider-ro',ro \
    --mount type=bind,src="$PWD/data-spider.sh",dst='/mnt/data-spider.sh',ro \
    --mount type=bind,src='/etc/timezone',dst='/etc/timezone',ro \
    --mount type=tmpfs,dst='/mnt/data-spider',tmpfs-size=67108864 \
    --mount type=volume,src=cp2-data,dst='/mnt/data-spider/dist' \
    --name cp2-data-spider \
    --pids-limit 32 \
    -w '/mnt' \
    scrapy \
    bash '/mnt/data-spider.sh'

# Start web server
docker run \
    --cpus 0.1 \
    --detach \
    --init \
    --memory 8M \
    --mount type=bind,src="$PWD/httpd/httpd.conf",dst='/etc/httpd.conf',ro \
    --mount type=bind,src="$PWD/httpd/httpd.sh",dst='/mnt/httpd.sh',ro \
    --mount type=bind,src='/etc/timezone',dst='/etc/timezone',ro \
    --mount type=volume,src=cp2-code,dst='/mnt/www',ro \
    --mount type=volume,src=cp2-data,dst='/mnt/www/assets/data',ro \
    --name cp2-web-server \
    --pids-limit 8 \
    --publish 80:80/tcp \
    -w '/mnt/www' \
    busybox \
    sh '/mnt/httpd.sh'
