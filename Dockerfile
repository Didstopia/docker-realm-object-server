FROM ubuntu:16.04
MAINTAINER Didstopia <support@didstopia.com>

# Expose environment variables
ENV REALM_REPOSITORY "https://packagecloud.io/install/repositories/realm/realm/script.deb.sh"
ENV REALM_BINARY_FILE "/usr/bin/realm-object-server"
ENV REALM_CONFIGURATION_FILE "/etc/realm/configuration.yml"
ENV REALM_DEFAULT_CONFIGURATION_FILE "/configuration.sample.yml"
ENV REALM_PUBLIC_KEY_FILE "/etc/realm/token-signature.pub"
ENV REALM_PRIVATE_KEY_FILE "/etc/realm/token-signature.key"

# Fix apt-get warnings at build time
ARG DEBIAN_FRONTEND=noninteractive

# Install apt-utils to fix additional apt-get warnings
RUN apt-get update && apt-get install -y apt-utils

# Install dependencies
RUN apt-get update && apt-get install -y \
	curl \
	openssh-client

# Add the Realm repository
RUN ["/bin/bash", "-c", "set -e -o pipefail && curl -s $REALM_REPOSITORY | bash"]

# Install system updates
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get dist-upgrade -y && \
	apt-get autoremove -y

## TODO: Use a proper version from our API query for installation!
##       Note that we need to hide our API key from the repo while doing this.
# Install Realm Object Server
RUN apt-get update && apt-get install -y \
	realm-object-server-developer=1.4.1-305

# Prepare the latest configuration for use as a default config
RUN cp -fr $REALM_CONFIGURATION_FILE $REALM_DEFAULT_CONFIGURATION_FILE

# Copy scripts
ADD run.sh /run.sh

# Expose supported volumes
VOLUME /var/lib/realm/object-server
VOLUME /etc/realm

# Expose both the HTTP and HTTPS proxy ports
# NOTE: The HTTPS proxy is disabled by default
EXPOSE 9080
EXPOSE 9443

# Setup the startup script
ENTRYPOINT /run.sh
