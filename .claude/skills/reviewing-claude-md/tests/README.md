# Testing this skill

`fixtures/seeded-violations.md` seeds one violation per rule in
`../SKILL.md`. `expected-findings.md` is the ground truth.

1. Dispatch a fresh subagent: "Use the `reviewing-claude-md` skill to
   review `fixtures/seeded-violations.md`."
2. Compare its findings against `expected-findings.md`.
3. If something's missed or mis-cited, tighten `SKILL.md`, re-run, and
   update `expected-findings.md` to match.

A baseline run (no skill mentioned) shows what a generalist review
already catches unprompted.

## Automated check

`./run.sh` dispatches a fresh headless run and greps its output for each
rule's status and a few seeded quotes — no structured parsing, no judge
call. Costs a real API call; run by hand after changing `SKILL.md`.

No total-instance-count assertion: rule 3's dual-interaction citation is
flaky across runs, not a format bug.
