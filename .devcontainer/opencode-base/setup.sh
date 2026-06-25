#!/bin/bash

echo "⚙️ Configuring OpenCode and MCP Servers..."

# 1. Create the global config folder in the container user's home directory
mkdir -p ~/.config/opencode

# 2. Safely copy the static json configuration file
cp ./agent-dev-env/.devcontainer/opencode-base/opencode.json ~/.config/opencode/opencode.json

# 3. Give a status warning if the search key wasn't forwarded from the host machine
if [ -z "$BRAVE_SEARCH_API_KEY" ]; then
    echo "⚠️ Warning: BRAVE_SEARCH_API_KEY env variable was not detected. Brave search MCP will be inactive."
else
    echo "🌐 Brave Search API key successfully inherited from host machine."
fi

echo "✅ OpenCode configuration complete."
