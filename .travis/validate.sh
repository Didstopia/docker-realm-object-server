#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Switch to root
cd "${0%/*}"/../

# If the version is not set, bail out
if [[ -z "${REALM_VERSION}" ]]; then
	echo "No version set for REALM_VERSION, bailing out.."
	exit 1
fi

# Validate ROS version and bail out if it's not valid
REGEX='^([0-9]+)((\.([0-9]+))+)?(\-)([0-9]+)((\.[0-9]+)+)?$'
if [[ ! $REALM_VERSION =~ $REGEX ]]; then
	echo "Version validation failed for $REALM_VERSION, bailing out.."
	exit 1
fi
