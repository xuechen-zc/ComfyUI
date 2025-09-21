#!/bin/bash
# 脚本执行时出错就停止
set -e

# 获取脚本所在目录的绝对路径 (也就是 ComfyUI 根目录)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 需要更新的子目录（相对脚本目录）
REPOS=(
  "."                                # ComfyUI 主程序
  "zhishi3d"
  "custom_nodes/ComfyUI-Hunyuan3d-2-1"
  "custom_nodes/ComfyUI-Manager"
  "custom_nodes/ComfyUI-Hunyuan3DWrapper"
)

for repo in "${REPOS[@]}"; do
  echo "更新 $repo ..."
  cd "$SCRIPT_DIR/$repo"
  git reset --hard
  git clean -fd
  git pull
done

echo "全部更新完成 ✅"
