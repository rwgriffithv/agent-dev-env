# Container Development Standards

When modifying `Dockerfile` or `devcontainer.json`:

1. **User Identity**: Always utilize the `developer` user profile with UID/GID 1000. Never run as `root` unless explicitly necessary for package installation.
2. **Minimization**: Favor `*-slim` base images (e.g., `node:22-bookworm-slim`). Only install packages that are strictly necessary for the environment to function.
3. **Layer Caching**: Group `apt-get update` with `apt-get install` and a cache-cleaning step in a single `RUN` command to reduce image layer size.
4. **Environment Isolation**: Never hardcode environment variables that should be secret (e.g., API keys). Always use `${localEnv:...}` in `devcontainer.json` to bridge host environment variables.
5. **Pathing**: Use `/workspaces/workspace` as the standard project root for all devcontainers.
