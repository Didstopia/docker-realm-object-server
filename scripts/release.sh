#!/bin/bash

# Catch errors
set -e

# Fix the working directory
cd "${0%/*}"/../

# NOTE: Remember to use the following when output could
#       potentially include env vars: > /dev/null 2>&1

## TODO: Push a new release to GitHub

echo "WARNING: Automatic release build generation not yet implemented."
exit 0
