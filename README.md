# 🤖 Agent Development Environment

A version-controlled **agentic development toolkit** designed to be included as a **Git submodule** in software projects.

Rather than duplicating prompts, agent configuration, development containers, and workflows across repositories, `agent-dev-env` provides a shared foundation that multiple projects can consume while maintaining their own application code and project-specific guidance.

The result is a consistent AI-assisted development environment that can evolve independently of the applications that use it.

---

# Architecture

A project using `agent-dev-env` typically looks like this:

```text
parent-project/
│
├── src/
├── package.json
├── AGENTS.md                 # Project-specific agent guidance
├── rules/                    # Project-specific rules
│
├── agent-dev-env/            # Git submodule
│   ├── .devcontainer/
│   ├── rules/
│   ├── skills/
│   └── scripts/
│
├── .devcontainer/            # Bootstrapped runtime
└── .opencode/
    └── skills -> agent-dev-env/skills
```

The parent repository owns the application.

`agent-dev-env` provides the shared runtime, reusable agent capabilities, and common engineering standards.

---

# What This Repository Provides

The toolkit contains four primary components:

| Component | Purpose |
| --- | --- |
| **Configuration** | Setup the host with dependencies and bootstrap project configs. |
| **Dev Container** | A reproducible development environment for OpenCode and local AI development. |
| **Skills** | Reusable Standard Operating Procedures (SOPs) that teach the agent how to perform engineering tasks. |
| **Rules** | Shared engineering standards and coding conventions applied across projects. |
| **Scripts** | Bootstrap and maintenance utilities for installing and updating the environment. |

Because these components live in a shared repository, improvements can be rolled out across multiple projects simply by updating the Git submodule.

---

# Repository Structure

```text
agent-dev-env/
├── .devcontainer/      # Shared development environments
├── docs/               # Toolkit documentation
├── rules/              # Shared engineering rules
├── scripts/            # Bootstrap and maintenance scripts
├── skills/             # Reusable OpenCode skills
├── AGENTS.md           # Shared agent guidance
└── README.md
```

---

# Installing into a Project

Add the submodule to your repository:

```bash
git submodule add <repository-url> web-deploy-env
git submodule update --init --recursive

```

### 1. Configuration

Create/update the `.env` file in your project root with the following requirements:

```text
DOMAIN=yourdomain.com
TUNNEL_TOKEN=your_cloudflare_tunnel_token

```

### 2. Setup and Bootstrap

Setup host dependencies and bootstrap the parent repository:

```bash
./web-deploy-env/scripts/setup-host.sh
./web-deploy-env/scripts/bootstrap.sh

```

The setup and bootstrap processes are idempotent.

---

# Project Customization

Projects are expected to define their own behavior without modifying the shared toolkit.

## Project Rules

Create Markdown files inside:

```text
rules/
```

These contain project-specific standards such as:

* architecture decisions
* coding conventions
* deployment requirements
* testing expectations

OpenCode loads both the shared rules provided by `agent-dev-env` and the project's own rules.

## Project Agent Context

Use:

```text
AGENTS.md
```

to describe:

* project purpose
* architecture overview
* preferred workflows
* important implementation notes

This gives the agent repository-specific context without modifying the shared toolkit.

---

# Skills

The `skills/` directory contains reusable capabilities that are intended to work across many repositories.

Examples include:

* researching APIs or libraries
* scaffolding new features
* performing dependency updates
* running Playwright-based UI verification

Unlike rules, skills are generally shared between projects rather than customized per repository.

---

# Development Workflow

For a typical project:

1. Clone the repository.
2. Initialize Git submodules.
3. Run each submodule's setup-host and bootstrap scripts.
4. Open the project in VS Code.
5. Reopen in the Dev Container.
6. Launch OpenCode.

```bash
opencode
```

---

# Updating the Toolkit

To receive improvements to the shared development environment, update the Git submodule:

```bash
git submodule update --remote
```

If the update changes the runtime configuration, rerun bootstrap:

```bash
./agent-dev-env/scripts/bootstrap.sh
```

Projects automatically retain their own `rules/`, `AGENTS.md`, and application code.

---

# Design Philosophy

`agent-dev-env` separates **agent infrastructure** from **application development**.

The toolkit provides:

* a shared runtime
* reusable agent skills
* common engineering standards

Each project contributes:

* application code
* project-specific rules
* repository-specific agent context

This separation allows improvements to the AI development environment to be shared across repositories while preserving each project's own conventions and requirements.
