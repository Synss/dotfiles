---
name: plain-review
description: Review text (a file, a commit range, or pasted prose) for plain language as defined by the Prose section of CLAUDE.md and ISO 24495-1, then fix what fails its reader
disable-model-invocation: true
allowed-tools: Bash(jj:*), Bash(git:*), Read, Edit
argument-hint: [path | revset | text]
---

## Target

$ARGUMENTS

Resolve the line above in this order:

- a path: a file to edit in place
- a jj revset: commit descriptions to amend with `jj describe -r <rev>`
- anything else: text to rewrite in the reply

If the line is empty, review the files touched by the current diff
(`jj diff`, falling back to `git diff`).

## What to check

The rules are the "Prose" section of the global `CLAUDE.md`, already in
context. This skill adds the order of work and the question to ask at
each step. Work from the reader down to the words. A text that fails an
early step is rarely fixed by a later one.

1. **Reader.** Name who reads this text and what they will do with it.
   Read the whole target once as that reader before editing anything.
2. **Relevance.** Is the main point first? Cut what that reader does not
   need. Move detail most readers skip into its own section.
3. **Structure.** Does each paragraph hold one topic? Would a run of
   parallel items read better as a list? Do the headings match the
   content under them?
4. **Sentences.** Does each sentence carry one idea? Is the actor the
   subject? Would the reader get it on first reading?
5. **Words.** Is there a plainer word? A verb hiding in a noun? A term
   the reader does not know, left unexplained?

## What not to do

- Do not edit for punctuation alone. A dash or semicolon is a prompt to
  test the sentence for two ideas, not a fault. When the test passes,
  the punctuation stays.
- Do not split a sentence whose clauses form one idea. "If X, then Y"
  is one idea.
- Do not replace a term the reader knows with a longer paraphrase.
- Do not change meaning. When plainer wording would lose a distinction,
  keep the distinction and say so in the report.
- Do not touch text outside the target.

## Process

1. Resolve the target and read it in full.
2. Walk the checklist above, top to bottom.
3. Apply the fixes: edit the file, `jj describe` the commit, or write
   the rewritten text in the reply.
4. Report one line per class of change, for example "split three
   two-idea sentences" or "moved the caveat below the steps". Do not
   list what stayed unchanged.
