#!/usr/bin/env bash
#
# scripts/bootstrap.sh
#
# Bootstraps a parent repository using the shared agent-dev-env submodule.
#
set -euo pipefail

###############################################################################
# Configuration
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(pwd)"

TEMPLATE="opencode-base"
MODE="symlink"

###############################################################################
# Parse Arguments
###############################################################################

while [[ $# -gt 0 ]]; do
    case "$1" in
        --template)
            TEMPLATE="$2"
            MODE="copy"
            shift 2
            ;;
        --symlink)
            MODE="symlink"
            shift
            ;;
        --copy)
            MODE="copy"
            shift
            ;;
        --help|-h)
            cat <<EOF
Usage:

  bootstrap.sh [options]

Options:

  --template <name>   Devcontainer template to install
                      (default: opencode-base)

  --copy              Copy the devcontainer instead of symlinking it.

  --symlink           Symlink the devcontainer (default).

Examples:

  ./agent-dev-env/scripts/bootstrap.sh

  ./agent-dev-env/scripts/bootstrap.sh \
      --template webdev

  ./agent-dev-env/scripts/bootstrap.sh \
      --template opencode-base \
      --copy

EOF
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

###############################################################################
# Safety Checks
###############################################################################

if [[ "$PROJECT_ROOT" == "$ENV_ROOT" ]]; then
    echo "❌ Bootstrap must be run from the parent repository."
    echo
    echo "Example:"
    echo "    cd .."
    echo "    ./agent-dev-env/scripts/bootstrap.sh"
    exit 1
fi

if [[ ! -d "$ENV_ROOT/rules" ]]; then
    echo "❌ agent-dev-env appears to be incomplete."
    echo
    echo "Did you initialize the submodule?"
    echo
    echo "    git submodule update --init --recursive"
    exit 1
fi

if [[ ! -d "$ENV_ROOT/.devcontainer/$TEMPLATE" ]]; then
    echo "❌ Unknown devcontainer template: $TEMPLATE"
    exit 1
fi

echo
echo "🚀 Bootstrapping Agent Development Environment..."
echo

###############################################################################
# Install Devcontainer
###############################################################################

if [[ -e .devcontainer && ! -L .devcontainer ]]; then
    echo "⚠️  Existing .devcontainer found."
    echo "    Backing up to .devcontainer.bak"
    rm -rf .devcontainer.bak
    mv .devcontainer .devcontainer.bak
fi

rm -rf .devcontainer

if [[ "$MODE" == "copy" ]]; then
    cp -R "$ENV_ROOT/.devcontainer/$TEMPLATE" .devcontainer
    echo "✓ Installed devcontainer template ($TEMPLATE)"
else
    ln -sfn "$ENV_ROOT/.devcontainer/$TEMPLATE" .devcontainer
    echo "✓ Linked devcontainer template ($TEMPLATE)"
fi

###############################################################################
# Rules
###############################################################################

rm -rf rules
ln -sfn "$ENV_ROOT/rules" rules
echo "✓ Linked rules"

###############################################################################
# Skills
###############################################################################

mkdir -p .opencode
rm -rf .opencode/skills
ln -sfn "$ENV_ROOT/skills" .opencode/skills
echo "✓ Linked OpenCode skills"

###############################################################################
# .gitignore
###############################################################################

touch .gitignore

grep -qxF ".devcontainer" .gitignore || \
    echo ".devcontainer" >> .gitignore

grep -qxF ".opencode/skills" .gitignore || \
    echo ".opencode/skills" >> .gitignore

echo "✓ Updated .gitignore"

###############################################################################
# Complete
###############################################################################

echo
echo "✅ Bootstrap complete."
echo
echo "Next steps:"
echo
echo "  1. Open the repository in VS Code"
echo "  2. Reopen in Dev Container"
echo "  3. Launch OpenCode"
echo
echo "      opencode"
echo
