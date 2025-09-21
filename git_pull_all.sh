#!/bin/bash
# 脚本执行时出错就停止
set -e

# 获取脚本所在目录的绝对路径 (也就是 ComfyUI 根目录)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 子目录
ZHISHI3D="$SCRIPT_DIR/zhishi3d"
HUNYUAN="$SCRIPT_DIR/custom_nodes/ComfyUI-Hunyuan3d-2-1"
MANAGER="$SCRIPT_DIR/custom_nodes/ComfyUI-Manager"
WRAPPER="$SCRIPT_DIR/custom_nodes/ComfyUI-Hunyuan3DWrapper"

echo "更新 ComfyUI 主程序..."
cd "$SCRIPT_DIR"
git pull

echo "更新 zhishi3d..."
cd "$ZHISHI3D"
git pull

echo "更新 ComfyUI-Hunyuan3d-2-1..."
cd "$HUNYUAN"
git pull

echo "更新 ComfyUI-Manager..."
cd "$MANAGER"
git pull

echo "更新 ComfyUI-Hunyuan3DWrapper..."
cd "$WRAPPER"
git pull

echo "全部更新完成 ✅"
