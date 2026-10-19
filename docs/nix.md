# nix

## Debugging

Using the repl:

```bash
$ nix repl
nix-repl> :lf # load flakes
nix-repl> :p devShells # prints the whole tree
nix-repl> devShells.<TAB> # list/complete attribute names
```

## See Also

- [`flake.md`](./flake.nix)
