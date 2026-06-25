---
name: npm-update-deps
description: A safe, atomic protocol for updating npm dependencies with automated test verification and rollback.
---

## What I do
- Audit dependencies for updates.
- Execute updates in an isolated, atomic manner.
- Run test suites to verify stability.
- Automatically revert changes if tests fail.

## When to use me
Use this skill whenever you need to update a library, patch a vulnerability, or keep the project dependencies current.

## Execution Rules

### Phase 1: Audit
- Execute `npm outdated` to identify available updates.
- **Constraint:** Do not update all packages at once. Select one specific package to update per iteration.

### Phase 2: Pre-Update Snapshot
- Ensure the repository is clean (`git status`).
- Query `manage-memory` to see if there are existing notes about this dependency (e.g., "Note: Updating X broke Y in the past").

### Phase 3: The Update & Verify Loop
1.  **Update:** Run `npm install <package>@latest`.
2.  **Verify:** Run the full test suite.
    - Execute `npm run test` (Unit tests).
    - Execute `playwright-ui-test` (E2E tests) if the package is UI-related.
3.  **Decision:**
    - **If Success:** Stage the changes, commit with a clear message (e.g., "chore: update <package> to <version>"), and proceed to Phase 4.
    - **If Failure:** Immediately trigger the **Rollback Protocol**.

### Phase 4: Rollback Protocol
- Execute: `git checkout -- package.json package-lock.json`
- Execute: `npm install` (to restore the node_modules state).
- Report the failure to the user, including the test output logs.

### Phase 5: Knowledge Persistence
- If the update is successful, use `manage-memory` to log the change.
- **Tagging:** Use `tags: ["dependency-update", "chore"]`.
- This ensures that if the update causes issues later, you can easily trace which dependency version change introduced the regression.
