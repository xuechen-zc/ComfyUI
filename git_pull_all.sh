#!/bin/bash

# 脚本执行时出错就停止
set -e

echo "更新 ComfyUI 主程序..."
cd /root/autodl-tmp/ComfyUI
git pull

echo "更新 zhishi3d..."
cd /root/autodl-tmp/ComfyUI/zhishi3d
git pull

echo "更新 ComfyUI-Hunyuan3d-2-1..."
cd /root/autodl-tmp/ComfyUI/custom_nodes/ComfyUI-Hunyuan3d-2-1
git pull

echo "更新 ComfyUI-Manager..."
cd /root/autodl-tmp/ComfyUI/custom_nodes/ComfyUI-Manager
git pull

echo "全部更新完成 ✅"
