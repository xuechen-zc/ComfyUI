from zhishi3d.root import init_config
init_config("local")
from main import start_comfyui_app

if __name__ == '__main__':
    import os

    os.environ["TQDM_DISABLE"] = "1"
    start_comfyui_app()