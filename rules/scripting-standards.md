# Scripting & Automation Standards

This document defines general best practices for writing reliable Bash scripts in any environment that uses AI-assisted or automated development workflows.

These standards apply to all scripts intended for automation, infrastructure management, or development tooling.

---

# 1. Safety First

All scripts must begin with:

```bash
set -euo pipefail
```

This ensures:

* immediate failure on errors
* prevention of undefined variables
* safer pipeline execution

Scripts must never silently ignore failures.

---

# 2. Idempotency (Critical Requirement)

Scripts must be safe to run multiple times without causing unintended side effects.

They must:

* not duplicate files, symlinks, or configuration
* not corrupt existing state
* converge toward a stable final state

When modifying filesystem state:

* check existence before creating resources
* overwrite explicitly and safely when necessary
* prefer `ln -sfn` for symlinks
* avoid unconditional `rm -rf` unless explicitly guarded

Idempotency ensures scripts are safe in CI, containers, and bootstrap environments.

---

# 3. Non-Destructive Behavior

Scripts must never permanently destroy or silently overwrite important data.

Avoid modifying without explicit intent:

* project source code
* configuration files
* environment variables or secrets
* user-managed directories

If destructive operations are required:

* require explicit confirmation or flags
* log clearly what will be removed or replaced
* prefer backup-before-replace patterns

---

# 4. Environment Assumptions & Portability

Assume a Linux-like environment unless explicitly stated otherwise.

Guidelines:

* Use `#!/usr/bin/env bash` or `#!/bin/bash`
* Prefer POSIX-compatible constructs where reasonable
* Avoid platform-specific utilities unless required
* Assume standard GNU coreutils are available in development environments

Do not over-optimize for portability unless needed.

---

# 5. Error Handling & Observability

Scripts must provide clear and actionable feedback.

* Use descriptive `echo` messages for major steps
* Send error messages to `stderr` (`>&2`) when appropriate
* Avoid silent failures or suppressed errors

Example:

```bash
echo "❌ Operation failed: unable to create directory" >&2
```

---

# 6. Permissions & Executables

When creating or modifying executable scripts:

* ensure correct permissions using `chmod +x`
* do not assume Git preserves executable flags across environments
* explicitly set permissions when generating scripts in automation

---

# 7. Filesystem Operations

All filesystem operations must be deterministic and explicit.

Guidelines:

* prefer explicit paths over relative assumptions
* avoid hidden side effects or implicit state changes
* avoid recursive deletions unless strictly required and guarded

For symlinks:

* prefer `ln -sfn` for safe replacement behavior
* verify target paths before linking when possible

---

# 8. Logging & Readability

Scripts should be readable during execution.

Recommended practices:

* prefix major steps with clear markers (`🚀`, `✓`, `❌`)
* group operations into labeled sections for complex scripts
* avoid overly compressed one-liners for critical logic
* ensure output is understandable without reading the source

---

# 9. Bootstrap & Automation Safety

In automated environments (CI, containers, dev tooling):

* scripts must remain backward-compatible when possible
* changes should be additive rather than breaking
* avoid assumptions about prior state unless explicitly validated

---

# 10. Core Principle

Scripts should behave as:

> deterministic transformations from an unknown state → a known good state

They must be safe to run in development, CI, and automated bootstrap environments without requiring manual intervention.
