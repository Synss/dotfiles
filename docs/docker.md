# Docker

## MacOS

Colima runs two Linux VM profiles:

- `linux`: arm64. Starts at login. `DOCKER_HOST` points to its socket.
- `linux-amd64`: arm64 with Rosetta, for x86_64 binaries. Starts on
  demand.

Both mount `~/src` only.

## Shortcuts

Each profile name is a shell function that runs its arguments in that VM,
in the current directory. It starts the VM first if it is stopped. For
example, `linux bazel build //...`.

Without arguments, it opens a shell in the VM.

The current directory must be under `~/src`.

## Rosetta

Install with `softwareupdate --install-rosetta --agree-to-license`.
Activation warns when it is missing.

## See Also

- `services.colima` in `man home-configuration.nix`
- `colima template`
