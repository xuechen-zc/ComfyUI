import threading

from main import start_comfyui_app

if __name__ == '__main__':
    threading.Thread(target=start_comfyui_app).start()