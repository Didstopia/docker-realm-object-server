# Base image
FROM didstopia/base:nodejs-ubuntu-16.04

# Maintainer information
MAINTAINER Didstopia <support@didstopia.com>

# Build time environment variables
ARG DEBIAN_FRONTEND=noninteractive
ARG REALM_VERSION=alpha
ARG USER=root
ARG HOME="/tmp"

 ## TODO: Fix the configuration env vars
# Exposed environment variables
ENV REALM_BINARY_FILE "/npm/bin/ros"
ENV REALM_CONFIGURATION_FILE "/etc/realm/configuration.yml"
ENV REALM_DEFAULT_CONFIGURATION_FILE "/configuration.sample.yml"
ENV REALM_PUBLIC_KEY_FILE "/app/data/auth.pub"
ENV REALM_PRIVATE_KEY_FILE "/app/data/auth.key"
ENV REALM_VERSION $REALM_VERSION
ENV REALM_NPM_MODULES ""
ENV ENABLE_BACKUPS "false"
ENV NPM_WORKDIR "/npm"
ENV PGID 1000
ENV PUID 1000

# Install apt-utils to fix additional apt-get warnings
RUN apt-get update && apt-get install -y apt-utils

# Install dependencies
RUN apt-get update && apt-get install -y \
	cron

# Cleanup
RUN apt-get clean && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*

# To avoid `npm install -g` issues, it's recommended to set these env var and provide a location to store the global packages
ENV NPM_CONFIG_PREFIX "$NPM_WORKDIR"
ENV NPM_PACKAGES "$NPM_WORKDIR"
ENV PATH="$NPM_PACKAGES/bin:$PATH"
RUN mkdir -p "$NPM_WORKDIR"
RUN chown -R $PUID:$PGID "$NPM_WORKDIR"

# Install Realm Object Server
#RUN su-exec docker npm install realm-object-server@$REALM_VERSION -g
RUN npm install realm-object-server@$REALM_VERSION -g

## TODO: Fix
# Prepare the latest configuration for use as a default config
#RUN cp -f $REALM_CONFIGURATION_FILE $REALM_DEFAULT_CONFIGURATION_FILE

# Copy scripts
ADD scripts/run.sh /run.sh
ADD scripts/backup.sh /backup.sh
RUN chmod +x /*.sh

# Setup scheduled tasks
ADD backup.cron /etc/cron.d/realm-backup
RUN ln -sf /proc/1/fd/1 /var/log/cron.log

# Expose supported volumes
VOLUME /app

# Expose both the HTTP and HTTPS proxy ports
# NOTE: The HTTPS proxy is disabled by default
EXPOSE 9080
EXPOSE 9443

# Set the startup script
# NOTE: It's important to wrap the cmd/entrypoint in ["/command", "arg1", "arg2"],
#       as that will correctly pass signals from Docker to the cmd/entrypoint
ENTRYPOINT ["/run.sh"]

# Mark this as a production build
LABEL TEST="FALSE"

#--- TESTS BEGIN --- #

# Copy scripts
ADD scripts/run_tests.sh /run_tests.sh

# Set the startup script
ENTRYPOINT ["/run_tests.sh"]

# Mark this as a test build
LABEL TEST="TRUE"

#---  TESTS END  --- #
