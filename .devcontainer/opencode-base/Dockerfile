FROM node:22-bookworm-slim

# Install necessary base tools, sqlite3, and minimum required libraries for headless browsers
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

# Cleanly rename the default 'node' user profile to 'developer'
RUN usermod -l developer node && \
    groupmod -n developer node && \
    usermod -d /home/developer -m developer

# Install OpenCode globally
RUN npm install -g opencode

# Establish agnostic workspace directory
WORKDIR /workspaces/workspace
RUN chown -R developer:developer /workspaces/workspace

# Switch to the newly named developer profile
USER developer
