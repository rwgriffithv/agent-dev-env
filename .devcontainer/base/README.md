# Base Dev Container

This directory contains the reference implementation of the base development environment used by the `agent-dev-env` toolkit.

These files define the shared runtime that is bootstrapped into projects consuming `agent-dev-env`.

## Files

| File                | Purpose                                                                                                       |
| ------------------- | ------------------------------------------------------------------------------------------------------------- |
| `devcontainer.json` | Defines the VS Code Dev Container configuration and runtime settings.                                         |
| `Dockerfile`        | Builds the container image with the OpenCode CLI and supporting dependencies.                                 |
| `configure.sh`      | Configures OpenCode inside the container after creation or content updates.                                   |
| `opencode.json`     | Default OpenCode configuration, including model providers, MCP servers, permissions, and instruction sources. |

## Responsibilities

The base dev container is responsible for providing the shared runtime used by every project, including:

* a reproducible development container
* the OpenCode CLI
* connectivity to a locally running Ollama instance
* shared MCP server configuration
* the default OpenCode runtime configuration

Agent behavior is defined elsewhere in the `agent-dev-env` toolkit through the `rules/`, `skills/`, and `AGENTS.md` resources, which are linked into the consuming project during the bootstrap process.

Keeping the runtime separate from the agent's behavior allows the development environment and the agent toolkit to evolve independently.

## Customization

Changes made in this directory affect the runtime for every project using this toolkit.

Typical changes include:

* updating the base container image
* adding common development tools
* configuring shared MCP servers
* updating the default OpenCode configuration

Changes to coding standards, workflows, or agent behavior should instead be made in the toolkit's `rules/`, `skills/`, or `AGENTS.md` resources.
