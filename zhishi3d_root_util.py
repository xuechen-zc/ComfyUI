import sys


def get_port_postfix():
    if '--port' in sys.argv:
        port_index = sys.argv.index('--port')
        if port_index + 1 < len(sys.argv):
            port = int(sys.argv[port_index + 1])
            postfix = f"_{port}"
        else:
            postfix = ""
    else:
        postfix = ""
    return postfix