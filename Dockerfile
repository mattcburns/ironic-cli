FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    python-openstackclient \
    python-ironicclient \
    python-keystoneclient

# Create a non-root user for security
RUN useradd -m -s /bin/bash ironic_user

USER ironic_user
WORKDIR /home/ironic_user

# Pre-create directory for OpenStack configs
RUN mkdir -p /home/ironic_user/.config/openstack

ENTRYPOINT ["/usr/local/bin/openstack"]
