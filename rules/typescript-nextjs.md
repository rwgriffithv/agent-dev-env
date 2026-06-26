# TypeScript & Next.js (App Router) Standards

This project uses Next.js App Router with strict TypeScript and a local SQLite database.

All code must follow modern App Router conventions and strictly typed data flows.

---

# 1. Next.js App Router Architecture

## 1.1 Server-First Default

All components are Server Components by default.

Do NOT use `"use client"` unless required for:

- React state (`useState`)
- lifecycle effects (`useEffect`)
- browser-only APIs (e.g. `window`, event listeners)

---

## 1.2 Client Component Boundaries

- `"use client"` must be pushed as low as possible in the component tree
- Prefer leaf-level client components
- Server Components should pass static data via props

Avoid converting entire routes into client components.

---

## 1.3 Colocation

Keep related code close to its route:

- `app/` → routing (`page.tsx`, `layout.tsx`, `route.ts`)
- `components/` → shared UI components
- route-specific components, styles, and tests should be colocated where practical

---

# 2. Data Mutation & Server Actions

## 2.1 Server Actions Preferred

Prefer Server Actions over API routes for UI-driven mutations.

Do NOT use `/api/` routes unless required for:

- external system integration
- non-Next.js clients

---

## 2.2 Action Placement

- Server Actions must include `"use server"`
- Place them in dedicated modules (e.g. `actions.ts`)
- Import into Client Components when needed

---

## 2.3 Revalidation

After any mutation:

- use `revalidatePath()` or `revalidateTag()`
- ensure UI reflects updated database state immediately

Never rely on manual refresh for correctness.

---

# 3. SQLite Database Access

## 3.1 Server-Side Only

Database access is restricted to:

- Server Components
- Route Handlers
- Server Actions

Never access SQLite from Client Components.

---

## 3.2 Type-Safe Queries

- Query results must be cast to a strict TypeScript interface
- Each table row should have a corresponding type definition

---

## 3.3 Security

- Always use parameterized queries or a safe query builder
- Never concatenate raw SQL strings
- Treat all external input as untrusted

---

# 4. TypeScript Strictness

## 4.1 No `any`

- `any` is strictly forbidden
- Use `unknown` + type narrowing when needed

---

## 4.2 Explicit Return Types

Must explicitly type:

- Server Actions
- Route Handlers
- complex utility functions

---

## 4.3 Interfaces vs Types

- `interface` → object shapes (props, DB rows, entities)
- `type` → unions, intersections, utility types

---

## 4.4 Props Typing

Always define a named interface for component props:

```ts id="props-example"
interface ButtonProps {
  label: string;
}
```

Avoid inline prop definitions.

---

# 5. Error Handling

## 5.1 UI Error Boundaries

Use:

* `error.tsx` for route-level errors
* `not-found.tsx` where applicable

---

## 5.2 Server Action Responses

Server Actions should return structured results:

```ts id="action-response"
{
  success: boolean;
  data?: T;
  error?: string;
}
```

Do NOT throw raw errors directly to the client.

---

# 6. Core Principles

* Server-first architecture by default
* Minimal client-side execution
* Strict TypeScript everywhere
* Database access only on the server
* UI reflects server state via revalidation
