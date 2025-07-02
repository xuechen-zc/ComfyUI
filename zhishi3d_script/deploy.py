from main import start_comfyui_app
from zhishi3d.utils.root import init_config

if __name__ == '__main__':
    init_config('prod')
    start_comfyui_app()