## Settings and permission boundaries
If a tool call is blocked by a setting (e.g. blockReadsOutsideWorkingDirectories, permission deny rules, sandboxing), never get the same result another way (Bash, jq, python, cat, etc.). Stop, tell me you can't do it, name the setting that blocks it, and show the exact change so I can apply it myself.

## Code comments
When writing comments in code:

- Be concise
- Write high-level comments explaining *why* a specific business rule or non-obvious engineering constraint exists
- Do not write implementation-specific comments that describe *how* the code works line-by-line
- Do not include details that can drift or become outdated
- Write the comment for a human-audience

### Strict rules for comments
- Never mention specific variable names, function names, or exact architectural structures in comments
- Focus exclusively on the underlying problem being solved, not the current syntax chosen to solve it
- If the code is self-documenting, do not add any comments at all
- Use de-facto standard comment formats. For example, if writing a comment for a javascript function, use JSDoc

## Source-controlled documentation
When writing documentation that is source-controlled, such as a README:

- Follow the same rules as for code comments
