#!/bin/bash
# scripts/pull-models.sh

echo "🧠 Pulling required Ollama models for the Dev Environment..."

# Check if Ollama is running
if ! command -v ollama &> /dev/null; then
    echo "❌ Error: Ollama is not installed or not in your PATH."
    exit 1
fi

echo "Pulling Qwen 2.5 Coder 7B (For heavy lifting)..."
ollama pull qwen2.5-coder:7b

echo "Pulling Qwen 2.5 Coder 3B (For blazing fast autocomplete)..."
ollama pull qwen2.5-coder:3b

echo "✅ Models are ready to use!"
