#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

# Get the latest version
VERSION=`bash scripts/version.sh`

#Validate the version using regex
REGEX='^[0-9]+\.[0-9]+'
if [[ $VERSION =~ $REGEX ]]; then
	echo "Version $VERSION passes validation"
else
	echo "Version validation failed for $VERSION. Did semver change or is the API down?"
	exit 1
fi

# Create and push a new tag matching the new version
if git tag --message="Realm Object Server $VERSION" -a v$VERSION; then
	if git push --dry-run origin $VERSION; then
		echo "Successfully tagged version $VERSION"
		exit 0
	else
		echo "Failed to push a tag for version $VERSION. Is GitHub down?"
		exit 1
	fi
else
	echo "Failed to create a tag for version $VERSION. Does it already exist?"
	exit 1
fi

exit 0
