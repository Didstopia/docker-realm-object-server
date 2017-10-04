#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Switch to root
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ -f ".env" ]; then source .env; fi

# If we already have the version, return it instead
if [[ ! -z "${REALM_VERSION}" ]]; then
	echo -n $REALM_VERSION
	exit 0
fi

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

## TODO: Fix this by checking npm for the latest version instead

if [[ -z "${PACKAGECLOUD_API_TOKEN}" ]]; then
	echo "API token not found for packagecloud.io"
	exit 1
fi

PACKAGECLOUD_API_URL="https://packagecloud.io/api"
PACKAGECLOUD_API_ENDPOINT="/v1/repos/realm/realm/package/deb/ubuntu/xenial/realm-object-server-developer/amd64/versions.json"
JSON=`http -a $PACKAGECLOUD_API_TOKEN: $PACKAGECLOUD_API_URL$PACKAGECLOUD_API_ENDPOINT`
VERSION=`echo $JSON | jq --raw-output '.[-1].version'`
RELEASE=`echo $JSON | jq --raw-output '.[-1].release'`
REALM_VERSION=$VERSION-$RELEASE

# Validate ROS version and bail out if it's not valid
REGEX='^([0-9]+)((\.([0-9]+))+)?(\-)([0-9]+)((\.[0-9]+)+)?$'
if [[ ! $REALM_VERSION =~ $REGEX ]]; then
	echo "Version validation failed for $REALM_VERSION, bailing out.."
	exit 1
fi

echo -n $REALM_VERSION
