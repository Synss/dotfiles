---
name: review-claude-md
description: Review a change to any CLAUDE.md in this repo against its style checklist before committing. Use when editing one, or when asked to check/audit/review CLAUDE.md.
---

Apply this checklist to the target file, or to the diff if reviewing a
pending change. Content first, structure second; check in order.

## Content

1. Delete sentences that only restate a nearby rule.
2. Flag vague or unverifiable language ("short enough to scan", "usually
   enough"). Replace with a concrete threshold.
3. Exception to the previous item: don't tighten intentional judgment calls
   ("non-obvious", "non-trivial", "reasonable", "simpler") unless asked — a
   fixed definition would misfire on half the cases they're meant to catch.
4. Check whether a project convention interacts with a global rule (e.g. a
   commit subject prefix vs. a character limit) and state the interaction
   explicitly rather than leaving it implicit.

## Structure

5. Bullet a paragraph only if it's independent, parallel rules chained by
   "and"/"also". Keep prose for conditional or sequential logic (if X, then
   Y) — bulleting a procedure strips the if/then flow.

Note: treat XML/schema tagging (`<constraints>`, `<instructions>`,
`<document>`) as optional polish, not a default — it targets prompts
assembled once per API call, not a file reread and edited by topic. Reach
for it only if the Content checks above don't fix the actual problem.

<output_format>
For each candidate sentence, report which item it triggers and a proposed
rewrite, or note that it's intentionally left alone (the judgment-call
exception above).
</output_format>
