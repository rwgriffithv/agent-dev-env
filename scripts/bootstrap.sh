#!/bin/bash
# scripts/bootstrap.sh - Corrected for OpenCode Skill Discovery

set -e

echo "🚀 Bootstrapping OpenCode Agentic Environment..."

# 1. Config
ENV_ROOT="agent-dev-env"
MODE=$1
ENV_TYPE=${2:-opencode-base}

# 2. Setup Devcontainer
rm -rf .devcontainer
if [ "$MODE" == "--template" ]; then
  cp -r "$ENV_ROOT/.devcontainer/$ENV_TYPE" ./.devcontainer
else
  ln -sf "$ENV_ROOT/.devcontainer/$ENV_TYPE" .devcontainer
fi

# 3. Setup Agent Rules & Skills
echo "🧠 Linking Rules and Skills..."

# Link Rules
rm -rf rules
ln -sf "$ENV_ROOT/rules" ./rules

# Link Skills
mkdir -p .opencode
rm -rf .opencode/skills
ln -sf "$(pwd)/$ENV_ROOT/skills" ./.opencode/skills


# 4. Git Hygiene
if ! grep -qE "^.devcontainer|^.opencode/skills" .gitignore 2>/dev/null; then
  printf ".devcontainer\n.opencode/skills\n" >> .gitignore
fi

# ...

echo "✅ Bootstrap complete! Skills are now discoverable by OpenCode."
