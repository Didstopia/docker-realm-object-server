#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# Optionally load environment variables from a file
if [ ! -f ".env" ]; then source .env; fi

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

# Check if we're overriding the env var
if [[ -z "${REALM_VERSION}" ]]; then
	# Get the latest version
	REALM_VERSION=`./scripts/version.sh`

	# Validate the version using regex
	# Validate the version using regex
	REGEX='^[0-9]+\.[0-9]+'
	if [[ ! $REALM_VERSION =~ $REGEX ]]; then
		echo "Version validation failed for $REALM_VERSION. Did semver change or is the API down?"
		exit 1
	fi
fi

# Create and push a new tag matching the new version
if git tag --message="Realm Object Server $REALM_VERSION" -a v$REALM_VERSION; then
	if git push --dry-run origin $REALM_VERSION; then
		echo "Successfully tagged version $REALM_VERSION"
		exit 0
	else
		echo "Failed to push a tag for version $REALM_VERSION. Is GitHub down?"
		exit 1
	fi
else
	echo "Failed to create a tag for version $REALM_VERSION. Does it already exist?"
	exit 1
fi

exit 0
