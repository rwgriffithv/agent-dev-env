# 🤖 Agent Dev Environment

A version-controlled **agentic development environment** designed to be included as a **Git submodule** in your software projects.

Rather than copying prompts, scripts, and configuration into every repository, this project provides a shared foundation of agent tooling that multiple projects can inherit and update independently.

The parent repository owns the application code. **Agent Dev Environment** provides the common AI development infrastructure.

---

# How It Works

```
parent-project/
│
├── src/
├── package.json
├── .gitignore
│
├── agent-dev-env/        ← Git submodule
│   ├── rules/
│   ├── skills/
│   ├── scripts/
│   └── .devcontainer/
│
├── .devcontainer/        ← linked/generated
├── rules/                ← symlink
└── .opencode/
    └── skills/           ← symlink
```

The `bootstrap.sh` script links the shared resources from the `agent-dev-env` submodule into the parent project, allowing tools like OpenCode to discover them using their expected directory layout.

This approach keeps the agent infrastructure centralized while allowing every project to use the same standards, skills, and development environment.

---

# What This Repository Provides

This repository contains the shared components that define your AI coding environment:

* 🧠 Local LLM integration (Ollama)
* 📦 Dev Container templates
* 📚 Reusable agent Skills (SOPs)
* 📏 Project-wide engineering Rules
* 🔧 Bootstrap and maintenance scripts
* 🌐 Browser automation and web research tooling
* 🔄 Version-controlled updates across projects

Each application repository consumes these resources rather than duplicating them.

---

# Repository Structure

```text
agent-dev-env/
├── .devcontainer/      # Shared Dev Container templates
├── docs/               # Documentation
├── rules/              # Coding standards and agent constraints
├── scripts/            # Bootstrap and maintenance scripts
├── skills/             # Reusable agent skills
├── AGENTS.md           # Agent personas
└── README.md
```

---

# Adding to a Project

Add the repository as a Git submodule:

```bash
git submodule add <repository-url> agent-dev-env
```

Initialize the submodule:

```bash
git submodule update --init --recursive
```

---

# Bootstrap the Parent Repository

From the **parent project root**, run:

```bash
./agent-dev-env/scripts/bootstrap.sh --template opencode-base
```

The bootstrap script configures the parent repository by:

* installing the selected Dev Container
* linking the shared `rules/` directory
* linking OpenCode skills into `.opencode/skills`
* updating `.gitignore`
* preparing the repository for AI-assisted development

After bootstrapping, your project has the directory structure expected by OpenCode without duplicating shared assets.

---

# Development Workflow

1. Clone the parent repository.
2. Initialize Git submodules.
3. Run the bootstrap script.
4. Open the repository in VS Code.
5. Reopen in the Dev Container.
6. Launch OpenCode.

```bash
opencode
```

---

# Skills

The `skills/` directory contains reusable Standard Operating Procedures (SOPs) that teach the agent how to perform common engineering tasks consistently.

Each skill defines:

* objective
* execution workflow
* validation steps
* decision points
* completion criteria

Example skills include:

* `research-web`
* `scaffold-nextjs-route`
* `playwright-ui-test`
* `npm-update-deps`

Because these skills live in the shared submodule, improvements automatically become available to every project after updating the submodule.

---

# Rules

The `rules/` directory defines engineering constraints shared across projects.

Typical rules include:

* architectural conventions
* framework standards
* testing requirements
* documentation expectations
* coding style
* naming conventions

The agent consults these rules before generating or modifying code, ensuring consistent behavior across repositories.

---

# Updating the Shared Environment

As the toolkit evolves, individual projects can adopt updates without changing their application code.

Update the submodule:

```bash
git submodule update --remote
```

If the update modifies configuration or tooling, rerun bootstrap:

```bash
./agent-dev-env/scripts/bootstrap.sh --template opencode-base
```

---

# Design Philosophy

Application code belongs in the parent repository.

Agent infrastructure belongs in this repository.

By separating the two, you gain:

* a single source of truth for agent behavior
* reusable Skills across all projects
* consistent engineering standards
* reproducible development environments
* independent versioning of application code and AI tooling

Instead of every repository maintaining its own prompts, rules, and Dev Container configuration, they all build upon the same shared agentic foundation.
