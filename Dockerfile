# Use official Python base image
FROM python:3.11-slim

# Fix ENV format (modern syntax)
ENV ANSIBLE_VERSION=9.1.0 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    ca-certificates \
    ssh \
    sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Ansible
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir "ansible==${ANSIBLE_VERSION}" && \
    pip3 install --no-cache-dir ansible-core

# Create ansible user
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ansible

# Switch to ansible user
USER ansible
WORKDIR /home/ansible

# Verify installation
RUN ansible --version

CMD ["/bin/bash"]
