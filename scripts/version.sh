#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Fix the working directory
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ -f ".env" ]; then source .env; fi

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

if [[ -z "${PACKAGECLOUD_API_TOKEN}" ]]; then
	echo "API token not found for packagecloud.io"
	exit 1
fi

PACKAGECLOUD_API_URL="https://packagecloud.io/api"
PACKAGECLOUD_API_ENDPOINT="/v1/repos/realm/realm/package/deb/ubuntu/xenial/realm-object-server-developer/amd64/versions.json"
JSON=`http -a $PACKAGECLOUD_API_TOKEN: $PACKAGECLOUD_API_URL$PACKAGECLOUD_API_ENDPOINT`
VERSION=`echo $JSON | jq --raw-output '.[-1].version'`
RELEASE=`echo $JSON | jq --raw-output '.[-1].release'`
echo -n $VERSION-$RELEASE
