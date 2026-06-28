---
name: manage-memory
description: Manage the project Knowledge Graph; create associative links between concepts, code, and decisions.
---

## What I do
- Build a map of "how things connect" in the project.
- Query the graph to find non-obvious relationships.
- Curate high-level connections to speed up agent decision-making.

## When to use me
- **Use Documentation (`docs/`)** for: Definitive technical specs, post-mortems, architectural blueprints, and human-readable onboarding guides.
- **Use Memory (Graph):** For connecting the dots. (e.g., "Note that this file affects that API," "This variable naming convention is related to that project rule," "We tried this fix and it failed").

## Execution Rules

### Phase 1: Relationship Mapping (Crucial)
Never save an isolated fact. Always define the relationship:
- **`memory.add({ node: "...", relation: "...", target: "..." })`**
- Example: `add({ node: "Stripe", relation: "CAUSES_ISSUES_IN", target: "CheckoutModule" })`

### Phase 2: Retrieval Strategy
- Use `memory.search()` to perform graph traversals:
    - "What is connected to this bug?"
    - "Does this file have any documented dependencies elsewhere?"
- If the agent needs to explain *why* something is the way it is, it should pull from `docs/` first. If it needs to know *what else* this change will impact, it should query the graph.

### Phase 3: Lifecycle
- **Connect:** If you add a new route, connect it to its relevant test file and documentation file.
- **Update:** If an architectural decision changes, delete the old relationship and add the new one.
- **Persistence:** This graph persists across sessions. It is the agent's "Project Intuition."
