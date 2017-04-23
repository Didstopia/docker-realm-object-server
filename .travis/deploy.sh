#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# Create and push a new tag for the current version
bash scripts/tag.sh

# Push the new version for Docker Cloud
bash scripts/docker_push.sh
