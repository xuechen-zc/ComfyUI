import os

from zhishi3d.utils.util import root_path, project_path

os.system(f'mklink /J {root_path("custom_nodes/zhishi3d_nodes")} {project_path("zhishi3d_nodes")}')
os.system(f'mklink /J {root_path("user/default/workflows")} {project_path("workflows")}')
