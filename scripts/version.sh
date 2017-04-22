#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

PACKAGECLOUD_API_URL="https://packagecloud.io/api"
PACKAGECLOUD_API_ENDPOINT="/v1/repos/realm/realm/package/deb/ubuntu/xenial/realm-object-server-developer/amd64/versions.json"
JSON=`http -a $PACKAGECLOUD_API_TOKEN: $PACKAGECLOUD_API_URL$PACKAGECLOUD_API_ENDPOINT`
VERSION=`echo $JSON | jq --raw-output '.[-1].version'`
RELEASE=`echo $JSON | jq --raw-output '.[-1].release'`
echo -n $VERSION-$RELEASE
