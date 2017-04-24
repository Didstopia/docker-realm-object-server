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

# Create and push a new tag matching the new version
REALM_VERSION_TAG="v$REALM_VERSION"
GIT_TAG_CMD_OUTPUT="$(git tag --message="Realm Object Server $REALM_VERSION" -a $REALM_VERSION_TAG 2>&1 || true)"
if [[ "$GIT_TAG_CMD_OUTPUT" =~ "already exists" ]]; then
	echo "Tag $REALM_VERSION_TAG already exists, skipping.."
	exit 0
elif [ -z "$GIT_TAG_CMD_OUTPUT" ]; then
	echo "Tagged version $REALM_VERSION as $REALM_VERSION_TAG, pushing.."
	GIT_TAG_PUSH_CMD_OUTPUT=$(git push origin $REALM_VERSION_TAG 2>&1 || true)
	if [[ "$GIT_TAG_PUSH_CMD_OUTPUT" =~ "[new tag]" ]]; then
		echo "Successfully pushed tag $REALM_VERSION_TAG"
		exit 0
	else
		echo "Failed to push tag $REALM_VERSION_TAG:"
		echo "$GIT_TAG_PUSH_CMD_OUTPUT"
		exit 1
	fi
else
	echo "Failed to create tag $REALM_VERSION_TAG:"
	echo "$GIT_TAG_CMD_OUTPUT"
	exit 1
fi
