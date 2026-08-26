---
name: reviewing-claude-md
description: Use when editing or reviewing a change to any CLAUDE.md in this repo, or when asked to check/audit/review one.
---

Check the target file (or diff) against each rule below, content rules
before structure rules.

## Content

1. `no-restatement` — No sentence may only restate a nearby rule.
2. `concrete-thresholds` — No vague or unverifiable language (e.g. "short
   enough to scan", "usually enough"). Replace with a concrete threshold.
3. `global-interaction` — Check every project requirement against every
   global constraint, not only ones sharing an obvious keyword or
   constraint type. State explicitly how they interact: a required signature
   block can interact with a line-count limit, and an "always"/"never"
   project requirement can flip whether a global rule is optional or
   mandatory.
4. `pronoun-convention` — "The user" names the human author, and "you"
   names the agent. Never use "I"/"me"/"my" for the author, or "you" for
   the author instead of the agent.
5. `agent-as-subject` — The subject of a sentence should be the entity
   doing the action, and the verb should express that action. Flag
   nominalizations (a verb turned into an abstract noun, e.g.
   "interaction" for "interact") and passive voice that drops the actor.
   Leave alone a passive whose actor genuinely varies or isn't knowable
   (e.g. a diff drafted by either the user or the agent): don't credit
   it to an invented actor.

## Structure

6. `topic-grouping` — Group a section's paragraphs by topic. Don't leave a
   paragraph on a different topic between two paragraphs on the same one:
   merge or reorder so they're adjacent.
7. `bullet-vs-sequence` — Use plain bullets only for independent, parallel
   items chained by "and"/"also". Give a sequence or a conditional
   procedure a numbered list or prose instead, never plain bullets carrying
   order words like "then"/"finally" that the marker doesn't express.
8. `xml-tagging-justified` — Add XML/schema tagging (`<constraints>`,
   `<instructions>`, `<document>`) if it adds clarity that a Content fix
   above can't. Otherwise leave the file untagged.

## Output format

<output_format>
Report one entry per rule, in rule order, regardless of status:

- Check each rule against the whole file, independently of the other rules.
- Number each rule's instances, including when there is only one.
- Count instances separately:
  - Different sentences count as different instances.
  - One sentence triggering a rule in distinct ways also creates multiple
    instances. Don't fold them into the most salient one.
  - If the same sentence violates multiple rules, report it under each relevant
    rule.
- Give each rule a single status. Do not mix triggered items with items that
  were left alone.
- If a candidate doesn't qualify as a triggered instance, leave it out entirely
  rather than mentioning it as an aside.

Rule <slug> — <triggered|not_applicable|left_alone>
1. quote: "<exact text>" (line L)
   detail: <why it triggers / what's missing / why it's left alone>
   fix: <proposed fix>

Fields present per instance, by status:
- triggered: quote, detail, and fix.
- not_applicable: detail only, exactly one instance. Say what's missing
  (e.g. no commit-message section to check `global-interaction` against).
- left_alone: quote and detail, no fix. One instance per candidate left
  alone. Detail says why it's deliberately not flagged.

Reference rules by slug, never by list position: a rule's position shifts
when one is added or reordered, but its slug doesn't.
</output_format>
