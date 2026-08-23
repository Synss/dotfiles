# Expected findings for `fixtures/seeded-violations.md`

One seeded violation per rule in SKILL.md. A correct review cites the rule
number below for each, with a fix along these lines.

1. **Rule 1** — "Subject: prefixed with `docs:`. This means every docs
   commit subject starts with the `docs:` prefix." The second sentence only
   restates the first. Fix: delete it.
2. **Rule 2** — "Keep the introduction short enough to scan before the
   fold." No concrete threshold. Fix: replace with a measurable limit (e.g.
   a sentence count).
3. **Rule 3** — "Docs commit bodies include a rendered table listing every
   page the change touches." Interacts with the global rule "Wrap at 72
   columns" two sections up: a page table will often exceed 72 columns per
   row, and the file never says whether the table is exempt. Fix: state the
   interaction explicitly.
4. **Rule 4** — "My commit messages always explain why I changed the page,
   not just what changed." Uses "My"/"I" for the human author. Fix: rewrite
   with "the user".
5. **Rule 5** — the three-item bullet list under "Editing pages" mixes a
   conditional step with a strict sequence ("Then", "Finally") inside plain
   `-` bullets, which don't express order. Fix: a numbered list (dropping
   "Then"/"Finally") or prose — either is acceptable, plain unordered
   bullets are not.
6. **Rule 6** — the `<rules>` tag wrapping a single flat sentence
   ("Use sentence case for all page titles.") adds no clarity. Fix: drop
   the tag.

**Not a defect, don't flag:** "Body: optional, answers "why". Wrap at 72
columns." on its own, and the `docs:` prefix rule in isolation — there is no
character-limit rule in this fixture for the prefix to interact with, so
rule 3 doesn't apply to it.
