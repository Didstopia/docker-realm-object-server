#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

## TODO: Query packagecloud.io API for the current version

## TODO: Should our Dockerfile also run this query, then pass the version to apt-get?

## TODO: Remove this, it's just a dummy for now
echo -n "1.4.1-305"
