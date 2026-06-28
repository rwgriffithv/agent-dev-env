#!/usr/bin/env bash
#
# scripts/bootstrap.sh
#
# Bootstraps a parent repository using the shared agent-dev-env submodule.
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
# Devcontainer guard
########################################

if [[ -n "${REMOTE_CONTAINERS:-}" ]] || [[ -n "${CODESPACES:-}" ]]; then
    fail "Devcontainer environment detected. Bootstrap must run on host."
fi

########################################
# Pathing
########################################

SUBMODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="$(pwd)"
SUBMODULE_REL="${SUBMODULE_DIR#"${PROJECT_DIR}/"}"

[[ "$PROJECT_DIR" == "$SUBMODULE_DIR" ]] && fail "Bootstrap must be run from the parent repository."

########################################
# Parse Arguments
########################################

TEMPLATE="base"
MODE="symlink"
FORCE_OVERWRITE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --copy)
            MODE="copy"
            shift
            ;;
        --symlink)
            MODE="symlink"
            shift
            ;;
        --force)
            FORCE_OVERWRITE=true
            info "Forcing overwrites..."
            shift
            ;;
        --help|-h)
            cat <<EOF
Usage: bootstrap.sh [options]

Options:
  --copy              Copy devcontainer instead of symlinking
  --symlink           Symlink devcontainer (default)
  --force             Force overwrite existing configurations
EOF
            exit 0
            ;;
        *)
            fail "Unknown option: $1"
            ;;
    esac
done

########################################
# Environment Variables
########################################

REQUIRED_VARS=("BRAVE_API_KEY")

for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var:-}" ]]; then
        warn "Required environment variable '$var' is not set.
Please ensure it is defined in your .env file or set manually."
    fi
done

########################################
# Install Devcontainers
########################################

SOURCE_TEMPLATES_DIR="$SUBMODULE_DIR/.devcontainer"
TARGET_DEVCONTAINER_DIR="$PROJECT_DIR/.devcontainer"

mkdir -p "$TARGET_DEVCONTAINER_DIR"
info "Installing all templates ($MODE)..."

for template_path in "$SOURCE_TEMPLATES_DIR"/*/; do
    template_name=$(basename "$template_path")
    target_path="$TARGET_DEVCONTAINER_DIR/$template_name"

    if [[ "$MODE" == "symlink" ]]; then
        if [[ -e "$target_path" && "$FORCE_OVERWRITE" == "false" ]]; then
            warn "Skipping $template_name (already exists, use --force to overwrite)."
        else
            rel_target="../${SUBMODULE_REL}/.devcontainer/${template_name}"
            ln -sfn "$rel_target" "$target_path"
            success "Linked template: $template_name"
        fi
    else
        if [[ -d "$target_path" && "$FORCE_OVERWRITE" == "false" ]]; then
            warn "Skipping $template_name (already exists, use --force to overwrite)."
        else
            rm -rf "$target_path"
            cp -R "$template_path" "$target_path"
            success "Copied template: $template_name"
        fi
    fi
done

########################################
# Shared Agent Configuration
########################################

mkdir -p .opencode
rm -rf .opencode/skills
ln -sfn "../${SUBMODULE_REL}/skills" .opencode/skills
success "Linked shared skills."

mkdir -p rules
if [[ ! -f AGENTS.md ]]; then
    cat > AGENTS.md <<'EOF'
# Project Agent Instructions
Describe the project architecture, conventions, workflows, and any
project-specific guidance for the coding agent.
EOF
    success "Created AGENTS.md."
fi

########################################
# .gitignore
########################################

touch .gitignore
[[ "$MODE" == "symlink" ]] && grep -qxF ".devcontainer" .gitignore || echo ".devcontainer" >> .gitignore
grep -qxF ".opencode/skills" .gitignore || echo ".opencode/skills" >> .gitignore
success "Updated .gitignore."

########################################
# Final Summary
########################################

echo -e "\n----------------------------------------"
success "Bootstrap complete."
printf "  %-14s %s\n" "Devcontainer:" "$MODE ($TEMPLATE)"
printf "  %-14s %s\n" "Skills:" "Shared (agent-dev-env)"
printf "  %-14s %s\n" "Rules:" "Project-owned (rules/)"
printf "  %-14s %s\n" "AGENTS.md:" "Project-owned"
