PATHS = ["~/.tool.conf", "/etc/tool.conf"]


def load():
    for p in PATHS:
        if exists(p):
            return read(p)
