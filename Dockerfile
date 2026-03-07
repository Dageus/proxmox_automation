FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    sshpass \
    openssh-client \
    curl \
    unzip \
    git \
    binutils \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install terraform

# Install Ansible and Proxmox Collections
RUN pip install --no-cache-dir ansible proxmoxer requests && \
    ansible-galaxy collection install community.general community.proxmox ansible.posix

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

COPY .ssh/ansible /root/.ssh/ansible
COPY .ssh/ansible.pub /root/.ssh/ansible.pub

RUN chmod 600 /root/.ssh/ansible && \
    chmod 644 /root/.ssh/ansible.pub

WORKDIR /infrastructure
ENTRYPOINT ["/bin/bash"]
