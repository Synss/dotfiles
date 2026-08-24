# Testing this skill

`fixtures/seeded-violations.md` seeds one violation of each rule in
`../SKILL.md`. `expected-findings.md` is the ground truth: which rule each
seeded issue should trigger, and roughly what fix it should propose.

This is an application-scenario test (per superpowers:writing-skills'
"Technique Skills" testing guidance), not a pressure/discipline test — there
is no rule here an agent is tempted to skip, only a checklist to apply
correctly. There's no automated harness; re-run it by hand whenever the
skill's wording changes:

1. Dispatch a fresh subagent with no prior context, pointed at the skill and
   the fixture: "Use the `reviewing-claude-md` skill to review
   `fixtures/seeded-violations.md`."
2. Compare its findings against `expected-findings.md`: exactly 7 entries,
   one per rule in rule order, each `triggered` with numbered instances
   matching the quote/detail/fix there (rule 3 has two; every other rule
   has one), and none of the distractors mis-cited under rule 3.
3. If something's missed or mis-cited, tighten the rule's wording in
   SKILL.md and re-run. Don't tune the skill to force a match on an
   incidental artifact of this one fixture — check that a wording change
   makes sense as a general rule before keeping it.

A baseline run (same fixture, same prompt, but no skill mentioned or
available) is useful context before changing the skill: it shows what a
generalist review already catches on its own, so you can tell whether a
wording change is closing a real gap or just re-deriving what the base model
already does unprompted.
