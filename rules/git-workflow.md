# Git Workflow & Commit Standards

As an autonomous agent, maintaining a clean, readable, and trackable version control history is critical. You must treat Git operations with the same rigor as writing production code.

## 1. Pre-Commit Analysis (No Blind Commits)

Before generating a commit message or executing `git commit`:
*   **Check Status:** Always run `git status` to verify exactly which files are staged and unstaged.
*   **Analyze Diffs:** Always run `git diff --staged` to read the exact lines being committed. **Never guess or assume what is in the staging area based on recent conversation.**
*   **Test First:** Ensure all tests pass and the code compiles/builds successfully before committing. Broken code should only be committed if explicitly requested as a "WIP" (Work In Progress).

## 2. Conventional Commits Standard

All commit messages must strictly adhere to the Conventional Commits specification. This ensures automated release notes and semantic versioning tools function correctly.

**Format:**
`type(optional-scope): short imperative description`

**Allowed Types:**
*   `feat`: A new feature or capability.
*   `fix`: A bug fix.
*   `refactor`: A code change that neither fixes a bug nor adds a feature (e.g., renaming variables, extracting functions).
*   `chore`: Maintenance tasks, dependency updates, or changes to build/agent tooling (e.g., updating devcontainer scripts).
*   `docs`: Changes strictly to documentation (`README.md`, `rules/`, `AGENTS.md`).
*   `test`: Adding missing tests or correcting existing tests.
*   `style`: Formatting changes that do not affect the meaning of the code (whitespace, semicolons).

**Examples:**
*   *Correct:* `feat(auth): implement jwt token rotation`
*   *Correct:* `fix(db): resolve sqlite connection timeout on boot`
*   *Incorrect:* `updated the database`
*   *Incorrect:* `fix bug in auth`

## 3. Atomic Commits

*   Commit logical units of work. Do not mix formatting changes (`style`) with new features (`feat`) in the same commit.
*   If a task involves multiple distinct changes, use `git add <file>` to stage them separately and create multiple targeted commits rather than a single `git add .` dump.

## 4. Branching and Safety

*   **Never Force Push:** Do not use `git push -f` on the `main` or `master` branch.
*   **Stash When Unsure:** If you need to switch contexts or test something quickly without losing work, use `git stash` rather than creating a garbage commit. 
*   **Revert, Don't Rewrite:** If an error was already pushed to a remote repository, use `git revert` to undo it rather than attempting to rewrite history with `git reset --hard`.
