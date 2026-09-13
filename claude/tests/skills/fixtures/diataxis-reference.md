# tool.conf reference

`tool.conf` is read once at startup from `/etc/tool.conf`.

`timeout` sets the connection timeout in seconds. Default: 30.

`retries` sets the number of reconnect attempts. Default: 3.

To enable verbose logging, run `tool --verbose --debug` before starting
the daemon.

`log_level` sets the minimum severity written to the log. Default:
warning.
