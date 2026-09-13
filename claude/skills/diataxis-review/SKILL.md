---
name: diataxis-review
description: Review a doc against the four Diataxis modes (tutorial, how-to, reference, explanation); fix what doesn't fit a single-mode doc, or reorganize a multi-modal one into labeled sections, bailing out unchanged if it's unsortable
disable-model-invocation: true
allowed-tools: Bash(jj:*), Bash(git:*), Read, Edit
argument-hint: [path]
---

## Target

$ARGUMENTS

A file to review in place. If empty, review the prose documentation
touched by the current diff (`jj diff`, falling back to `git diff`),
and skip the other files.

## Diataxis

Diataxis sorts documentation by what the reader is doing: acquiring
knowledge or applying it, and whether that happens through action or
through cognition. That gives four modes:

- **Tutorial** — action + acquisition. Walks a newcomer through one
  full path to a first success. Markers: "first", a single narrated
  walkthrough, no branching, assumes no prior context.
- **How-to guide** — action + application. Steps to a specific goal
  for a reader who already knows why they want it. Markers: imperative
  steps ("to enable X, run..."), silent on rationale, assumes
  competence.
- **Reference** — cognition + application. States what is true, for a
  reader consulting it mid-task. Markers: declarative statements,
  tables of flags or defaults, no required reading order.
- **Explanation** — cognition + acquisition. Gives background or
  reasoning, for a reader building understanding rather than doing a
  task right now. Markers: "because", contrasts, rationale, no steps.

The same concept can legitimately appear in more than one mode, worded
differently for each reader's purpose — a config key described tersely
in reference and again, with reasoning, in explanation. That is not
duplication to remove; it is two readers being served. Full framework:
https://diataxis.fr.

## Sections

Both fixes below create sections. Head each with the mode's name
(Tutorial, How-to, Reference, Explanation) plus enough of the topic to
navigate by, e.g. "How-to: enable verbose logging". Reference and
explanation take one section per mode. How-to and tutorial take one
per goal: reproducing a bug and working around it are two how-tos, not
one.

## Process

1. Name who reads this text and where they stand on the two axes:
   learning or working, doing or understanding. Then read the whole
   target once as that reader.
2. Form a qualitative sense of its shape: which mode dominates, and
   name any passage that reads as a different mode. A phrase, not a
   percentage — "mostly reference, with one how-to paragraph".
3. Branch:
   - **Clearly one mode**: find passages that are a *mode* mismatch —
     a tutorial step inside a reference doc, an imperative "run X"
     inside an explanation — and move each into its own section in the
     same doc. A project convention that restricts the doc to one mode
     (stated in the project's CLAUDE.md or README) overrides this: cut
     the stray and quote it in the report instead.
   - **Unclear**: test whether every passage can be assigned a mode
     without contradicting another passage or resisting
     classification.
     - If yes, reorganize the doc into sections, one per mode present
       (per goal for how-to and tutorial). Note in the report whether
       the mix looks inherent to the doc's genre (e.g. a ticket, which
       by nature mixes how-to-shaped repro steps with
       explanation-shaped root cause) or accidental drift — this is
       color for the report, not a different fix.
     - If no — passages give conflicting guidance, or resist
       classification even on a second look — bail out. Report why.
       Change nothing.
4. Report: one line naming the branch taken and the shape from step 2,
   then one line per section moved or created, or per stray cut. Say
   nothing about what stayed unchanged.

## What not to do

- Do not flag or remove a passage for restating a concept that appears
  in another mode. Repetition across modes is the framework working,
  not a fault. A verbatim duplicate inside one mode is `plain-review`'s
  business, not this skill's.
- Do not invent a numeric threshold for how mixed a doc is. The
  branch in step 3 is a judgment call, not a cutoff.
- Do not add content a mode is missing (e.g. inventing tutorial steps
  for a reference-only doc). Organize what is there. A heading and the
  one-line lead-in a new section needs are structure, not content.
- Do not touch text outside the target.
