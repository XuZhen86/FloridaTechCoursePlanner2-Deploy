#!/bin/bash

# Set log file name
LOG_FILE='/mnt/build/dist/FloridaTechCoursePlanner2/build.log'

# Make a copy of original code
cp -r web-client/* build

# Install packages
cd build
npm install | tee -a $LOG_FILE

# Compile
node_modules/@angular/cli/bin/ng build --prod --base-href '.' | tee -a $LOG_FILE
