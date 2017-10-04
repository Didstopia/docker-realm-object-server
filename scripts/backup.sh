#!/bin/bash

# Catch errors
set -e
set -o pipefail

echo "Running backup script.."

# Create the lock file
touch "/var/run/realm-backup.lock"

## TODO: SOURCE should be read from the configuration file and not specified here statically

# Create a temporary directory for this backup
SOURCE="/app"
TARGET=$(mktemp -d -t realm-backup-XXXXXXXX)

# Run the backup command
## TODO: Can't find realm-backup anywhere (except in a node_modules dir)
realm-backup "${SOURCE}" "${TARGET}" >/dev/null

# Compress the backup
cd "${TARGET}"
tar -zcf "/app/backups/realm-$(date +"%Y-%m-%d_%H-%M-%S").tar.gz" *

# Cleanup
cd ../
rm -fr "${TARGET}"
rm -f "/var/run/realm-backup.lock"

## TODO: Old backups should be automatically removed once older than X days (customizable)

echo "Done backing up!"

exit 0
