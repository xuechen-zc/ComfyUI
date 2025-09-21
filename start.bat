@echo off
REM 激活 conda 环境
call conda activate ComfyUI

REM 启动第一个进程
start "ComfyUI-10000" cmd /k python main_local.py --port=10000

REM 启动第二个进程
start "ComfyUI-10001" cmd /k python main_local.py --port=10001

REM 保持窗口不关闭（可选）
pause
