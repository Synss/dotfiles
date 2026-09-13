# Connection drops under load

The daemon closes idle connections after 30 seconds, even when a client
sends a keepalive every 10 seconds.

To reproduce: start the daemon with the default config, connect a
client, send a keepalive every 10 seconds, and wait 45 seconds.

The keepalive handler only resets the idle timer for the read side of
the socket. Write-only keepalives never reset it, so the daemon still
sees the connection as idle.

As a workaround, send a byte on the read side as the keepalive instead
of a write-only ping.
