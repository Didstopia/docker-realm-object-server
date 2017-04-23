#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Fix the working directory
cd "${0%/*}"/../

# Create and push a new tag for the current version
./scripts/tag.sh

# Push the new version for Docker Cloud
./scripts/docker_push.sh
