# 🤖 OpenCode Agentic Environment (Debian Slim)

This is a specialized, highly autonomous Devcontainer template built around the **OpenCode CLI**. 

Unlike standard autocomplete extensions, OpenCode acts as an autonomous agent. By routing its reasoning engine to your host machine's Ollama instance, it can execute multi-step coding tasks, run terminal commands, and use Model Context Protocol (MCP) servers—all while keeping your VRAM usage incredibly efficient.

## 🌟 Capabilities
* **File System Autonomy:** Can read, patch, and execute files within the workspace.
* **Terminal Access:** Can run `npm run build`, `pytest`, or `git` commands directly in the container shell.
* **Web Searching:** Equipped with the Brave Search MCP to autonomously hunt for API documentation or debug stack traces.
* **Playwright Automation:** Can boot up a headless browser to verify DOM rendering.
* **Persistent Memory:** Builds a cross-session knowledge graph of your project architecture.

---

## 🚀 How to Use This Template

Because this environment relies on a database configuration and persistent memory graph, it is designed to be used in **Template Mode**.

### 1. Bootstrap your Project
From the root of your parent repository, run the bootstrap script to create an independent copy of this environment:

```bash
./agent-dev-env/scripts/bootstrap.sh --template opencode-base
```

### 2. Configure Your Environment Variables (Required for Search)
OpenCode relies on VS Code's devcontainer feature to securely forward environment variables from your *host machine* (your laptop) into the container.

To enable the Web Search MCP, you must set the `BRAVE_API_KEY` on your local laptop before spinning up the container.

**On Mac/Linux/WSL:**
Add this to your `~/.bashrc` or `~/.zshrc`:
```bash
export BRAVE_API_KEY="your_free_brave_developer_key"
```

**On Windows (PowerShell):**
```powershell
[System.Environment]::SetEnvironmentVariable('BRAVE_API_KEY', 'your_free_brave_developer_key', 'User')
```

### 3. Spin it Up
1. Open the project in VS Code.
2. Press `Cmd/Ctrl + Shift + P` -> **Dev Containers: Reopen in Container**.
3. Once built, open the VS Code terminal and type:
   ```bash
   opencode
   ```
   You will drop into the interactive terminal UI, fully connected to your local Qwen 2.5 Coder 7B model.

---

## 🛠️ Extending the Agent (Adding MCP Tools)

If you want to give your agent access to new tools (like connecting to a PostgreSQL database instead of SQLite, or adding the GitHub integration), you don't need to rebuild the entire Docker image.

### To add a new tool:
1. Open `~/.config/opencode/opencode.json` (or the `opencode.json` file copied into your project root).
2. Add the new tool to the `"mcp"` block. For example, to add the official GitHub MCP:
   ```json
   "mcp": {
     ...
     "github": {
       "type": "local",
       "command": ["npx", "-y", "@modelcontextprotocol/server-github"],
       "env": {
         "GITHUB_PERSONAL_ACCESS_TOKEN": "$YOUR_GITHUB_PAT"
       }
     }
   }
   ```
3. Update your `.devcontainer/devcontainer.json` to forward the new environment variable (`YOUR_GITHUB_PAT`) from your host machine.
4. Restart the OpenCode CLI.

## 📝 A Note on System Resources
This container uses `node:22-bookworm-slim` to conserve disk space, but it does install Chromium dependencies to support Playwright. If you find the image is taking up too much space and you do not need browser automation, you can safely remove the Playwright `npx` command from your `opencode.json` and strip the `lib*` packages from the `Dockerfile`.
