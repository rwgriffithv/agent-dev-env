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

TEMPLATE="base"
MODE="symlink"

###############################################################################
# Parse Arguments
###############################################################################

while [[ $# -gt 0 ]]; do
    case "$1" in
        --template)
            [[ $# -ge 2 ]] || {
                echo "❌ Missing template name."
                exit 1
            }
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

        --help|-h)
            cat <<EOF
Usage:

  bootstrap.sh [options]

Options:

  --template <name>   Devcontainer template to install
                      (default: base)

  --copy              Copy the devcontainer instead of symlinking it.

  --symlink           Symlink the devcontainer (default).

Examples:

  ./agent-dev-env/scripts/bootstrap.sh

  ./agent-dev-env/scripts/bootstrap.sh --template base --copy

EOF
            exit 0
            ;;

        *)
            echo "❌ Unknown option: $1"
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
    echo "  cd .."
    echo "  ./agent-dev-env/scripts/bootstrap.sh"
    exit 1
fi

if [[ ! -d "$ENV_ROOT/skills" ]]; then
    echo "❌ agent-dev-env appears to be incomplete."
    echo
    echo "Did you initialize the submodule?"
    echo
    echo "  git submodule update --init --recursive"
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

EXPECTED_TARGET="$ENV_ROOT/.devcontainer/$TEMPLATE"

if [[ "$MODE" == "symlink" ]]; then

    if [[ -L .devcontainer ]]; then

        CURRENT_TARGET="$(readlink .devcontainer)"

        if [[ "$CURRENT_TARGET" == "$EXPECTED_TARGET" ]]; then
            echo "✓ Devcontainer already linked"
        else
            rm .devcontainer
            ln -s "$EXPECTED_TARGET" .devcontainer
            echo "✓ Linked devcontainer template ($TEMPLATE)"
        fi

    else

        if [[ -e .devcontainer ]]; then
            echo "⚠️  Existing .devcontainer found."
            echo "    Backing up to .devcontainer.bak"
            rm -rf .devcontainer.bak
            mv .devcontainer .devcontainer.bak
        fi

        ln -s "$EXPECTED_TARGET" .devcontainer
        echo "✓ Linked devcontainer template ($TEMPLATE)"

    fi

else

    if [[ -e .devcontainer ]]; then
        echo "⚠️  Existing .devcontainer found."
        echo "    Backing up to .devcontainer.bak"
        rm -rf .devcontainer.bak
        mv .devcontainer .devcontainer.bak
    fi

    cp -R "$EXPECTED_TARGET" .devcontainer
    echo "✓ Installed devcontainer template ($TEMPLATE)"

fi

###############################################################################
# Shared Skills
###############################################################################

mkdir -p .opencode

rm -rf .opencode/skills

ln -sfn "$ENV_ROOT/skills" .opencode/skills

echo "✓ Linked shared skills"

###############################################################################
# Project Structure
###############################################################################

mkdir -p rules

if [[ ! -f AGENTS.md ]]; then

cat > AGENTS.md <<'EOF'
# Project Agent Instructions

Describe the project architecture, conventions, workflows, and any
project-specific guidance for the coding agent.

EOF

    echo "✓ Created AGENTS.md"

fi

###############################################################################
# .gitignore
###############################################################################

touch .gitignore

if [[ "$MODE" == "symlink" ]]; then
    grep -qxF ".devcontainer" .gitignore ||
        echo ".devcontainer" >> .gitignore
fi

grep -qxF ".opencode/skills" .gitignore ||
    echo ".opencode/skills" >> .gitignore

echo "✓ Updated .gitignore"

###############################################################################
# Complete
###############################################################################

echo
echo "✅ Bootstrap complete."
echo
echo "Installed:"
echo
printf "  %-14s %s\n" "Devcontainer:" "$MODE ($TEMPLATE)"
printf "  %-14s %s\n" "Skills:" "Shared (agent-dev-env)"
printf "  %-14s %s\n" "Rules:" "Project-owned (rules/)"
printf "  %-14s %s\n" "AGENTS.md:" "Project-owned"
echo
echo "Next steps:"
echo
echo "  1. Add project-specific rules to:"
echo "       rules/"
echo
echo "  2. Update AGENTS.md with project context."
echo
echo "  3. Open the repository in VS Code."
echo
echo "  4. Reopen in Dev Container."
echo
echo "  5. Launch OpenCode:"
echo
echo "       opencode"
echo
