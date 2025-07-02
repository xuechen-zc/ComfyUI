import json
import uuid
from urllib import request

import websocket

from comfy_extras.nodes_apg import project
from script_examples.websockets_api_example import get_images
from zhishi3d.utils.util import project_path
def load_json_file(file_path):
    """ 读取并解析 JSON 文件 """
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)
server_address = "127.0.0.1:8188"
client_id = str(uuid.uuid4())
if __name__ == '__main__':
    file_path=project_path("workflows","api.json")
    prompt = load_json_file(file_path)
    # set the text prompt for our positive CLIPTextEncode


    ws = websocket.WebSocket()
    ws.connect("ws://{}/ws?clientId={}".format(server_address, client_id))
    images = get_images(ws, prompt)
    ws.close()