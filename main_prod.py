from zhishi3d.utils.root import init_config
init_config("prod")
from main import start_comfyui_app
from zhishi3d.script.utils import start_checker


if __name__ == '__main__':
    start_checker()
    start_comfyui_app()