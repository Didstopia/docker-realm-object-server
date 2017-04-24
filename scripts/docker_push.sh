#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Fix the working directory
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ -f ".env" ]; then source .env; fi

# Check if we're overriding the env var
if [[ -z "${REALM_VERSION}" ]]; then
	# Get the latest version
	REALM_VERSION=`./scripts/version.sh`
fi

docker tag didstopia/realm-object-server:$REALM_VERSION didstopia/realm-object-server:$REALM_VERSION
docker push didstopia/realm-object-server:$REALM_VERSION
