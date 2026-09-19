import errno


def connect(sock, addr):
    while True:
        try:
            return sock.connect(addr)
        except OSError as e:
            if e.errno != errno.EAGAIN:
                raise
