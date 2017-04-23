#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ ! -f ".env" ]; then source .env; fi

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

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

## TODO: Push a new release to GitHub

echo "WARNING: Automatic release build generation not yet implemented."
exit 0
