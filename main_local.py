from zhishi3d.utils.root import init_config
init_config("local")
from main import start_comfyui_app

if __name__ == '__main__':
    start_comfyui_app()