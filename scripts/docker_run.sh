#!/bin/bash

# Catch errors
set -e
set -o pipefail

./docker_build.sh

# Fix the working directory
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ -f ".env" ]; then source .env; fi

# Check if we're overriding the env var
if [[ -z "${REALM_VERSION}" ]]; then
	# Get the latest version
	REALM_VERSION=`./scripts/version.sh`

	# Validate the version using regex
	REGEX='^[0-9]+\.[0-9]+'
	if [[ ! $REALM_VERSION =~ $REGEX ]]; then
		echo "Version validation failed for $REALM_VERSION. Did semver change or is the API down?"
		exit 1
	fi
fi

docker run -p 9080:9080 -p 9443:9443 --name realm-object-server -v $(pwd)/DATA/var/lib/realm/object-server:/var/lib/realm/object-server -v $(pwd)/DATA/etc/realm:/etc/realm -it --rm didstopia/realm-object-server:$REALM_VERSION
