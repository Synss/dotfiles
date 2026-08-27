# Expected findings for `fixtures/clean.md`

This fixture is the precision counterpart to `seeded-violations.md`: every
rule has one sentence that superficially resembles its violation but is a
legitimate judgment call. A correct review reports all eight entries as
`left_alone` — none may be `triggered`, and each entry has exactly one
instance.

Rule no-restatement — left_alone
1. quote: "Interface documentation is exempt from the one-line comment
   default. Docstrings describe their contract in full, including edge
   cases the one-liner style can't capture." (lines 10-12)
   detail: the second sentence justifies the exemption with new
   information (the edge cases a one-liner can't capture) rather than
   re-saying the first sentence's claim, so it isn't a restatement.

Rule concrete-thresholds — left_alone
1. quote: "Keep pull request diffs small enough to review in one sitting,
   as enforced by the diff-size linter in CI." (lines 16-17)
   detail: "small enough to review in one sitting" echoes the rule's own
   vague-language example, but "enforced by the diff-size linter in CI"
   anchors it to a mechanical, verifiable check, unlike an unenforced
   subjective judgment call.

Rule global-interaction — left_alone
1. quote: "Database-migration commits require a body describing the
   rollback plan, overriding the optional-body convention above. The body
   is exempt from the 72-column wrap so the rollback SQL can be pasted
   verbatim." (lines 19-22)
   detail: this project rule flips both the global optional-body and
   72-column-wrap constraints, but states both overrides explicitly, so
   the interaction is surfaced rather than silent.

Rule pronoun-convention — left_alone
1. quote: "A subject like `I fixed the bug` is too vague. Use `Fix
   off-by-one in retry counter` instead." (lines 24-25)
   detail: "I" appears inside a backtick-quoted example of a bad commit
   subject, not as the document's own voice describing the author.

Rule agent-as-subject — left_alone
1. quote: "This backoff timing was tuned against the payments API's rate
   limits, not a general guideline." (lines 38-39)
   detail: passive voice ("was tuned") with no actor named anywhere in
   the sentence, but who performed the tuning genuinely isn't knowable
   and isn't the sentence's point — it exists to record that the number
   is API-specific, not arbitrary. Inventing an actor would add nothing.
   Same sentence as the topic-grouping instance below; a sentence can
   trip more than one rule.

**Not a candidate for `agent-as-subject`:** "Linting is run automatically
on every commit through a pre-commit hook." (line 33) used to be this
rule's documented instance, but under the current rule 5 wording its
actor ("a pre-commit hook") is named in the sentence itself, so the
sentence doesn't match the rule's definition at all — don't cite it as
an aside alongside the backoff-timing instance above.

Rule topic-grouping — left_alone
1. quote: "This backoff timing was tuned against the payments API's rate
   limits, not a general guideline." (lines 38-39)
   detail: sits between the attempt-count/backoff paragraph (lines 35-36)
   and the cap/logging paragraph (lines 41-42), but it continues the same
   backoff topic rather than introducing a different one, so it doesn't
   split anything.

Rule bullet-vs-sequence — left_alone
1. quote: the three-item bullet list (lines 29-31) running `black`,
   `ruff`, and `mypy`.
   detail: chained with "Also" and no order words ("then"/"finally"); the
   three checks are independent and can run in any order, matching the
   rule's own allowed pattern for plain bullets.

Rule xml-tagging-justified — left_alone
1. quote: the `<constraints>` tag (lines 46-50) wrapping three distinct
   enumerated limits (line length, import order, docstring style).
   detail: demarcates a short, machine-checkable ruleset from the
   surrounding prose sections; unlike wrapping one flat sentence, this
   adds a real clarity boundary.

**Nothing in this fixture is a `triggered` instance.** If a review reports
any rule as `triggered`, that is a false positive on one of the judgment
calls above, not a real defect.
