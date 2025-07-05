import socket
import sys
import time

from zhishi3d.app import redis_listener, ensure_single_instance

if __name__ == '__main__':
    ensure_single_instance()
    redis_listener()
