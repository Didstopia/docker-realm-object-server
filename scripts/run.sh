#!/bin/bash

# Catch errors
set -e

# Run base image initialization
bash /entrypoint.sh true

# Function for waiting for backups to complete
function waitForBackups()
{
	# Wait for the backup to complete
	timeout 5s bash -c 'while [ -f "/var/run/realm-backup.lock" ]; do sleep 1; done'
}

# Define the exit handler
exit_handler()
{
	echo "Shutdown signal received, shutting down.."

	waitForBackups

	# Sent CTRL-C to Realm Object Server
	kill -SIGINT "$child"
}

# Trap specific signals and forward to the exit handler
trap 'exit_handler' SIGHUP SIGINT SIGTERM

# Copy the default configuration in place if none exists
# NOTE: Also disables logging to file, which removes log file paths,
#       which in turn forces logging to stdout instead
if [ ! -f "$REALM_CONFIGURATION_FILE" ]; then
	echo "Config missing, applying defaults.."
	sed -r 's/(path: )(.*)(\.log)(.*)/path: ""/g' $REALM_DEFAULT_CONFIGURATION_FILE > $REALM_CONFIGURATION_FILE
fi

# Generate SSL keys if none exist
if [ ! -f "$REALM_PUBLIC_KEY_FILE" ] || [ ! -f "$REALM_PRIVATE_KEY_FILE" ]; then
	echo "Public or private key missing, generating new keys.."
	rm -f "$REALM_PUBLIC_KEY_FILE"
	rm -f "$REALM_PRIVATE_KEY_FILE"
	openssl genrsa -out "$REALM_PRIVATE_KEY_FILE" 2048
	openssl rsa -in "$REALM_PRIVATE_KEY_FILE" -outform PEM -pubout -out "$REALM_PUBLIC_KEY_FILE"
fi

# Start cron (enables scheduled tasks)
if [[ "${ENABLE_BACKUPS,,}" == "true" ]]; then
    cron
fi

# Start the server if it installed correctly
if [ -f "$REALM_BINARY_FILE" ]; then
	echo "Starting Realm Object Server.."
	"$REALM_BINARY_FILE" -c "$REALM_CONFIGURATION_FILE" 2>&1 &
	child=$!
	wait "$child"
	waitForBackups
	exit $?
else
	echo "Could not find Realm Object Server binary at $REALM_BINARY_FILE"
	echo "Please contact the maintainer of this image, as this isn't supposed to happen!"
	echo ""
	waitForBackups
	exit 1
fi
