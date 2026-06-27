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
# Pathing
########################################

SUBMODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_DIR="$(pwd)"

[[ "$PROJECT_DIR" == "$SUBMODULE_DIR" ]] && fail "Bootstrap must be run from the parent repository."

########################################
# Parse Arguments
########################################

TEMPLATE="base"
MODE="symlink"
FORCE_OVERWRITE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --template)
            [[ $# -ge 2 ]] || fail "Missing template name."
            TEMPLATE="$2"
            shift 2
            ;;
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
  --template <name>   Devcontainer template (default: base)
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

[[ ! -d "$SUBMODULE_DIR/.devcontainer/$TEMPLATE" ]] && fail "Unknown devcontainer template: $TEMPLATE"

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
# Install Devcontainer
########################################

EXPECTED_TARGET="$SUBMODULE_DIR/.devcontainer/$TEMPLATE"

if [[ "$MODE" == "symlink" ]]; then
    if [[ -L .devcontainer ]]; then
        CURRENT_TARGET="$(readlink .devcontainer)"
        if [[ "$CURRENT_TARGET" == "$EXPECTED_TARGET" ]]; then
            success "Devcontainer already linked."
        else
            rm .devcontainer
            ln -s "$EXPECTED_TARGET" .devcontainer
            success "Linked devcontainer template ($TEMPLATE)."
        fi
    else
        if [[ -e .devcontainer ]]; then
            warn "Existing .devcontainer found. Backing up to .devcontainer.bak"
            rm -rf .devcontainer.bak && mv .devcontainer .devcontainer.bak
        fi
        ln -s "$EXPECTED_TARGET" .devcontainer
        success "Linked devcontainer template ($TEMPLATE)."
    fi
else
    if [[ -e .devcontainer ]]; then
        warn "Existing .devcontainer found. Backing up to .devcontainer.bak"
        rm -rf .devcontainer.bak && mv .devcontainer .devcontainer.bak
    fi
    cp -R "$EXPECTED_TARGET" .devcontainer
    success "Installed devcontainer template ($TEMPLATE)."
fi

########################################
# Shared Agent Configuration
########################################

mkdir -p .opencode
rm -rf .opencode/skills
ln -sfn "$SUBMODULE_DIR/skills" .opencode/skills
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
