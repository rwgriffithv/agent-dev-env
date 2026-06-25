---
name: api-curl-test
description: Safely construct, execute, and parse API requests using curl
---

## What I do
- Standardize `curl` commands for testing REST APIs.
- Ensure proper headers (e.g., `Content-Type: application/json`) are always included.
- Pipe output through `jq` for readable JSON parsing.

## When to use me
Use this skill when you need to test a local endpoint, verify an external API response, or debug network connectivity issues. 

## Execution Rules
1. **Never** hardcode sensitive API keys directly in the terminal command. Assume they are in the environment (e.g., `$API_KEY`).
2. Always use the `-s` (silent) flag with `curl` to suppress progress meters.
3. Always pipe JSON responses to `jq '.'` to format the output for easier reading.
4. If testing a POST/PUT request, explicitly write out the JSON payload structure before executing the command.
