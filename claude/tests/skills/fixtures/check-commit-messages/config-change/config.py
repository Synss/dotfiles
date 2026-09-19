# The system file must win over the user file, matching every other
# tool shipped on the box.
PATHS = ["/etc/tool.conf", "~/.tool.conf"]


def load():
    for p in PATHS:
        if exists(p):
            return read(p)
