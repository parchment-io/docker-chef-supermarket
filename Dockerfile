
FROM ubuntu:18.04

MAINTAINER Parchment Chef <chef@parchment.com>

# Install wget and other packages
RUN set -x \
    && apt-get update \
    && apt-get install -y wget ca-certificates apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# ARGs and ENVs for Chef Supermarket installation
ARG CHEF_SUPERMARKET_VERSION=3.1.70
ARG CHEF_SUPERMARKET_DOWNLOAD_SHA256=b448e316dcc5a4c22230532d705ccceb859df87f9bc940a1a80b1cc80171cb70
ENV CHEF_SUPERMARKET_VERSION ${CHEF_SUPERMARKET_VERSION}
ENV CHEF_SUPERMARKET_DOWNLOAD_URL https://packages.chef.io/files/stable/supermarket/${CHEF_SUPERMARKET_VERSION}/ubuntu/18.04/supermarket_${CHEF_SUPERMARKET_VERSION}-1_amd64.deb
ENV CHEF_SUPERMARKET_DOWNLOAD_SHA256 ${CHEF_SUPERMARKET_DOWNLOAD_SHA256}

# Download and install the Chef-Supermarket package
RUN set -x \
    && wget --no-check-certificate -O supermarket_"$CHEF_SUPERMARKET_VERSION"-1_amd64.deb "$CHEF_SUPERMARKET_DOWNLOAD_URL" \
    && echo "$CHEF_SUPERMARKET_DOWNLOAD_SHA256 supermarket_$CHEF_SUPERMARKET_VERSION-1_amd64.deb" | sha256sum -c - \
    && dpkg -i supermarket_"$CHEF_SUPERMARKET_VERSION"-1_amd64.deb \
    && rm supermarket_"$CHEF_SUPERMARKET_VERSION"-1_amd64.deb

# Volumes
VOLUME ["/etc/supermarket", "/var/opt/supermarket"]

# Copy Entrypoint file
COPY scripts/* /

# Set Entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Expose ports
EXPOSE 80 443

# Set WORKDIR
WORKDIR /opt/supermarket/
