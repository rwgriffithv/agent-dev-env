---
name: debian-container-debug
description: Diagnose file permission, process, and networking issues inside a Debian container
---

## What I do
- Check running processes and port bindings.
- Diagnose file ownership and permission conflicts.
- Inspect system logs and network connectivity.

## When to use me
Use this skill when a web server fails to bind to a port, a script throws a "Permission Denied" error, or the application cannot resolve a localhost address.

## Execution Rules
1. **Port Checks:** Use `lsof -i :<PORT>` or `ss -lntu` to check if a required port is already in use.
2. **Permissions:** Use `ls -la` to verify that the `developer` user owns the relevant workspace files. If files are owned by `root`, alert the user.
3. **Process Logs:** If a background process (like a Next.js dev server) crashes, locate and tail the last 50 lines of its output log.
4. **Network:** If external fetching fails, use `ping -c 3 8.8.8.8` to verify container egress traffic before blaming the application code.
