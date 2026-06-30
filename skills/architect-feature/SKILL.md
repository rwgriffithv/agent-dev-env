---
name: architect-feature
description: High-level design and planning protocol for complex feature implementation.
---

## What I do
- Break down complex requirements into technical tasks.
- Enforce design consistency with project constraints.

## Execution Rules

### Phase 1: Design Phase
- Request the user's intent. Analyze requirements.
- Use `explore-code` to ensure the new architecture fits existing patterns (don't reinvent the wheel).
- Use `web-research` to search for external documentation or resources on the Internet about the APIs or functionality that may be used.

### Phase 2: Pattern Selection
- Choose a design pattern (e.g., Repository Pattern, Factory, HOC).
- **Justification:** Write a 3-sentence justification for why this approach is better than the alternative.

### Phase 3: The Blueprint
- Create a `docs/tmp/PLAN-<title>.md` file.
- Map out the files that need to be created or modified.
- List any `rules/*.md` that apply to this plan.

### Phase 4: Approval
- **Stop.** Present the `PLAN.md` to the user.
- **Requirement:** Do not generate code until the user approves the blueprint.


### Phase 5: Documentation (Replaces Memory)
Instead of saving to memory, generate:
- **Path:** `docs/architecture/YYYY-MM-DD-[feature-name].md`
- **Required Template:**
  - **Context:** Why we are building this.
  - **Design Decisions:** Trade-offs and patterns used (e.g., Factory, Observer).
  - **Blueprint:** Links to relevant files in `app/`.
  - **Compliance:** Checklist verifying this plan meets project `rules/`.
