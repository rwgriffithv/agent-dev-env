#!/bin/bash
# scripts/bootstrap.sh

echo "🚀 Bootstrapping AI Dev Environment..."

if [ ! -d "agent-dev-env" ]; then
  echo "❌ Error: 'agent-dev-env' submodule not found in the current directory."
  exit 1
fi

MODE=$1
ENV_TYPE=${2:-webdev} # Defaults to 'webdev' if no second argument is provided

if [ -z "$MODE" ]; then
  echo "❌ Error: Please specify a mode. Usage: ./bootstrap.sh [--template | --link] [env_type]"
  exit 1
fi

# 1. Handle the Devcontainer
rm -rf .devcontainer

if [ "$MODE" == "--template" ]; then
  echo "📂 Template Mode: Copying .$ENV_TYPE devcontainer..."
  cp -r ./agent-dev-env/.devcontainer/$ENV_TYPE ./.devcontainer
  echo "✅ You can now safely customize this project's .devcontainer without affecting the submodule."

elif [ "$MODE" == "--link" ]; then
  echo "🔗 Link Mode: Symlinking .$ENV_TYPE devcontainer..."
  ln -sf ./agent-dev-env/.devcontainer/$ENV_TYPE ./.devcontainer
  
  # Add to gitignore so we don't commit the symlink
  if ! grep -q ".devcontainer" .gitignore 2>/dev/null; then
    echo ".devcontainer" >> .gitignore
  fi
  echo "⚠️ Warning: Any edits to this .devcontainer will modify the global submodule."

else
  echo "❌ Error: Invalid mode. Use --template or --link."
  exit 1
fi

# 2. Always Symlink the AI Rules (We want the brain to be global)
echo "🧠 Linking .cursorrules..."
ln -sf ./agent-dev-env/.cursorrules ./.cursorrules

if ! grep -q ".cursorrules" .gitignore 2>/dev/null; then
  echo ".cursorrules" >> .gitignore
fi

echo "✅ Bootstrap complete! You can now 'Reopen in Container'."
