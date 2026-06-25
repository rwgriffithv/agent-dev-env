# MCP Etiquette & Usage Guidelines

As an agent equipped with Model Context Protocol (MCP) tools, you must interact with external systems, networks, and databases efficiently. Your context window is a limited, highly valuable resource — protect it.

## 1. Tool Selection Hierarchy

Before executing any command, determine the least expensive and most accurate path to the answer:

*   **Local State (`memory`, `sqlite`):** Use these first to understand the current project context, previous decisions, and data structures.
*   **External Discovery (`brave-search`):** Use this to find official documentation, recent API changes, or solutions to specific errors.
*   **Targeted Reading (`web-fetch`):** Use this *only* after identifying a specific, high-value URL. Do not blindly fetch root domains or massive index pages.
*   **Validation (`playwright`):** Use this as the final step to verify UI rendering or complex interactions only *after* code is written and the server is running.

## 2. Search and Fetch Protocol (The "Look Before You Leap" Rule)

When you lack information about a library or API, follow this exact sequence:

1.  **Formulate a specific search query:** e.g., "Next.js App Router SQLite integration example".
2.  **Analyze search results:** Identify the most relevant, official documentation URL.
3.  **Fetch with precision:** Use the `web-fetch` tool on that exact URL. 
4.  **Extract, don't dump:** Do not dump raw HTML, massive JSON payloads, or entire documentation pages into your output. Extract the required syntax, summarize the solution internally, and proceed with the task.

## 3. Database Safety (`sqlite`)

*   **Schema First:** Always inspect the schema before writing a `SELECT` query.
*   **Limit Output:** Always append `LIMIT 10` to exploratory queries to prevent context overflow.
*   **Verify Before Mutating:** Never execute a state-changing query (`UPDATE`, `DELETE`, `DROP`) without explicitly confirming the exact target rows via a prior `SELECT` statement.

## 4. Error Handling and Fallbacks

If an MCP tool fails, times out, or returns a 404/500 error:

*   **No Infinite Loops:** Do not blindly retry the exact same command.
*   **Pivot:** Adjust your parameters (e.g., broaden the search query, check the URL path, simplify the SQL query).
*   **Graceful Exit:** If a tool consistently fails, inform the user immediately and suggest a manual workaround rather than guessing the syntax.
