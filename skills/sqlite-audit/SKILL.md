---
name: sqlite-audit
description: Safely inspect and query SQLite databases without causing data loss
---

## What I do
- Provide a strict protocol for exploring database schemas.
- Prevent destructive queries (DROP, DELETE) during exploration.
- Limit query results to prevent context window overflow.

## When to use me
Use this skill when you need to understand the shape of the data, debug a failing database migration, or verify that an application write was successful.

## Execution Rules
1. **Schema First:** Before writing any `SELECT` queries, always use the SQLite MCP to pull the schema of the relevant tables.
2. **Limit Results:** Always append `LIMIT 10` to any exploratory `SELECT` query. Never dump a full table into the context window.
3. **Read-Only:** Unless explicitly authorized by the user, treat the database as read-only. 
4. **Validation:** If you are asked to verify a data insertion, query the exact ID or use an `ORDER BY created_at DESC LIMIT 1` to confirm the state.
