@echo off
setlocal enabledelayedexpansion

:: 设置临时目录，用于保存脚本副本
set TEMP_DIR=%TEMP%\temp_git_script
set TEMP_SCRIPT=%TEMP_DIR%\temp_script.bat

:: 确保临时目录存在
if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

:: 强制覆盖临时脚本文件
copy /Y "%~f0" "%TEMP_SCRIPT%"

:: 判断当前是否已经是主脚本
set IS_MAIN_SCRIPT=0
for %%f in (%0) do (
    set FILE_NAME=%%~nxf
)
if "%FILE_NAME%"=="temp_script.bat" (
    set IS_MAIN_SCRIPT=1
)

:: 如果是第一次执行主脚本，启动新的窗口来执行脚本
if %IS_MAIN_SCRIPT%==0 (
    start cmd /k "%TEMP_SCRIPT%"
    echo.
    echo 请在新窗口中完成操作后按任意键继续...
    pause >nul
    goto end
)

:: 临时脚本开始

:: 进入脚本所在目录（假设脚本路径就是Git仓库的根目录）
cd /d "%~dp0"

:: 确保当前目录是一个 Git 仓库
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 当前目录不是一个 Git 仓库。请确认该脚本在 Git 仓库中运行。
    goto end
)

:: 设置分支名
set DEV_BRANCH=dev
set MASTER_BRANCH=master

:: 设置上游仓库地址（不要改动这个，除非你知道自己在做什么）
set UPSTREAM_URL=https://github.com/comfyanonymous/ComfyUI.git
set UPSTREAM_NAME=upstream
set ORIGIN_NAME=origin

echo.
echo ==== Step 1: 检查是否已添加 upstream ====
git remote | findstr /C:"%UPSTREAM_NAME%" >nul
if %errorlevel% neq 0 (
    echo 未找到 upstream，正在添加...
    git remote add %UPSTREAM_NAME% %UPSTREAM_URL%
) else (
    echo 已存在 upstream 远程。
)

echo.
echo ==== Step 2: 获取 upstream 最新内容 ====
git fetch %UPSTREAM_NAME%
if %errorlevel% neq 0 (
    echo ❌ 获取 upstream 失败。
    goto end
)

echo.
echo ==== Step 3: 切换到 master 并合并 upstream/master ====
git checkout %MASTER_BRANCH% 2>nul
if %errorlevel% neq 0 (
    echo ❌ 无法切换到 master 分支。
    goto end
)
git merge %UPSTREAM_NAME%/%MASTER_BRANCH% --no-edit
if %errorlevel% neq 0 (
    echo ❌ 合并 upstream 到 master 失败。
    goto end
)
git push %ORIGIN_NAME% %MASTER_BRANCH%

echo.
echo ==== Step 4: 切换回 dev 并合并 master ====
git checkout %DEV_BRANCH% 2>nul
if %errorlevel% neq 0 (
    echo ❌ 无法切换到 dev 分支。
    goto end
)
git merge %MASTER_BRANCH% --no-edit
if %errorlevel% neq 0 (
    echo ❌ 合并 master 到 dev 失败。
    goto end
)
git push %ORIGIN_NAME% %DEV_BRANCH%

echo.
echo ✅ 所有操作完成，当前分支仍为 %DEV_BRANCH%

:end
echo.
echo 请按任意键关闭窗口...
pause >nul

:: 临时脚本结束
