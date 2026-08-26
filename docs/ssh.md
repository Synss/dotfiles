# SSH

## sshconfig

Include child configurations in `~/.ssh/config` with
```
Include ~/.ssh/config_work
```

Set up aliases as
```
# vim: ft=sshconfig

# -- Domain

Host [list-of-aliases]
    HostName <fully-qualified-domain-name>
    User <username>
```

### Example

```
Host ci
    HostName ci.example.com
    User root
```
SSH into the host with `ssh ci`.

## See Also

`man 5 ssh_config`
