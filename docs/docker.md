# Docker

## MacOS

Start Colima (Linux VM):

```bash
colima start
[ -S "$HOME/.colima/default/docker.sock" ] \
  && export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
```

And setup the configuration `~/.docker/config.json` as

```json
{
  "auths": {},
  "credsStore": "osxkeychain",
  "currentContext": "colima"
}
```
