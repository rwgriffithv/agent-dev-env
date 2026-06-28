#!/usr/bin/env bash
#
# scripts/setup-host.sh
#
# Sets up a host environment to support the project's devcontainers.
#
set -euo pipefail

# Load .env file if it exists
set -a; [ -f .env ] && . .env; set +a

########################################
# State
########################################

changed=false

########################################
# Logging
########################################

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

info() { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}*${NC} $*"; }
warn() { echo -e "${YELLOW}*${NC} $*"; }
fail() { echo -e "${RED}*${NC} $*"; exit 1; }

########################################
# Parse Arguments
########################################

FORCE_OVERWRITE=false
if [[ "${1:-}" == "--force" ]]; then
    FORCE_OVERWRITE=true
    info "Forcing overwrites..."
fi

########################################
# Devcontainer guard
########################################

if [[ -n "${REMOTE_CONTAINERS:-}" ]] || [[ -n "${CODESPACES:-}" ]]; then
    fail "Devcontainer environment detected. Host setup must run on host."
fi

########################################
# Detect OS
########################################

if [[ ! -f /etc/os-release ]]; then fail "Unsupported Linux distribution."; fi
source /etc/os-release
[[ "$ID" =~ ^(debian|ubuntu)$ ]] || fail "This script currently supports Debian and Ubuntu."

########################################
# Install apt packages if missing
########################################

install_if_missing() {
    local pkg="$1"

    if [ "$FORCE_OVERWRITE" = false ] && dpkg -s "$pkg" >/dev/null 2>&1; then
        success "$pkg already installed."
    else
        info "Installing $pkg..."
        sudo apt-get install -y "$pkg"
        changed=true
    fi
}

install_if_missing curl
install_if_missing git
install_if_missing zstd

########################################
# Docker & VS Code Checks
########################################

command -v docker >/dev/null || warn "Docker is not installed."
command -v code >/dev/null || warn "VS Code not found. Devcontainers designed for VS Code."

########################################
# Ollama Setup
########################################

if command -v ollama >/dev/null; then
    success "Ollama already installed."
else
    info "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    changed=true
fi

# Configure Ollama service
OVERRIDE="/etc/systemd/system/ollama.service.d/override.conf"

if [ "$FORCE_OVERWRITE" = false ] && [[ -f "$OVERRIDE" && $(grep -c 'OLLAMA_HOST=0.0.0.0' "$OVERRIDE") -gt 0 ]]; then
    success "Ollama configuration already correct."
else
    info "Configuring Ollama for network access..."
    sudo mkdir -p /etc/systemd/system/ollama.service.d
    cat <<EOF | sudo tee "$OVERRIDE" >/dev/null
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
EOF
    sudo systemctl daemon-reload
    changed=true
fi

# Ensure Ollama is running/restarted
if ! systemctl is-active --quiet ollama || [ "$changed" = true ]; then
    info "Restarting Ollama service..."
    sudo systemctl enable --now ollama
    sudo systemctl restart ollama
fi

########################################
# Pull models
########################################

pull_model() {
    local model="$1"
    if [ "$FORCE_OVERWRITE" = false ] && ollama list | awk '{print $1}' | grep -qx "$model"; then
        success "$model already present."
    else
        info "Pulling $model..."
        ollama pull "$model"
    fi
}

pull_model qwen2.5-coder:7b
pull_model qwen2.5-coder:3b

########################################
# Final Summary
########################################

echo -e "\n----------------------------------------"
if [ "$changed" = true ] || [ "$FORCE_OVERWRITE" = true ]; then
    success "Host setup completed."
else
    success "Host already configured."
fi
