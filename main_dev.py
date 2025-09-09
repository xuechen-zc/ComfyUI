from zhishi3d.root import init_config
init_config("dev")
from main import start_comfyui_app

if __name__ == '__main__':
    start_comfyui_app()