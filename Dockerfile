FROM didstopia/base:ubuntu-16.04
MAINTAINER Didstopia <support@didstopia.com>

# Build time environment variables
ARG DEBIAN_FRONTEND=noninteractive
ARG REALM_VERSION=*

# Exposed environment variables
ENV REALM_REPOSITORY "https://packagecloud.io/install/repositories/realm/realm/script.deb.sh"
ENV REALM_BINARY_FILE "/usr/bin/realm-object-server"
ENV REALM_CONFIGURATION_FILE "/etc/realm/configuration.yml"
ENV REALM_DEFAULT_CONFIGURATION_FILE "/configuration.sample.yml"
ENV REALM_PUBLIC_KEY_FILE "/etc/realm/token-signature.pub"
ENV REALM_PRIVATE_KEY_FILE "/etc/realm/token-signature.key"
ENV REALM_VERSION=$REALM_VERSION

# Install apt-utils to fix additional apt-get warnings
RUN apt-get update && apt-get install -y apt-utils

# Install dependencies
RUN apt-get update && apt-get install -y \
	locales \
	curl \
	httpie \
	jq \
	openssh-client

# Fix locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8 

# Add the Realm repository
RUN ["/bin/bash", "-c", "set -e -o pipefail && curl -s $REALM_REPOSITORY | bash"]

# Install system updates
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get dist-upgrade -y && \
	apt-get autoremove -y

# Install Realm Object Server
RUN apt-get update && apt-get install -y \
	realm-object-server-developer=$REALM_VERSION

# Cleanup
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Prepare the latest configuration for use as a default config
RUN cp -f $REALM_CONFIGURATION_FILE $REALM_DEFAULT_CONFIGURATION_FILE

# Copy scripts
ADD scripts/run.sh /run.sh
ADD scripts/backup.sh /backup.sh

# Expose supported volumes
VOLUME /var/lib/realm/object-server
VOLUME /etc/realm
VOLUME /usr/local/lib/realm/auth/providers

# Expose both the HTTP and HTTPS proxy ports
# NOTE: The HTTPS proxy is disabled by default
EXPOSE 9080
EXPOSE 9443

# Set the startup script
# NOTE: It's important to wrap the entrypoint/cmd in ["/command", "arg1", "arg2"],
#       as that will correctly pass signals from Docker to the entrypoint/cmd
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
