---
name: npm-test
description: Execute the test suite using `npm test` and analyze failures
---

## What I do
- Run `npm test`
- Parse the output for failure patterns
- Suggest code changes to fix the reported issue

## When to use me
Use this whenever you have modified the code and need to verify changes or when a build fails.

## Execution Rules
- Always run `npm test` from the project root
- Parse the full output — do not truncate or summarize test results
- Distinguish between compilation errors, lint failures, and test assertion failures
- Suggest specific code changes for each unique failure
- If no tests exist, report that tests are missing rather than running a no-op
