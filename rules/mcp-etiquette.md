# MCP Etiquette & Tool Usage Guidelines

This document defines how to efficiently use MCP tools (memory, sqlite, search, web-fetch, playwright).

MCP tools are external system calls and must be used deliberately to minimize cost, latency, and context usage.

---

# 1. Tool Selection Priority

Before using any MCP tool, consider whether a higher-level **Skill** already solves the problem.

## 0. Skills (Highest Priority)

If a relevant Skill exists:

- prefer executing the Skill first
- Skills may internally use MCP tools
- do NOT manually re-implement Skill workflows unless necessary

Skills are the primary orchestration layer over MCP tools.

---

## 1. Local State (Preferred fallback)
- `memory`
- `sqlite`

Use when:
- required information already exists in system memory or database
- continuing prior work

---

## 2. External Discovery
- `brave-search`

Use when:
- information is not available locally
- documentation or external references are needed

Prefer precise queries.

---

## 3. Targeted Retrieval
- `web-fetch`

Use ONLY when:
- a specific URL is already identified

Do NOT:
- fetch entire domains
- crawl multiple pages
- retrieve large unfiltered content

---

## 4. Execution / Validation
- `playwright`

Use only when:
- UI must be validated
- frontend behavior must be verified
- application is already running

Do NOT use for speculation.

---

# 2. Standard Workflow (Preferred Pattern)

When information is missing:

1. Check if a relevant **Skill** exists → use it if available
2. Use `brave-search` for precise discovery if needed
3. Select a single authoritative URL
4. Use `web-fetch` on that URL
5. Extract only required information
6. Proceed with implementation

Do not skip directly to raw tool usage when Skills exist.

---

# 3. SQLite Safety Rules

When using `sqlite`:

## 3.1 Schema Awareness
Always inspect schema before querying.

## 3.2 Read Queries
- Use `LIMIT 10` for exploratory queries
- Avoid unbounded outputs

## 3.3 Write Safety
Before executing:
- `UPDATE`
- `DELETE`
- `DROP`

You must:
1. run a `SELECT` to confirm target rows
2. verify impact
3. only then execute mutation

Never assume state.

---

# 4. Search Discipline

When using `brave-search`:

- prefer specific queries over generic ones
- include version/framework context when relevant
- avoid repeating identical queries

If results are unclear:
- refine query instead of repeating
- narrow scope before expanding

---

# 5. Error Handling & Recovery

If an MCP tool fails:

- do NOT retry identical calls repeatedly
- adjust one variable at a time (query, endpoint, parameters)
- switch tools if appropriate

If failure persists:

- stop automation
- explain the issue
- propose a manual fallback

Do not hallucinate tool outputs.

---

# 6. Core Principle

MCP tools are **expensive external system calls**.

Skills are the preferred abstraction layer over MCP tools.

Every tool call must be:
- purposeful
- minimal in scope
- predictable in output
