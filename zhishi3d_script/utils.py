import os
import subprocess
import signal
import sys

def find_process_using_port_unix(port):
    try:
        result = subprocess.check_output(f"lsof -i :{port} -sTCP:LISTEN -t", shell=True)
        pids = result.decode().strip().split('\n')
        return [int(pid) for pid in pids]
    except subprocess.CalledProcessError:
        return []

def kill_process_unix(pid):
    try:
        os.kill(pid, signal.SIGTERM)
        print(f"[UNIX] 已终止进程 PID: {pid}")
    except ProcessLookupError:
        print(f"[UNIX] 进程 PID {pid} 不存在")
    except PermissionError:
        print(f"[UNIX] 无权限终止进程 PID: {pid}")

def kill_8188_unix():
    port = 8188
    pids = find_process_using_port_unix(port)
    if not pids:
        print(f"[UNIX] 未找到占用端口 {port} 的进程。")
        return
    print(f"[UNIX] 占用端口 {port} 的进程 PID 列表: {pids}")
    for pid in pids:
        kill_process_unix(pid)

def kill_8188_windows():
    port = 8188
    try:
        result = subprocess.check_output(f'netstat -ano | findstr :{port}', shell=True)
        lines = result.decode().strip().split('\n')
        pids = set()
        for line in lines:
            parts = line.strip().split()
            if len(parts) >= 5:
                pid = parts[-1]
                pids.add(pid)
        if not pids:
            print(f"[WIN] 未找到占用端口 {port} 的进程。")
        for pid in pids:
            print(f"[WIN] 尝试终止 PID: {pid}")
            os.system(f'taskkill /PID {pid} /F')
    except subprocess.CalledProcessError:
        print(f"[WIN] 未找到占用端口 {port} 的进程。")

def kill_8188():
    if sys.platform.startswith("win"):
        kill_8188_windows()
    else:
        kill_8188_unix()

if __name__ == '__main__':
    kill_8188()
