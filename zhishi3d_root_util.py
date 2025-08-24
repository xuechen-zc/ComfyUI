import sys


def get_comfyui_port():
    subfolder = "8188"
    for arg in sys.argv[1:]:
        if arg.startswith('--port='):
            try:
                port = int(arg.split('=', 1)[1])
                subfolder = f"{port}"
            except ValueError:
                subfolder = ""
            break
    return subfolder