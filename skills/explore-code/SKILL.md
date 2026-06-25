---
name: explore-code
description: Research and verify concepts across documentation and source code in the repository.
---

## What I do
- Map out directory structures, trace dependencies, and verify implementation details.
- Provide a structured workflow to answer "how" or "why" questions about the internal codebase.

## When to use me
Use this skill to locate implementations, understand dependency chains, or verify code patterns.

## Execution Rules

### Phase 0: Memory Consideration (Optional)
- Only query `manage-memory` if you believe the file locations or architectural context have been documented previously.

### Phase 1: Dual-Source Discovery (The Toolkit)
- **Docs:** `find . -type f \( -name "*README*" -o -name "*docs*" -o -name "*.md" \) -not -path "*/node_modules/*"`
- **Code:** `grep -rI --include=*.{ts,tsx,js} "pattern" .`
- **Constraint:** Do not guess file locations. Use the output of `find` or `grep`.

### Phase 2: Contextual Analysis
- Execute `read({ file: "..." })` on identified files.
- **Cross-Reference:** Check if the directory has associated `rules/` files. Apply those standards to your analysis.

### Phase 3: Synthesis
- Provide a summary. **Validation:** Explicitly state if you found discrepancies between the documentation and the code implementation.

### Phase 4: Knowledge Persistence
- If the finding is "Durable Knowledge", use `manage-memory` to store it with a `commit_hash` for future freshness verification.
