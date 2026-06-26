# Container Development Standards

These rules define best practices for Dev Container and Docker-based development environments.

They ensure containers remain reproducible, minimal, and safe for AI-assisted development workflows.

---

# 1. User Identity

- Use a non-root user for all runtime operations.
- The standard user is `developer` (UID/GID 1000 where applicable).
- Root access should only be used during image build steps for installing system dependencies.

Avoid running development processes as root.

---

# 2. Minimal Base Images

- Prefer lightweight base images (e.g. `*-slim` variants).
- Install only required system dependencies.
- Avoid bundling tools that are not directly needed for runtime or development workflows.

Goal: keep images small, fast to build, and predictable.

---

# 3. Docker Layer Efficiency

- Combine `apt-get update` and `apt-get install` in a single `RUN` step.
- Clean package caches in the same layer:
  - `rm -rf /var/lib/apt/lists/*`

This reduces image size and improves build caching behavior.

---

# 4. Environment Variables

- Never hardcode secrets or environment-specific values in images.
- Use `devcontainer.json` with host bridging instead:

```json
"${localEnv:VARIABLE_NAME}"
```

* Assume secrets are injected from the host environment, not baked into images.

---

# 5. Standard Workspace Path

* Use `/workspaces/workspace` as the canonical working directory.
* All devcontainers must assume this as the project root unless explicitly overridden.

This ensures consistency across environments and tooling.

---

# 6. Guiding Principle

Containers should be:

* minimal
* reproducible
* non-secret-bearing
* consistent across all projects
* optimized for fast rebuild and iteration

They are not production deployments — they are **repeatable development substrates for AI-assisted coding systems**.
