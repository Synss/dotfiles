# Testing this skill

Two fixtures, testing two different failure modes:

- `fixtures/seeded-violations.md` seeds one violation per rule in
  `../SKILL.md` — tests recall (does it catch every planted defect).
  `expected-findings.md` is the ground truth; every rule must report
  `triggered`.
- `fixtures/clean.md` gives each rule one sentence that superficially
  resembles its violation but is a legitimate judgment call — tests
  precision (does it avoid false positives). `expected-findings-clean.md`
  is the ground truth; every rule must report `left_alone`, never
  `triggered`.

1. Dispatch a fresh subagent: "Use the `reviewing-claude-md` skill to
   review `fixtures/seeded-violations.md`" (or `clean.md`).
2. Compare its findings against the matching `expected-*.md` file.
3. If something's missed, mis-cited, or a false positive, tighten
   `SKILL.md`, re-run, and update the ground truth to match.

A baseline run (no skill mentioned) shows what a generalist review
already catches unprompted.

## Automated check

`./run.sh` dispatches a fresh headless run per fixture and greps each
output for the expected rule statuses and a few seeded quotes — no
structured parsing, no judge call. Costs two real API calls; run by hand
after changing `SKILL.md`.

No total-instance-count assertion on the recall fixture:
`global-interaction`'s dual-interaction citation is flaky across runs,
not a format bug. Likewise, `topic-grouping`'s quoted instance varies
across runs: the model sometimes quotes the paragraph that's split
apart, sometimes the interloping paragraph that splits it. Both
describe the same real defect.
