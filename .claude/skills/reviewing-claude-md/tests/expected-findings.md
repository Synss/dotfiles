# Expected findings for `fixtures/seeded-violations.md`

One seeded violation per rule in SKILL.md, so a correct review reports all
six entries as `triggered` (this fixture has no `not_applicable` or
`left_alone` case). Rule 3 legitimately has two instances — the seeded
table/wrap interaction, plus a second real interaction the same fixture
happens to also contain (lines 12-13's "always" language quietly
overriding the global "optional" body). Every other rule's entry is a
numbered list of exactly one instance:

Rule 1 — triggered
1. quote: "Subject: prefixed with `docs:`. This means every docs commit
   subject starts with the `docs:` prefix." (lines 9-10)
   detail: the second sentence only restates the first.
   fix: delete the second sentence.

Rule 2 — triggered
1. quote: "Keep the introduction short enough to scan before the fold."
   (line 20)
   detail: no concrete threshold.
   fix: replace with a measurable limit (e.g. a sentence count).

Rule 3 — triggered
1. quote: "My commit messages always explain why I changed the page, not
   just what changed." (lines 12-13)
   detail: "always" makes the body mandatory in every commit, silently
   overriding the global "Body: optional" (line 5).
   fix: state the override explicitly.
2. quote: "Docs commit bodies include a rendered table listing every page
   the change touches." (lines 15-16)
   detail: interacts with the global rule "Wrap at 72 columns" (line 5):
   a page table will often exceed 72 columns per row, and the file never
   says whether the table is exempt.
   fix: state the interaction explicitly.

Rule 4 — triggered
1. quote: "My commit messages always explain why I changed the page, not
   just what changed." (lines 12-13)
   detail: uses "My"/"I" for the human author.
   fix: rewrite with "the user".

Rule 5 — triggered
1. quote: the three-item bullet list (lines 22-24) mixing a conditional
   step with a strict sequence ("Then", "Finally") inside plain `-`
   bullets.
   detail: plain bullets don't express order; this is a sequence.
   fix: a numbered list (dropping "Then"/"Finally") or prose — either is
   acceptable, plain unordered bullets are not.

Rule 6 — triggered
1. quote: the `<rules>` tag (lines 28-30) wrapping a single flat sentence
   ("Use sentence case for all page titles.").
   detail: the tag adds no clarity over the plain sentence.
   fix: drop the tag.

**Distractors, don't cite these as rule 3 instances:** "Body: optional,
answers "why". Wrap at 72 columns." (line 5) on its own, and the `docs:`
prefix rule (lines 9-10) in isolation — there is no character-limit rule
in this fixture for the prefix to interact with, so neither sentence is
itself a rule 3 violation. Rule 3's entry must have exactly the two
instances above, quoting lines 12-13 and 15-16 — not these, and not a
third.
