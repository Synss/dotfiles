# Expected findings for `fixtures/seeded-violations.md`

One seeded violation per rule in SKILL.md, so a correct review reports all
seven entries as `triggered` (this fixture has no `not_applicable` or
`left_alone` case). `global-interaction` legitimately has three instances:
the "always" sentence (lines 12-13) overriding the global "optional" body,
and the table sentence (lines 15-16) triggering twice — once for that same
optional/mandatory override, and once for interacting with the global
"wrap at 72 columns" rule. Every other rule's entry is a numbered list of
exactly one instance:

Rule no-restatement — triggered
1. quote: "Subject: prefixed with `docs:`. This means every docs commit
   subject starts with the `docs:` prefix." (lines 9-10)
   detail: the second sentence only restates the first.
   fix: delete the second sentence.

Rule concrete-thresholds — triggered
1. quote: "Keep the introduction short enough to scan before the fold."
   (line 20)
   detail: no concrete threshold.
   fix: replace with a measurable limit (e.g. a sentence count).

Rule global-interaction — triggered
1. quote: "My commit messages always explain why I changed the page, not
   just what changed." (lines 12-13)
   detail: "always" makes the body mandatory in every commit, silently
   overriding the global "Body: optional" (line 5).
   fix: state the override explicitly.
2. quote: "Docs commit bodies include a rendered table listing every page
   the change touches." (lines 15-16)
   detail: requiring a body to "include" a table implies a body always
   exists, silently overriding the global "Body: optional" (line 5) —
   the same interaction as instance 1, but a distinct sentence.
   fix: state the override explicitly, or scope the table requirement to
   commits that already have a body.
3. quote: "Docs commit bodies include a rendered table listing every page
   the change touches." (lines 15-16)
   detail: interacts with the global rule "Wrap at 72 columns" (line 5):
   a page table will often exceed 72 columns per row, and the file never
   says whether the table is exempt.
   fix: state the interaction explicitly, or exempt the table from the
   wrap limit.

Rule pronoun-convention — triggered
1. quote: "My commit messages always explain why I changed the page, not
   just what changed." (lines 12-13)
   detail: uses "My"/"I" for the human author.
   fix: rewrite with "the user".

Rule topic-grouping — triggered
1. quote: "Retries back off exponentially starting at 200ms, capped at 5s."
   (line 38)
   detail: this continues the retry-count/backoff topic opened at line 34
   ("Retries default to 3 attempts."), but the logging paragraph (line 36)
   sits between them, splitting the topic.
   fix: move this paragraph directly after line 34's, ahead of the logging
   paragraph.

Rule bullet-vs-sequence — triggered
1. quote: the three-item bullet list (lines 22-24) mixing a conditional
   step with a strict sequence ("Then", "Finally") inside plain `-`
   bullets.
   detail: plain bullets don't express order; this is a sequence.
   fix: a numbered list (dropping "Then"/"Finally") or prose — either is
   acceptable, plain unordered bullets are not.

Rule xml-tagging-justified — triggered
1. quote: the `<rules>` tag (lines 28-30) wrapping a single flat sentence
   ("Use sentence case for all page titles.").
   detail: the tag adds no clarity over the plain sentence.
   fix: drop the tag.

**Distractors, don't cite these as `global-interaction` instances:** "Body:
optional, answers "why". Wrap at 72 columns." (line 5) on its own, and the
`docs:` prefix rule (lines 9-10) in isolation — there is no character-limit
rule in this fixture for the prefix to interact with, so neither sentence
is itself a `global-interaction` violation. `global-interaction`'s entry
must have exactly the three instances above, quoting lines 12-13 once and
lines 15-16 twice — not these, and not a fourth.
