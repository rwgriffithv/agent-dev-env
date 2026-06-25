#!/usr/bin/env bash
#
# .devcontainer/opencode-base/setup.sh
#
# Sets up the devcontainer environment after creation.
#
set -euo pipefail

CONFIG_DIR="$HOME/.config/opencode"
CONFIG_FILE="$CONFIG_DIR/opencode.json"
SOURCE_CONFIG="./agent-dev-env/.devcontainer/opencode-base/opencode.json"

echo
echo "⚙️  Configuring Agent Development Environment..."
echo

###############################################################################
# Verify OpenCode
###############################################################################

if ! command -v opencode >/dev/null; then
    echo "❌ OpenCode CLI is not installed."
    exit 1
fi

###############################################################################
# Install Configuration
###############################################################################

mkdir -p "$CONFIG_DIR"

install -m 644 "$SOURCE_CONFIG" "$CONFIG_FILE"

###############################################################################
# Detect Ollama
###############################################################################

if curl -fs http://host.docker.internal:11434/api/tags >/dev/null 2>&1; then
    OLLAMA_STATUS="✓ Connected"
else
    OLLAMA_STATUS="⚠ Unreachable"
fi

###############################################################################
# Detect Brave
###############################################################################

if [[ -n "${BRAVE_API_KEY:-}" ]] && [[ ${#BRAVE_API_KEY} -gt 20 ]]; then
    BRAVE_STATUS="✓ Configured"
else
    BRAVE_STATUS="⚠ Missing API key"
fi

###############################################################################
# Detect Skills
###############################################################################

if [[ -d ./.opencode/skills ]]; then
    SKILL_COUNT=$(find ./.opencode/skills -mindepth 1 -maxdepth 1 -type d | wc -l)
else
    SKILL_COUNT=0
fi

###############################################################################
# Detect Rules
###############################################################################

if [[ -d ./rules ]]; then
    RULE_COUNT=$(find ./rules -name "*.md" | wc -l)
else
    RULE_COUNT=0
fi

###############################################################################
# Summary
###############################################################################

echo
echo "────────────────────────────────────────────"
echo " Agent Development Environment"
echo "────────────────────────────────────────────"
echo
echo " OpenCode          : ✓ Installed"
echo " Configuration     : ✓ Installed"
echo " Ollama            : $OLLAMA_STATUS"
echo " Brave Search      : $BRAVE_STATUS"
echo " Rules             : $RULE_COUNT loaded"
echo " Skills            : $SKILL_COUNT discovered"
echo
echo " Ready."
echo
