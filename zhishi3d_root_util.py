import sys


def get_port_postfix():
    postfix = "_8188"
    for arg in sys.argv[1:]:
        if arg.startswith('--port='):
            try:
                port = int(arg.split('=', 1)[1])
                postfix = f"_{port}"
            except ValueError:
                postfix = ""
            break
    return postfix