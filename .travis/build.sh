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

# Build the Docker image (with tests)
docker build --build-arg REALM_VERSION=$REALM_VERSION -t didstopia/realm-object-server:$REALM_VERSION-test -t didstopia/realm-object-server:latest .
