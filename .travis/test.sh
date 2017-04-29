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

# Run the container in test mode
docker run -it --rm didstopia/realm-object-server:$REALM_VERSION-test
