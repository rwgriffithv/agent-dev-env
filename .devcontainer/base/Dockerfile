# Define the registry, defaults to local
ARG IMAGE_REGISTRY=local

# Define the base image path, which defaults to the registry + image name
ARG PROD_BASE_IMAGE=${IMAGE_REGISTRY}/web-deploy-base:latest

# Use the chained variable
FROM ${PROD_BASE_IMAGE}

ENV \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_FUND=false

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    sqlite3 \
    openssh-client \
    libglib2.0-0 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Create a dedicated development user if needed
RUN if ! getent group developer >/dev/null; then \
    groupadd -g 1000 developer; \
    fi \
    && if ! id -u developer >/dev/null 2>&1; then \
    useradd -m -u 1000 -g developer -s /bin/bash developer; \
    fi


RUN npm install -g opencode-ai

RUN mkdir -p \
    /workspaces \
    /home/developer/.config/opencode

RUN chown -R developer:developer \
    /workspaces \
    /home/developer

USER developer
