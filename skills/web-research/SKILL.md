---
name: web-research
description: Conduct web research and synthesize external documentation using Brave Search and Web Fetch.
---

## What I do
- Execute a structured discovery and synthesis protocol for external web content.
- Verify findings against project rules to ensure they align with your architectural standards.

## When to use me
Use this skill whenever you need external information, library documentation, or API details that are not present in your local codebase.

## Execution Rules

### Phase 0: Memory Consideration (Optional)
- **Do not** automatically query memory.
- Only query `manage-memory` if the task involves complex library integration that you suspect you have solved before.

### Phase 1: Targeted Discovery
- Execute `brave-search({ query: "..." })`.
- **Constraint:** Use hyper-specific queries. Prioritize official documentation (docs.*, github.com, official blogs).

### Phase 2: Precise Extraction
- Execute `web-fetch({ url: "..." })` only on authoritative URLs.
- **Constraint:** Do not fetch more than 3 distinct URLs. Filter to extract only technical patterns/syntax; ignore HTML/CSS bloat.

### Phase 3: Synthesis & Local Validation
- Write a summary of findings.
- **Rule Cross-Reference:** Compare findings against `rules/`. If research conflicts with local standards, explicitly highlight the discrepancy.

### Phase 4: Knowledge Persistence
- If the research outcome is "Durable Knowledge" (see `manage-memory`), suggest a save to the user.
