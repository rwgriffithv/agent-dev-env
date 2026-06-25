FROM node:22-bookworm-slim

ENV \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_FUND=false

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
    librandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
 && rm -rf /var/lib/apt/lists/*

# Create a dedicated development user instead of renaming "node"
RUN groupadd -g 1001 developer \
 && useradd -m -u 1001 -g developer -s /bin/bash developer

RUN npm install -g \
    opencode \
    npm-check-updates

RUN mkdir -p \
    /workspaces/workspace \
    /home/developer/.config/opencode

RUN chown -R developer:developer \
    /workspaces \
    /home/developer

WORKDIR /workspaces/workspace

USER developer
