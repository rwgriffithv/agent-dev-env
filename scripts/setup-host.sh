#!/usr/bin/env bash
#
# scripts/setup-host.sh
#
# Sets up a host environment to support the project's devcontainers.
#
set -euo pipefail

# Load .env file if it exists
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

########################################
# OpenCode Host Setup
########################################

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

changed=false

info() {
    echo -e "${BLUE}==>${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

fail() {
    echo -e "${RED}✗${NC} $*"
    exit 1
}

########################################
# Detect OS
########################################

if [[ ! -f /etc/os-release ]]; then
    fail "Unsupported Linux distribution."
fi

source /etc/os-release

case "$ID" in
    debian|ubuntu)
        ;;
    *)
        fail "This script currently supports Debian and Ubuntu."
        ;;
esac

########################################
# Install apt packages if missing
########################################

install_if_missing() {
    local pkg="$1"

    if dpkg -s "$pkg" >/dev/null 2>&1; then
        success "$pkg already installed."
    else
        info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
        changed=true
    fi
}

info "Updating package index..."
sudo apt-get update

install_if_missing curl
install_if_missing git
install_if_missing zstd

########################################
# Docker
########################################

if command -v docker >/dev/null; then
    success "Docker installed."
else
    warn "Docker is not installed."
    echo "Install Docker before using this project."
fi

########################################
# VS Code
########################################

if command -v code >/dev/null; then
    success "VS Code detected."
else
    warn "VS Code not found."
fi

########################################
# Ollama
########################################

if command -v ollama >/dev/null; then
    success "Ollama already installed."
else
    info "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    changed=true
fi

########################################
# Configure Ollama service
########################################

OVERRIDE="/etc/systemd/system/ollama.service.d/override.conf"

if sudo test -f "$OVERRIDE" && \
   sudo grep -q 'OLLAMA_HOST=0.0.0.0' "$OVERRIDE"; then
    success "Ollama already configured for network access."
else
    info "Configuring Ollama..."

    sudo mkdir -p /etc/systemd/system/ollama.service.d

    cat <<EOF | sudo tee "$OVERRIDE" >/dev/null
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
EOF

    sudo systemctl daemon-reload
    sudo systemctl restart ollama

    changed=true
fi

########################################
# Pull models
########################################

pull_model() {
    local model="$1"

    if ollama list | awk '{print $1}' | grep -qx "$model"; then
        success "$model already present."
    else
        info "Pulling $model..."
        ollama pull "$model"
    fi
}

pull_model qwen2.5-coder:7b
pull_model qwen2.5-coder:3b

########################################
# API Key
########################################

if [[ -n "${BRAVE_API_KEY:-}" ]]; then
    success "BRAVE_API_KEY is set."
else
    warn "No Brave Search API key found."

    cat <<EOF

Set the following in your shell profile (.env):

BRAVE_API_KEY="your-key"

Then reload your shell:

source .env

EOF
fi

########################################
# Summary
########################################

echo
echo "----------------------------------------"

if $changed; then
    success "Host setup completed."
else
    success "Host already configured."
fi

echo
echo "Next steps:"
echo "  1. Bootstrap submodules."
echo "  2. Open the project in VS Code."
echo "  3. Reopen in the Dev Container."
echo "  4. Run: opencode"
