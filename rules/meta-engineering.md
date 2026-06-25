# Meta-Engineering & Agent Self-Improvement

As an agent maintaining the `agent-dev-env` meta-repository, you are responsible for upgrading your own logic, rules, and skills. When creating or modifying the environment's configuration, you must follow strict formatting and architectural constraints to ensure downstream compatibility.

## 1. Reference Material
Always verify your implementation against the official OpenCode documentation:
- **Core Docs:** [https://opencode.ai/docs/](https://opencode.ai/docs/)
- **Skills Architecture:** [https://opencode.ai/docs/skills/](https://opencode.ai/docs/skills/)
- **Rules & Context:** [https://opencode.ai/docs/rules/](https://opencode.ai/docs/rules/)

## 2. Skill Development (`skills/`)
When creating a new skill, it must be discoverable by the OpenCode CLI natively.

*   **Directory & Naming:** Create a new directory under `skills/` using lowercase alphanumeric characters and single hyphens.
*   **The Definition File:** The logic must be contained in a `SKILL.md` file inside that directory.
*   **Required Frontmatter:** Every `SKILL.md` must start with exact YAML frontmatter. See [official skills docs](https://opencode.ai/docs/skills/) for required fields like `name` and `description`.
*   **Skill Structure:** Use clear headers (`## What I do`, `## When to use me`, `## Execution Rules`) to outline the standard operating procedure (SOP).

## 3. Rule Development (`rules/`)
When modifying static context guidelines that govern agent behavior:

*   **No Overlap:** Before creating a new rule, ensure you are not duplicating or contradicting existing logic.
*   **No Frontmatter:** Unlike Skills, Rule files (`*.md`) are concatenated directly into the context window. Do not use YAML frontmatter in rule files.
*   **Conciseness:** Use bullet points, bold keywords, and short sentences. Avoid conversational filler.
*   **Modular Scope:** A rule file should cover exactly one domain. See [official rules docs](https://opencode.ai/docs/rules/) for best practices on context management.

## 4. Infrastructure & Template Safety
If your task involves modifying `.devcontainer/` templates or `scripts/bootstrap.sh`:

*   **Idempotency:** Any script you write or modify must be safe to run multiple times without corrupting state or appending duplicate data.
*   **Backward Compatibility:** Downstream projects rely on the structure of `agent-dev-env`. Do not rename critical directories or bootstrap arguments without updating the global `README.md`.
*   **Tooling Transparency:** If you add a new CLI dependency to the `Dockerfile`, document it in the template's README so developers know the tool is available.
