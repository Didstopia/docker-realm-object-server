#!/bin/bash

# Catch errors
set -e

./docker_build.sh

# Fix the working directory
cd "${0%/*}"/../

## TODO: Use ROS version as the tag instead of latest

docker tag didstopia/realm-object-server:latest didstopia/realm-object-server:latest
docker push didstopia/realm-object-server:latest
