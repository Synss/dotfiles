# Restarting the service

Always restart the service after editing the config; it does not pick
up changes automatically.

The service watches its config file and reloads within a few seconds.
Never restart it by hand, since a manual restart resets the connection
pool.

A restart also drops every client at once, which is why the reload
watcher exists.
