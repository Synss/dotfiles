# Shell command constraints for check-commit-messages

The permission checker statically rejects any bash expansion. This
includes `${...}`, `$(...)`, `` $'...' ``, and a bare `$var`. It also
rejects a command split across lines with backslash continuation.

Write every literal value directly into the command. Keep each command
on one line. Never loop over a shell variable.

To compare candidate subject lines by length, write them out with
`printf` and pipe the output into `awk`:

```
printf '%s\n' "candidate one" "candidate two" | awk '{print length, $0}'
```

To check several draft files, pass their literal paths as separate
arguments to one `awk` call. It accepts multiple files and exposes
`FILENAME` and `FNR`.
