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

---

## Configuration

The build process for this dev container is configurable using environment variables. These variables allow you to point the build process to custom registries or alternative base images while maintaining sensible defaults.

| Variable | Description | Default |
| --- | --- | --- |
| `IMAGE_REGISTRY` | The registry or organization prefix used for pulling base images. | `local` |
| `PROD_BASE_IMAGE` | The full image identifier to use as the build foundation. | `${IMAGE_REGISTRY}/web-deploy-base:latest` |

See `https://github.com/rwgriffithv/web-deploy-env` for the default production base image.

### How to Override

To customize these values, set them in your local `.env` file or export them in your shell before launching the dev container:

```bash
# Example: Using a custom registry for your base images
export IMAGE_REGISTRY=ghcr.io/my-custom-org
# Rebuild the container in VS Code after setting these

```

### Resolution Logic

The build process resolves the base image using a chained fallback mechanism:

1. It first checks for an explicit `PROD_BASE_IMAGE`.
2. If unset or empty, it defaults to `${IMAGE_REGISTRY}/web-deploy-base:latest`.
3. If `IMAGE_REGISTRY` is also missing, it defaults to `local/web-deploy-base:latest`.

This allows for seamless local development while providing the flexibility to switch between different registry environments (e.g., local, staging, or production) without modifying the `Dockerfile`.

---

## Responsibilities

The base dev container is responsible for providing the shared runtime used by every project, including:

* a reproducible development container
* the OpenCode CLI
* connectivity to a locally running Ollama instance
* shared MCP server configuration
* the default OpenCode runtime configuration

Agent behavior is defined elsewhere in the `agent-dev-env` toolkit through the `rules/`, `skills/`, and `AGENTS.md` resources, which are linked into the consuming project during the bootstrap process.

Keeping the runtime separate from the agent's behavior allows the development environment and the agent toolkit to evolve independently.

---

## Customization

Changes made in this directory affect the runtime for every project using this toolkit.

Typical changes include:

* updating the base container image
* adding common development tools
* configuring shared MCP servers
* updating the default OpenCode configuration

Changes to coding standards, workflows, or agent behavior should instead be made in the toolkit's `rules/`, `skills/`, or `AGENTS.md` resources.
