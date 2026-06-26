# Git Workflow & Commit Standards

This project treats Git as a **production-grade audit system**, not just version control.

All commits must be intentional, traceable, and reproducible.

---

# 1. Pre-Commit Analysis (Mandatory)

Before creating any commit, you MUST explicitly inspect repository state.

## 1.1 Required Checks

Run and review:

- `git status` → determine staged vs unstaged changes
- `git diff --staged` → inspect exact commit contents

Never assume what is staged based on prior context or conversation history.

---

## 1.2 Code Validation

Before committing:

- ensure code compiles successfully
- ensure tests pass (if applicable)

Only allow broken builds if explicitly marked as:

> WIP (Work In Progress)

---

## 1.3 No Blind Commits

Do NOT commit:

- without inspecting staged diff
- without understanding file changes
- based solely on task completion assumptions

---

# 2. Conventional Commits Standard

All commits MUST follow the Conventional Commits specification:

```

type(scope): short imperative description

```

---

## 2.1 Allowed Types

- `feat` → new feature
- `fix` → bug fix
- `refactor` → structural code changes (no behavior change)
- `chore` → tooling, maintenance, dependencies, dev environment
- `docs` → documentation changes only
- `test` → test updates or additions
- `style` → formatting-only changes

---

## 2.2 Examples

Correct:

- `feat(auth): implement JWT refresh rotation`
- `fix(db): resolve SQLite connection timeout during startup`

Incorrect:

- `updated database logic`
- `fix bug`
- `stuff`

---

## 2.3 Message Quality Rule

Commit messages must:

- describe intent, not activity
- be imperative (“add”, “fix”, “remove”, “refactor”)
- be specific enough to understand impact without code inspection

---

# 3. Atomic Commits

Each commit must represent a single logical change.

## Rules:

- do NOT mix features and refactors in one commit
- do NOT combine formatting with logic changes
- avoid `git add .` unless changes are truly atomic

If multiple changes exist:

- split into separate staged commits
- isolate concerns using targeted `git add <file>`

---

# 4. Branching & Safety Rules

## 4.1 Protected Branches

Never use:

- `git push -f` on `main` or `master`

---

## 4.2 Safe Context Switching

If unsure or switching tasks:

- use `git stash` instead of temporary commits

---

## 4.3 History Correction Policy

If changes are already pushed:

- use `git revert`
- do NOT rewrite shared history with `reset --hard`

---

# 5. Core Principles

- Git history is a source of truth
- Every commit should be understandable in isolation
- History must remain stable and auditable
- Safety and traceability override convenience
