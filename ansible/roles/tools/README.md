# tools role

Installs packages and standalone binaries. The canonical list of everything
installed on this machine lives in `defaults/main.yml` under the `tools` key —
one entry per tool, regardless of how it is installed on each platform.

## Tool entry schema

```yaml
tools_list:
  - name: <string>          # required — tool name, used as binary symlink name
    apt: <string>           # apt package name          (Debian only)
    snap:                   # snap package              (Debian only)
      package: <string>     #   snap store name (defaults to `name` if omitted)
      channel: <string>     #   e.g. latest/edge
    brew: <string>          # Homebrew formula name     (macOS only)
    binary:                 # downloaded binary         (Linux; macOS supported but unused currently)
      version: <string>     #   version string, used in the versioned symlink
      linux_amd64:          #   Linux x86-64
        url: <string>       #     download URL
        checksum: <string>  #     e.g. sha256:<hex>
        archive: <bool>     #     true if the URL is a .tar.gz archive
        archive_binary: <string>  # path inside the archive to the binary (required if archive: true)
      darwin_arm64:         #   macOS Apple Silicon (optional — omit if not needed)
        url: <string>
        checksum: <string>
        archive: <bool>
        archive_binary: <string>
```

All keys except `name` are optional. Omit a key entirely if the tool is not
installed via that method on that platform.

## How platform dispatch works

`tasks/main.yml` includes the appropriate task files based on `os_family`:

| Task file    | Runs on         | Reads from            |
|--------------|-----------------|-----------------------|
| `apt.yml`    | Debian          | `tools_list[].apt`         |
| `snap.yml`   | Debian          | `tools_list[].snap`        |
| `brew.yml`   | Darwin (macOS)  | `tools_list[].brew`        |
| `binary.yml` | all platforms   | `tools_list[].binary`      |

Binary downloads are skipped for tools whose `binary` key lacks an entry for
the current `platform_key` (e.g. no `linux_amd64` sub-key). This is how
Linux-only binaries coexist with tools that have no binary download at all.

Binaries are installed versioned (`~/.local/bin/<name>-<version>`) with a
symlink at `~/.local/bin/<name>`, matching the pattern used by tools like
`asdf` and `mise`.
