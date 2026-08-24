---
name: reviewing-claude-md
description: Use when editing or reviewing a change to any CLAUDE.md in this repo, or when asked to check/audit/review one.
---

Check the target file (or diff) against each rule below, content rules
before structure rules.

## Content

1. No sentence may only restate a nearby rule.
2. No vague or unverifiable language (e.g. "short enough to scan", "usually
   enough"). Replace with a concrete threshold.
3. Check every project requirement against every global constraint, not
   only ones sharing an obvious keyword (e.g. a required signature block
   vs. a line-count limit, not just a subject prefix vs. a character
   limit) or the same kind of constraint (e.g. an "always"/"never"
   project requirement silently flipping a global rule's
   optional/mandatory status). State any interaction explicitly.
4. "The user" names the human author; "you" names the agent. Never use
   "I"/"me"/"my" for the author, or "you" for the author instead of the agent.

## Structure

5. Group a section's paragraphs by topic. Don't let a paragraph on a
   different topic sit between two paragraphs on the same one — merge or
   reorder so they're adjacent.
6. Use plain bullets only for independent, parallel items chained by
   "and"/"also". A sequence or a conditional procedure needs a numbered list
   or prose — never plain bullets carrying order words like "then"/"finally"
   that the marker itself doesn't express.
7. Add XML/schema tagging (`<constraints>`, `<instructions>`, `<document>`)
   if it adds clarity that a Content fix above can't. Otherwise leave the
   file untagged.

## Output format

<output_format>
Report one entry per rule, in rule order, regardless of status. Check
each rule independently against the whole file — a sentence that trips
multiple rules must be cited under every rule it trips, not folded into
the most salient one. Each entry is a numbered list of instances, even
when there's only one:

Rule N — <triggered|not_applicable|left_alone>
1. quote: "<exact text>" (line L)
   detail: <why it triggers / what's missing / why it's left alone>
   fix: <proposed fix>

Fields present per instance, by status:
- triggered: quote, detail, fix — all three. One numbered instance per
  distinct sentence quoted. If two different sentences each trigger the
  rule — even via the same global constraint — that is two instances,
  never one instance whose detail narrates both.
- not_applicable: detail only, exactly one instance, no quote/fix. Say
  what's missing (e.g. no commit-message section to check rule 3
  against).
- left_alone: quote, detail — no fix. One instance per candidate left
  alone; detail says why it's deliberately not flagged.
</output_format>
