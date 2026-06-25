# Scripting & Automation Standards

When writing or modifying Bash scripts:

1. **Safety**: Every script must start with `set -e` to ensure the script exits immediately if any command fails.
2. **Idempotency**: Scripts must be idempotent. If a script creates a directory or symlink, it should check if it exists first or safely remove/overwrite it.
3. **Portability**: Use `#!/bin/bash` with POSIX-compliant syntax where possible. Avoid Linux-specific utilities if a BSD/cross-platform equivalent exists, unless the environment is strictly defined as Debian-based.
4. **Error Handling**: Provide clear, descriptive error messages to `stderr` (`>&2`) when a script fails.
5. **Permission Hygiene**: Always apply appropriate permissions (`chmod +x`) immediately after creating a new executable or script file.
