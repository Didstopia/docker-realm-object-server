#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Fix the working directory
cd "${0%/*}"/../

# Create and push a new tag for the current version
if ./scripts/tag.sh | grep -q 'already exists'; then
	echo "Tag already exists, skipping push to Docker Hub.."
	exit 0
fi

# Push the new version for Docker Hub
./scripts/docker_push.sh
