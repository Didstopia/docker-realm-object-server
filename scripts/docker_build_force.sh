#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

## TODO: Use ROS version as the tag instead of latest

docker build --no-cache -t didstopia/realm-object-server:latest .
