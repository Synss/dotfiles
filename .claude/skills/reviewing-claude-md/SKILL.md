---
name: reviewing-claude-md
description: Use when editing or reviewing a change to any CLAUDE.md in this repo, or when asked to check/audit/review one.
---

Check the target file (or diff) against each rule below. Report what rule
it triggers and a proposed fix, or note that the rule doesn't apply. Check
content rules before structure rules.

## Content

1. No sentence may only restate a nearby rule.
2. No vague or unverifiable language (e.g. "short enough to scan", "usually
   enough"). Replace with a concrete threshold.
3. Where a project convention interacts with a global rule (e.g. a commit
   subject prefix vs. a character limit), state the interaction explicitly.
4. "The user" names the human author; "you" names the agent. Never use
   "I"/"me"/"my" for the author, or "you" for the author instead of the agent.

## Structure

5. Use plain bullets only for independent, parallel items chained by
   "and"/"also". A sequence or a conditional procedure needs a numbered list
   or prose — never plain bullets carrying order words like "then"/"finally"
   that the marker itself doesn't express.
6. Add XML/schema tagging (`<constraints>`, `<instructions>`, `<document>`)
   if it adds clarity that a Content fix above can't. Otherwise leave the
   file untagged.

<output_format>
For each finding, report which rule it triggers and a proposed fix, or note
that it's intentionally left alone.
</output_format>
