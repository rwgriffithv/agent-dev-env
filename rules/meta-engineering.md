# Meta-Engineering & Agent Self-Improvement

You are responsible for maintaining and improving the `agent-dev-env` repository — a shared infrastructure toolkit for AI-assisted software development.

This repository defines the shared agent runtime, capabilities, and baseline engineering standards used across multiple downstream projects via Git submodules.

Your goal is to evolve this system safely without breaking downstream compatibility or increasing setup complexity.

---

# 1. Core Responsibility

When modifying this repository, you must ensure:

- downstream projects remain functional after `git submodule update`
- bootstrap remains idempotent and non-destructive
- shared Skills remain reusable across projects
- shared Rules remain framework-agnostic and non-project-specific
- no increase in default context overhead for local LLM usage

Never introduce application-specific logic into this repository.

---

# 2. External Reference Material

When designing Skills or Rules, align with OpenCode’s official behavior:

- https://opencode.ai/docs/
- https://opencode.ai/docs/skills/
- https://opencode.ai/docs/rules/

Do not assume undocumented behavior. Prefer explicit, conservative implementations.

---

# 3. Skills (`skills/`)

Skills define reusable agent capabilities (SOPs) across repositories.

## Requirements

- must be self-contained
- must not assume downstream project structure
- must not encode business logic
- must follow OpenCode `SKILL.md` format
- must clearly define:
  - purpose
  - execution steps
  - validation criteria
  - completion condition

## Constraints

Skills are globally reusable and must remain stack-agnostic.

---

# 4. Rules System Architecture (IMPORTANT)

The Rules system is intentionally **two-layered with a routing gateway**.

## 4.1 Context Injection Model (OpenCode)

OpenCode is configured to load ONLY:

```text
AGENTS.md
agent-dev-env/rules/rules.md

No other rule files are directly injected.

This is a deliberate design choice to minimize context usage for local LLMs.

---

## 4.2 Rule Layers

### A. Shared Toolkit Rules

Located at:

```text
agent-dev-env/rules/*.md
```

These contain:

* scripting standards
* container standards
* bootstrap safety rules
* general engineering constraints

They are NOT directly loaded into model context.

They are accessed indirectly via the router.

---

### B. Project Rules

Located at:

```text
rules/*.md
```

These define:

* architecture decisions
* framework conventions
* project-specific constraints
* application behavior rules

These are also NOT directly loaded by default.

---

## 4.3 Routing Homepage (CRITICAL COMPONENT)

The file:

```text
agent-dev-env/rules/rules.md
```

is the **single routing entrypoint for all rule interpretation**.

It functions as:

* a context governor
* a rule selector policy
* a load-time efficiency layer for local models

### Responsibilities of `rules.md`:

* define when rules should be consulted
* instruct the agent to selectively load relevant rule files
* prevent full-rule mental loading
* resolve conflicts between shared vs project rules

It does NOT contain full rules itself.

It only defines **how and when to use rules**.

---

## 4.4 Rule Usage Principle

* Do NOT treat all rules as active at once
* Do NOT load all rule files mentally
* Only consult rules relevant to the current task

Rule system is a **selective retrieval mechanism**, not a flat prompt.

---

# 5. Infrastructure & Bootstrap Safety

If modifying:

* `.devcontainer/`
* `scripts/bootstrap.sh`
* `opencode.json`

you must ensure:

## Idempotency

* safe to run multiple times
* no duplicated configuration
* stable symlink state
* deterministic final result

## Non-Destructive Behavior

Never overwrite:

* downstream `rules/`
* `AGENTS.md`
* application source code
* secrets or environment variables

## Ownership Model

* `agent-dev-env/` → shared immutable toolkit
* `rules/` → project-owned logic
* `AGENTS.md` → project context
* `.opencode/skills` → shared capabilities (symlinked)

---

# 6. OpenCode Integration Constraint

OpenCode must remain explicitly configured:

```json
"instructions": [
  "AGENTS.md",
  "agent-dev-env/rules/rules.md"
]
```

No glob-based rule injection is required or recommended.

All additional rule discovery is delegated to `rules.md`.

---

# 7. Design Principle

This system is optimized for:

* minimal context injection
* local LLM efficiency (Ollama-class models)
* deterministic bootstrap behavior
* clean separation between:

  * global infrastructure logic
  * project-specific constraints

The rule system is intentionally **not monolithic**.

It is a **routed, selectively-applied constraint network**.
