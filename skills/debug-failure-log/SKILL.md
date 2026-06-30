---
name: debug-failure-log
description: Root cause analysis protocol for transforming runtime logs/stack traces into actionable code fixes.
---

## What I do
- Map runtime error traces to specific lines of code.
- Identify the "Blame" (last changed code) and "Blast Radius" (affected dependencies).

## Execution Rules

### Phase 1: Contextualization
- Use `manage-memory` to see if this error pattern (or similar logs) has been encountered previously.
- Extract the file path, line number, and function name from the stack trace.

### Phase 2: Analysis
- Use `explore-code` to read the offending file and its immediate dependencies.
- **Hypothesis Testing:** Formulate a theory: "Does this look like a null pointer, a race condition, or a configuration drift?"

### Phase 3: Verification (The "Repro")
- If the issue is complex, create a small reproduction script or if it is a webdev frontend issue use `playwright-ui-test` to trigger the specific error path.
- **Do not** attempt a fix until you have a reliable way to verify that the error occurs.

### Phase 4: Documentation (Replaces Memory)
Instead of saving to memory, create a file:
- **Path:** `docs/tmp/YYYY-MM-DD-[issue-summary]-post-mortem.md`
- **Required Template:**
  - **Issue:** Summary of the bug.
  - **Symptoms:** Logs/Stack traces.
  - **Root Cause:** Technical explanation.
  - **Fix:** Code block or description of the fix.
  - **Prevention:** Steps to avoid regression.
