---
name: manage-memory
description: Manage the lifecycle of project knowledge; store only high-value, durable information.
---

## What I do
- Perform targeted retrieval of past decisions or research.
- Curate the knowledge base by evaluating if new information is "durable."

## Execution Rules

### Phase 1: Storage Policy (Crucial)
Before saving to memory, verify the information meets the **"Durable Knowledge"** criteria:
- **Architectural Decisions:** Why a tool/pattern was chosen.
- **Hard-won insights:** Complex debugging results.
- **Complex Patterns:** Custom configurations or non-obvious logic.
- **Avoid:** Transient search results (e.g., "what is the syntax for map?")—keep the memory signal high.

### Phase 2: Operations
- **Search:** `memory.search({ query: "..." })`
- **Store:** `memory.add({ topic: "...", content: "...", tags: [...] })`
- **Prune:** Use `memory.delete({ id: "..." })` to remove stale information.

### Phase 3: Metadata Standards
Always include tags (e.g., `tags: ["architecture", "nextjs"]`) and, for code research, include the `commit_hash` so we can verify if the memory is stale later.
