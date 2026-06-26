# Documentation Standards

These rules define how documentation (README files, template guides, setup instructions) should be written and maintained.

Documentation is a critical part of the developer experience and must prioritize clarity, reproducibility, and fast onboarding.

---

# 1. User-Centric Structure

All documentation must answer:

> “How do I start?”

This must appear within the first sections of any README or setup guide.

Users should not need to read background or architecture details before getting started.

---

# 2. Quick Start First

Every primary documentation file must include a **Quick Start path**:

- minimal steps to get running
- no conceptual explanation required
- assumes zero prior context

This section should be executable as-is.

---

# 3. Copy-Paste Examples

All documentation must include:

- copy-pasteable code blocks
- real commands (not pseudocode)
- complete examples for common workflows

Examples include:

- project bootstrap
- environment setup
- devcontainer launch
- CLI usage

Partial snippets should be avoided unless explicitly necessary.

---

# 4. Environment Clarity

Documentation must clearly distinguish between:

- Host machine steps
- Container / runtime steps

Never mix these contexts without explicit labeling.

If Dev Containers are used:

- explicitly state what runs on host vs container
- avoid ambiguity in setup flow

---

# 5. Structural Consistency

All documentation must align with the expected repository structure:

- `/workspaces/workspace` → standard working directory inside containers
- `.devcontainer/` → container configuration
- `agent-dev-env/` → shared tooling (if applicable)

Do not introduce alternative canonical paths unless explicitly required.

---

# 6. Simplicity Principle

Documentation must:

- avoid unnecessary explanation before usage steps
- prioritize actionable instructions over theory
- minimize cognitive load for first-time users

If a detail is not required to run the system, it should be moved to later sections.

---

# 7. Core Principle

Documentation exists to make systems immediately usable.

Not to explain them first.
