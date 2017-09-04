#!/bin/bash

# Catch errors
set -e
set -o pipefail

echo "WARNING: Backups not implemented"

# realm-backup SOURCE TARGET
# SOURCE is the data directory of the Realm Object Server (typically configured in /etc/realm/configuration.yml under storage.root_path).
# TARGET is the directory where the backup files will be placed. This directory must be empty or absent when the backup starts for safety reasons.
# After the backup command completes, TARGET will be a directory with the same sub directory structure as SOURCE and a backup of all individual Realms.

exit 0
