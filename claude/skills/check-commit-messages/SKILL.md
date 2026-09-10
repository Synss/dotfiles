---
name: check-commit-messages
description: Rewrite commit message bodies from their diffs and fix subject-line violations against the prose rules
disable-model-invocation: true
allowed-tools: Bash(jj:*), Bash(awk:*), Bash(printf:*), Read
argument-hint: [revset]
---

## Commit message rules

The commit message rules live in two files, both already in context. The
global `~/.claude/CLAUDE.md` lays them out in sections "Prose" and "Commit
messages". The project's own `.claude/CLAUDE.md`, section "Commit
messages", overrides the global rules where applicable.

## Revset to check

$1

If the line above is empty, the revset is `@`.

## Shell command constraints

See `references/shell-constraints.md`, alongside this file, before
running any command below.

## Instructions

Do not modify the code. Only amend the commit messages in place.

1. Determine the check parameters from the two CLAUDE.md files above:
   the effective subject-length limit (50 unless the project overrides
   it) and, if the project exempts a prefix from that limit (e.g. an
   area tag), the regex matching that prefix. These become the literal
   `limit` and `prefix_re` values used in step 4.
2. Run `jj log -r <revset> --no-graph -T 'commit_id.short() ++ "\n"' -p
   --git` to view the chain's diffs in unified format, using the revset
   from the section above. (The template omits the description on
   purpose, so it can't bias step 3.)
3. For every commit in the revset:
   - If the subject does not accurately and specifically describe the
     diff, rewrite it.
   - Rewrite the body from scratch against the diff from step 2. Do not
     patch the existing body; base it on the full diff, not the
     commit's current text. Follow the body rules in the "Commit
     message rules" section in full.

   Apply each rewrite with `jj describe -r <rev>`.
4. Run the check below over the same `<revset>`, with the `limit` and
   `prefix_re` from step 1, to catch subject length, line-wrap,
   em-dash, and semicolon violations, including in the rewrites just
   made:

   ```
   jj log -r '<revset>' --no-graph -T 'commit_id.short() ++ "\x01" ++ description ++ "\x02"' | awk -v limit=<N> -v prefix_re='<regex>' -f <path-to-check.awk>
   ```

   `<path-to-check.awk>` is the literal absolute path to
   `scripts/check.awk`, alongside this file. Omit
   `-v prefix_re='<regex>'` when the project has no prefix exemption.
5. List each violation from step 4, quoting the offending part and
   naming the rule it breaks. Fix a subject violation with `jj describe
   -r <rev>`, changing only what the rule requires. Leave a compliant
   subject as is. Fix a body violation by redoing its rewrite from
   step 3.
6. Re-run the check from step 4. Confirm no violations remain.
