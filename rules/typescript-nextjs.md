# TypeScript & Next.js (App Router) Standards

This project utilizes Next.js with the App Router, strict TypeScript, and a local SQLite database. You must adhere to modern Next.js paradigms and strictly typed data flows.

## 1. Next.js App Router Architecture

*   **Server-First Default:** All components are Server Components by default. Do not add `"use client"` unless the component explicitly requires state (`useState`), lifecycle effects (`useEffect`), or browser-only APIs (like window event listeners).
*   **Push Client Components Down:** Keep `"use client"` boundaries as low in the component tree as possible (leaf nodes). Pass static data down from Server Components as props.
*   **Colocation:** Keep route-specific components, styles, and tests close to the route they belong to. Use the `app/` directory for routing (`page.tsx`, `layout.tsx`, `route.ts`), and keep shared UI components in a root `components/` directory.

## 2. Data Mutation & Server Actions

*   **No API Routes for UI Mutations:** Prefer Next.js Server Actions over building traditional `/api/` endpoints when mutating data from the frontend.
*   **Action Placement:** Define Server Actions in a separate file with `"use server"` at the top (e.g., `actions.ts`), and import them into Client Components.
*   **Revalidation:** Always use `revalidatePath` or `revalidateTag` inside Server Actions after mutating database state to ensure the UI updates instantly.

## 3. SQLite Database Access

*   **Server-Side Only:** Database queries must *only* occur within Server Components, Route Handlers, or Server Actions. Never leak database instances or queries into Client Components.
*   **Type-Safe Queries:** Ensure the output of your SQLite queries is cast to a strict TypeScript interface representing the database row.
*   **Security:** Always use parameterized queries or an ORM/query builder to prevent SQL injection. Never concatenate raw strings for SQL execution.

## 4. TypeScript Strictness

*   **Zero `any` Tolerance:** The use of `any` is strictly prohibited. If a type is unknown at runtime, use `unknown` and perform type narrowing/checking.
*   **Explicit Return Types:** All Server Actions, Route Handlers, and complex utility functions must have explicit return types.
*   **Interfaces vs Types:** Use `interface` for object shapes and component props. Use `type` for unions, intersections, and utility types.
*   **Prop Typing:** Always define a dedicated `interface` for component props (e.g., `interface ButtonProps { ... }`) rather than inline typing.

## 5. Error Handling

*   Use `error.tsx` boundaries to gracefully catch server errors in the App Router.
*   For Server Actions, return a standardized result object (e.g., `{ success: boolean; data?: T; error?: string }`) rather than throwing raw HTTP exceptions back to the client.
