#!/bin/bash
# scripts/update-agent.sh

echo "🔄 Updating local AI agent environment..."

# Navigate into the submodule, pull latest, and return to parent
cd agent-dev-env || exit
git checkout main
git pull origin main
cd ..

echo "✅ Agent environment updated to latest version."
