---
name: scaffold-nextjs-route
description: Standardized SOP for scaffolding new Next.js App Router features, pages, and routes.
---

## What I do
- Generate consistent boilerplate for new Next.js routes.
- Enforce project-wide standards for metadata, testing, and documentation upon creation.

## When to use me
Use this skill whenever you are tasked with creating a new route or page within the `app/` directory.

## Execution Rules

### Phase 1: Route Discovery
- Check existing `app/` structure to ensure the route path does not already exist.
- If unsure of the existing path mapping, use `explore-code` to list current routes.

### Phase 2: Scaffolding (The Checklist)
Execute the following steps in order:
1.  **Component Creation:** Create `app/<route>/page.tsx`. Ensure it is a `Server Component` by default (no `"use client"` unless strictly necessary).
2.  **Metadata:** Add the required SEO/Head metadata:
    ```typescript
    export const metadata = { title: "...", description: "..." };
    ```
3.  **Testing:** Create `app/<route>/page.test.tsx` (or `app/<route>/page.spec.tsx`). At minimum, add a test that verifies the page component renders without crashing.
4.  **Error Boundaries:** (Optional but recommended) If the route handles sensitive data, create a `loading.tsx` or `error.tsx` file in the same directory.

### Phase 3: Documentation
- Update `app/README.md` or the relevant `docs/` file to register the new route, its purpose, and its access permissions.

### Phase 4: Knowledge Persistence
- Use `manage-memory` to register the new route's existence and its primary responsibility.
- **Tagging:** Use `tags: ["nextjs-route", "feature-scaffold", "documented"]`.
