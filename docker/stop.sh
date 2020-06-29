#!/bin/bash

# Stop containers
docker stop cp2-build
docker stop cp2-data-spider
docker stop cp2-web-server

# Remove containers
docker rm cp2-build
docker rm cp2-data-spider
docker rm cp2-web-server

# Remove volumes
docker volume rm cp2-code
docker volume rm cp2-data
