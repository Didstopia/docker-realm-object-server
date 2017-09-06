#!/bin/bash

# Catch errors
set -e
set -o pipefail

# Run base image initialization
bash /entrypoint.sh true

echo "WARNING: Tests not implemented"

## TODO: Test configuration
## TODO: Test Realm Object Server startup (check log for errors?)
## TODO: Test backup and restore
## TODO: Test environment variables/customization

exit 0
