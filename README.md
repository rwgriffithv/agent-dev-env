# 🧠 Agent Dev Env (Local AI Workspace)

A centralized, version-controlled repository for managing a local LLM coding assistant, devcontainers, AI system rules, and custom skills. 

Designed to be used as a **Git Submodule**, this repository acts as the single "source of truth" for your AI developer environment. You can attach it to any new or existing project to instantly spin up a hardware-optimized, fully configured AI coding workspace.

## 🏗️ Architecture
* **Host Machine:** Runs [Ollama](https://ollama.com/) directly on the host OS to efficiently manage VRAM/RAM (optimized for 6GB VRAM GPUs).
* **Devcontainer:** Houses the project code and dependencies (Node, Python, C++, etc.).
* **IDE Extension:** Uses the `Continue` extension inside the devcontainer, networked back to the host machine's Ollama instance.

---

## 📂 Repository Structure

```text
agent-dev-env/
├── .devcontainer/        # Base templates for isolated environments (e.g., /webdev)
├── .cursorrules          # Global System Prompts / LLM Persona rules
├── ai-skills/            # Markdown files defining custom AI commands & workflows
├── scripts/              # Automation scripts for host and parent repos
│   ├── bootstrap.sh      # Injects configurations into the parent repo
│   ├── pull-models.sh    # Downloads optimized models to the host Ollama
│   └── update-agent.sh   # Fetches the latest rules and skills
└── README.md             # This file
```

---

## 🚀 Usage: The Submodule Workflow

### 1. Initialize in a Parent Project
Navigate to the root of your existing project, then add this repository as a submodule:

```bash
git submodule add <YOUR_GITHUB_REPO_URL>/agent-dev-env.git agent-dev-env
```

### 2. Pull Local LLM Models (First Time Only)
Ensure your host machine has the correct weights downloaded to Ollama:

```bash
./agent-dev-env/scripts/pull-models.sh
```

### 3. Bootstrap the Project (Two Modes)
You can inject the devcontainer into your parent project in two ways, depending on whether you need project-specific customizations.

**Mode A: Template Mode (Recommended for most projects)**
Creates an independent *copy* of the devcontainer template. Use this if your parent project needs its own specific database, ports, or extensions added to the devcontainer.
```bash
./agent-dev-env/scripts/bootstrap.sh --template webdev
```

**Mode B: Global Symlink Mode**
Creates a *symlink* to the submodule. Any changes made to the devcontainer in the parent project will directly modify the central submodule. Use this only if you want strict uniformity across multiple projects.
```bash
./agent-dev-env/scripts/bootstrap.sh --link webdev
```

*Note: In both modes, the `.cursorrules` AI behavior file is always symlinked, ensuring your AI's personality and skills remain globally synchronized across all projects.*

### 4. Spin Up the Environment
Open the parent repository in VS Code.
1. Press `Cmd/Ctrl + Shift + P`
2. Select **Dev Containers: Reopen in Container**

---

## 🔄 Maintenance & Updates

When you refine your AI's behavior or add a new custom skill, commit those changes directly to this `agent-dev-env` repository. To pull those updates into other projects using this submodule, run:

```bash
./agent-dev-env/scripts/update-agent.sh
```