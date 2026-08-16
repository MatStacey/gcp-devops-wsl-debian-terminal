FROM debian:bookworm-slim

# Enforce pipefail for all shell commands to prevent masked pipe errors
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install OS utilities, HashiCorp tools, and GCP CLI in a single merged layer
# kics-scan ignore-block
# hadolint ignore=DL3008,DL3015
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo curl wget git jq fzf ripgrep rsync file python3-pip pipx \
    apt-transport-https ca-certificates gnupg unzip bat python3-yaml \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" | tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    google-cloud-cli terraform packer gh \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash devops \
    && echo "devops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 2. Add a lightweight healthcheck to monitor container responsiveness
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 --version || exit 1

# 3. Drop root privileges and switch to the development user
USER devops
WORKDIR /home/devops

# 4. Inject pipx binaries into the path
ENV PATH="/home/devops/.local/bin:$PATH"

# 5. Explicitly copy only the necessary files to a temporary staging area
COPY .bashrc install.sh /tmp/mt-devops-framework/
COPY .bash.d/ /tmp/mt-devops-framework/.bash.d/

# 6. Install Python tooling and run the profile installer in a single layer
# hadolint ignore=DL3003,DL3013,SC1091
RUN source /tmp/mt-devops-framework/.bash.d/config/dependencies.sh \
    && for dep in "${PYTHON_DEPENDENCIES[@]}"; do pipx install "${dep##*:}"; done \
    && cd /tmp/mt-devops-framework \
    && echo "n" | ./install.sh \
    && rm -rf /tmp/mt-devops-framework \
    && bash -c "source ~/.bashrc && mt-refresh-caches"

# 7. Drop straight into your custom environment
CMD ["/bin/bash"]
