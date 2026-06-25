---
name: playwright-ui-test
description: Perform automated UI testing and interaction verification using Playwright.
---

## What I do
- Automate navigation, interaction, and state verification using the Playwright framework.
- Enforce rigorous testing of frontend changes to prevent visual regressions or "action-hallucination."

## When to use me
- After implementing a new feature in the UI.
- When debugging a reported interaction failure.
- To perform a "sanity check" of critical user flows (e.g., login, checkout).

## Execution Rules

### Phase 0: Environment Preparation
- **Server Readiness:** Ensure the local dev server is running. 
- **Memory Check:** Optionally query `manage-memory` to see if there are existing `TestIDs` or known flakiness associated with this component.

### Phase 1: Targeted Acquisition
- Navigate to the specific route.
- **Selector Strategy:** Always prioritize locators in this order:
    1. `getByTestId` (Best)
    2. `getByRole` (Good)
    3. `getByLabel` (Good for forms)
    4. `getByText` (Fallback)

### Phase 2: Action & Verification (The Anti-Hallucination Phase)
- **The Action:** Execute the interaction (e.g., `playwright.click({ selector: "..." })`).
- **The Assertion (CRITICAL):** Never assume the click succeeded. Immediately perform an assertion on the *post-action state*.
- If the expected change (e.g., updated text, visibility of new components) is not explicitly present in the DOM, the test is considered **Failed**.

### Phase 3: Cleanup
- Always close the browser context. Ensure the dev server process is left in a clean state.

### Phase 4: Knowledge Persistence
- If you encounter a complex selector or a non-obvious UI dependency, use `manage-memory` to save it.
- Tag as `tags: ["ui-test", "flaky-component", "selector-map"]`.
