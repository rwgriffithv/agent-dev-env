# Rule Loading & Context Routing Policy

This file defines how rules should be interpreted in this system.

Its purpose is to reduce context overload by ensuring rules are applied selectively rather than treated as a single always-on prompt.

---

# 1. Core Principle

Rules are not a flat checklist.

They are a **retrieval system for reasoning constraints**.

Do NOT treat all rule files as simultaneously active.

Instead, only apply rules relevant to the current task.

---

# 2. Rule Sources

There are two rule sources:

## A. Shared Toolkit Rules
`agent-dev-env/rules/*.md`

- baseline engineering standards
- scripting and infrastructure safety
- general development practices

Stable and reusable across projects.

---

## B. Project Rules
`rules/*.md`

- architecture decisions
- framework conventions
- project-specific constraints
- domain or application logic

These take precedence over shared rules when applicable.

---

# 3. Rule Usage Policy

## 3.1 No global rule activation

Do not mentally load all rules at once.

This causes:

- context overload
- conflicting instructions
- reduced reasoning quality

Only apply relevant rules for the task at hand.

---

## 3.2 Rule selection

When working:

1. Identify task type:
   - automation / scripting
   - architecture / design
   - feature work
   - debugging
   - refactoring

2. Select relevant rules:
   - use `agent-dev-env/rules/` for infrastructure/tooling tasks
   - use `rules/` for application and architecture tasks

3. Ignore unrelated rules for the current task
