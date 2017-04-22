#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

## TODO: Use ROS version as the tag instead of latest

REALM_VERSION=`./scripts/version.sh`
docker build --build-arg REALM_VERSION=$REALM_VERSION -t didstopia/realm-object-server:latest .
