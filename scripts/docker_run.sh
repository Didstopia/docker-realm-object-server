#!/bin/bash

# Catch errors
set -e

./docker_build.sh

# Fix the working directory
cd "${0%/*}"/../

## TODO: Use ROS version as the tag instead of latest

docker run -p 9080:9080 -p 9443:9443 --name realm-object-server -v $(pwd)/DATA/var/lib/realm/object-server:/var/lib/realm/object-server -v $(pwd)/DATA/etc/realm:/etc/realm -it --rm didstopia/realm-object-server:latest
