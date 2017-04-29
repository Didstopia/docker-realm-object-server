#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Switch to root
cd "${0%/*}"/../

# Setup environment
export REALM_VERSION=$(.travis/version.sh)

# Run environment validation
.travis/validate.sh

# Create and push a new tag matching the new version
GIT_TAG_CMD_OUTPUT="$(git tag --message="Realm Object Server $REALM_VERSION (Developer Edition)" --message="NOTE: This is an automated build." -a $REALM_VERSION 2>&1 || true)"
if [[ "$GIT_TAG_CMD_OUTPUT" =~ "already exists" ]]; then
	echo "Tag $REALM_VERSION already exists, skipping.."
	exit 0
elif [ -z "$GIT_TAG_CMD_OUTPUT" ]; then
	echo "Tagged version $REALM_VERSION, pushing.."
	GIT_TAG_PUSH_CMD_OUTPUT=$(git push origin $REALM_VERSION 2>&1 || true)
	if [[ "$GIT_TAG_PUSH_CMD_OUTPUT" =~ "[new tag]" ]]; then
		echo "Successfully pushed tag $REALM_VERSION"
		exit 0
	else
		echo "Failed to push tag $REALM_VERSION:"
		echo "$GIT_TAG_PUSH_CMD_OUTPUT"
		exit 1
	fi
else
	echo "Failed to create tag $REALM_VERSION:"
	echo "$GIT_TAG_CMD_OUTPUT"
	exit 1
fi
