---
name: reviewing-claude-md
description: Use when editing or reviewing a change to any CLAUDE.md in this repo, or when the user asks to check/audit/review one.
---

Check the target file (or diff) against each rule below, content rules
before structure rules.

## Rules

### Content

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
   doing the action, and the verb should express that action. Flag a
   sentence whose actor isn't named anywhere within it — whether hidden
   behind a nominalization (a verb turned into an abstract noun, e.g.
   "interaction" for "interact") as the subject, or dropped by passive
   voice. An actor named only in a different sentence doesn't count.
   Leave a sentence alone if it already names its actor (even via a
   passive "by"/"through" phrase, not as the subject), or if the actor
   genuinely varies or isn't knowable at all: don't credit it to an
   invented or borrowed actor.

### Structure

6. `topic-grouping` — Group a section's paragraphs by topic. Don't leave a
   paragraph on a different topic between two paragraphs on the same one:
   merge or reorder so they're adjacent.
7. `bullet-vs-sequence` — Use plain bullets only for independent, parallel
   items chained by "and"/"also". Give a sequence or a conditional
   procedure a numbered list or prose instead, never plain bullets carrying
   order words like "then"/"finally" that the marker doesn't express.
8. `xml-tagging-justified` — Add XML/schema tagging (`<constraints>`,
   `<instructions>`, `<document>`) if the content must be reproduced or
   parsed literally — a template, an enum, a machine-checked block —
   and no heading or prose could mark that boundary as clearly.
   Otherwise leave the file untagged.

## Output format

### Statuses

Each rule reports exactly one of the statuses below.

- `triggered` — an instance matches the rule's definition and has a fix
  that clears the trigger while staying faithful to the text. Fields:
  quote, detail, fix.
- `left_alone` — a genuine near-miss: the instance actually creates the
  tension the rule addresses (not merely shares its topic, sits near a
  violation, or resembles one by proximity alone), and the text resolves
  that tension through an explicit feature (e.g. an override, a cited
  mechanism, a genuine topical continuation, or a deliberate structural
  choice). If a candidate doesn't clear this bar, leave it out entirely
  rather than mentioning it as an aside. Fields: quote, detail.
- `not_applicable` — the file has nothing shaped like this rule's concern
  at all. Fields: detail only, exactly one instance, saying what's
  missing (e.g. no commit-message section to check `global-interaction`
  against).

### Template

Report one entry per rule, in rule order, regardless of status. See
"Statuses" above for what each status means and which fields it takes.

- Check each rule against the whole file, independently of the other rules.
- Number each rule's instances, including when there is only one.
- Count instances separately: different sentences count as different
  instances, and one sentence triggering a rule in distinct ways also
  creates multiple instances — don't fold them into the most salient
  one. If the same sentence violates multiple rules, report it under
  each relevant rule.
- Reference rules by slug, never by list position: a rule's position
  shifts when one is added or reordered, but its slug doesn't.

<output_format>
Rule <slug> — <triggered|not_applicable|left_alone>
1. quote: "<exact text>" (line L)
   detail: <why it triggers / what's missing / why it's left alone>
   fix: <proposed fix>
</output_format>
