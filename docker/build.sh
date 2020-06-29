#!/bin/bash

# Make a copy of original code
cp -r web-client/* build

# Install packages
cd build
npm install

# Compile
node_modules/@angular/cli/bin/ng build --prod
