---
name: review-claude-md
description: Review a change to any CLAUDE.md in this repo against its style checklist before committing. Use when editing one, or when asked to check/audit/review CLAUDE.md.
---

Apply this checklist to the target file, or to the diff if reviewing a
pending change. Check content before structure.

## Content

1. Delete sentences that only restate a nearby rule.
2. Flag vague or unverifiable language ("short enough to scan", "usually
   enough"). Replace with a concrete threshold.
3. Check whether a project convention interacts with a global rule (e.g. a
   commit subject prefix vs. a character limit) and state the interaction
   explicitly rather than leaving it implicit.
4. Check "the user"/"you" usage against the file's convention: the human
   author is "the user", the agent is "you". Flag any sentence that uses
   "I"/"me"/"my" for the author, or "you" for the author instead of the
   agent.

## Structure

5. Bullet a paragraph only if it's independent, parallel rules chained by
   "and"/"also". Keep prose for conditional or sequential logic (if X, then
   Y). Bulleting a procedure strips the if/then flow.

Note: reach for XML/schema tagging (`<constraints>`, `<instructions>`,
`<document>`) where it adds clarity. Skip it otherwise, and prefer
fixing the underlying problem with the Content checks above first.

<output_format>
For each candidate sentence, report which item it triggers and a proposed
rewrite, or note that it's intentionally left alone.
</output_format>
