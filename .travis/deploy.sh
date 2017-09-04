#!/bin/bash

# Don't run on pull requests
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
	echo "Pull request detected, skipping push to Docker Hub.."
	exit 0
fi

# Don't run on non-master branches
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
	echo "Non-master branch detected, skipping push to Docker Hub.."
	exit 0
fi

# Catch errors
set -e
set -o pipefail

# Switch to root
cd "${0%/*}"/../

# Setup environment
export REALM_VERSION=$(.travis/version.sh)

# Run environment validation
.travis/validate.sh

# Get the production build image
BUILDID=`docker history didstopia/realm-object-server:$REALM_VERSION-test | grep "LABEL TEST=FALSE" | awk '{print $1}'`

# Validate the build id
REGEX='^[a-zA-Z0-9]+$'
if [[ -z "${BUILDID}" || ! $BUILDID =~ $REGEX ]]; then
	echo "Build id validation failed for $BUILDID, bailing out.."
	exit 1
fi

# Create and push a new git tag for the current version
if .travis/tag.sh | grep -q 'already exists'; then
	echo "Tag already exists, skipping push to Docker Hub.."
	exit 0
fi

# Push the new version to Docker Hub
docker tag $BUILDID didstopia/realm-object-server:$REALM_VERSION
docker push didstopia/realm-object-server:$REALM_VERSION

# Push the latest version to Docker Hub
docker tag $BUILDID didstopia/realm-object-server:latest
docker push didstopia/realm-object-server:latest

# Remove the test image
docker rmi didstopia/realm-object-server:$REALM_VERSION-test
