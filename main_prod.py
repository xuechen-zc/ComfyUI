from zhishi3d.root import init_config
init_config("prod")
from main import start_comfyui_app
from zhishi3d.script.utils import start_checker


if __name__ == '__main__':
    start_comfyui_app()