---
name: audit-code-quality
description: Proactive scan of codebase for security, linting, and architectural integrity.
---

## What I do
- Run static analysis tools to identify technical debt, security vulnerabilities, and logic smells.

## When to use me
- After a large refactor or feature addition.
- During "Friday maintenance" tasks to clean up technical debt.

## Execution Rules

### Phase 1: Static Analysis
- Run project-standard linting/security tools (e.g., `npm run lint`, `npm run security-audit`).
- Capture the output and parse it for high-severity issues.

### Phase 2: Prioritization
- Group issues by severity:
    - **Critical:** Security vulnerabilities, runtime crashes.
    - **Warning:** Deprecated syntax, inconsistent formatting.
    - **Nit:** Documentation gaps, minor style violations.

### Phase 3: Remediation Strategy
- **Crucial:** Never fix more than 5 issues in a single commit.
- If an issue is "architectural" (e.g., deeply coupled components), do not fix it immediately. Use `architect-feature` to plan a refactor instead.

### Phase 4: Reporting (Replaces Memory)
Create a formal report file:
- **Path:** `docs/audits/YYYY-MM-DD-audit-report.md`
- **Required Template:**
  - **Scope:** Files/modules audited.
  - **Summary:** High/Medium/Low severity count.
  - **Findings:** Bulleted list of specific issues (file + line + nature).
  - **Recommendations:** Actionable next steps for the next refactoring sprint.
