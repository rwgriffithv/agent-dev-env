#!/usr/bin/env bash
#
# .devcontainer/base/configure.sh
#
# Configures the devcontainer environment after creation.
#
set -euo pipefail

# Load .env file if it exists
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

########################################
# Logging
########################################

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

info() { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
fail() { echo -e "${RED}✗${NC} $*"; exit 1; }

########################################
# Pathing
########################################

CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.json"
SOURCE_CONFIG="./agent-dev-env/.devcontainer/base/opencode.json"

########################################
# Verify OpenCode
########################################

if ! command -v opencode >/dev/null; then
    fail "OpenCode CLI is not installed."
fi

########################################
# Install Configuration
########################################

mkdir -p "$CONFIG_DIR"

install -m 644 "$SOURCE_CONFIG" "$CONFIG_FILE"

########################################
# Detect Ollama
########################################

if curl -fs http://host.docker.internal:11434/api/tags >/dev/null 2>&1; then
    OLLAMA_STATUS="✓ Connected"
else
    warn "Failed to reach Ollama API endpoints."
    OLLAMA_STATUS="⚠ Unreachable"
fi

########################################
# Detect Brave
########################################

if [[ -n "${BRAVE_API_KEY:-}" ]] && [[ ${#BRAVE_API_KEY} -gt 20 ]]; then
    BRAVE_STATUS="✓ Configured"
else
    warn "Brave API key not found in BRAVE_API_KEY."
    BRAVE_STATUS="⚠ Missing API key"
fi

########################################
# Detect Skills
########################################

if [[ -d ./.opencode/skills ]]; then
    SKILL_COUNT=$(find -L ./.opencode/skills -mindepth 1 -maxdepth 1 -type d | wc -l)
else
    warn "No opencode skills configured."
    info "Make sure to run ./agent-dev-env/scripts/bootstrap.sh."
    SKILL_COUNT=0
fi

########################################
# Detect Rules
########################################

# Project rules
if [[ -d ./rules ]]; then
    PROJECT_RULE_COUNT=$(find ./rules -name "*.md" | wc -l)
else
    PROJECT_RULE_COUNT=0
fi

# Base environment rules
if [[ -d ./agent-dev-env/rules ]]; then
    ENV_RULE_COUNT=$(find ./agent-dev-env/rules -name "*.md" | wc -l)
else
    warn "No base environment agent rules found."
    ENV_RULE_COUNT=0
fi

########################################
# Summary
########################################

echo -e "\n----------------------------------------"
success "Configuration complete."
printf "  %-18s %s\n" "OpenCode:" "✓ Installed"
printf "  %-18s %s\n" "Configuration:" "✓ Installed"
printf "  %-18s %s\n" "Ollama:" "$OLLAMA_STATUS"
printf "  %-18s %s\n" "Brave Search:" "$BRAVE_STATUS"
printf "  %-18s %s\n" "Project Rules:" "$PROJECT_RULE_COUNT loaded"
printf "  %-18s %s\n" "Base Env Rules:" "$ENV_RULE_COUNT loaded"
printf "  %-18s %s\n" "Skills:" "$SKILL_COUNT discovered"
