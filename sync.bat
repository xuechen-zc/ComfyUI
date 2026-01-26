@echo off
setlocal enabledelayedexpansion

:: ===============================
:: 临时脚本运行机制（保持原逻辑）
:: ===============================

set "TEMP_DIR=%TEMP%\temp_git_script_devmerge"
set "TEMP_SCRIPT=%TEMP_DIR%\temp_script.bat"

set "ORIGINAL_DIR=%~dp0"
if "%ORIGINAL_DIR:~-1%"=="\" set "ORIGINAL_DIR=%ORIGINAL_DIR:~0,-1%"

if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

copy /Y "%~f0" "%TEMP_SCRIPT%" >nul

if /I "%~f0"=="%TEMP_SCRIPT%" (
    set "IS_MAIN_SCRIPT=1"
) else (
    set "IS_MAIN_SCRIPT=0"
)

if %IS_MAIN_SCRIPT%==0 (
    start "" cmd /k "%TEMP_SCRIPT% \"%ORIGINAL_DIR%\""
    echo.
    echo 请在新窗口中完成 Git 操作后按任意键继续...
    pause >nul
    goto end
)

:: ===============================
:: 临时脚本主体逻辑
:: ===============================

set "ORIGINAL_DIR=%~1"
cd /d "%ORIGINAL_DIR%"

git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 当前目录不是 Git 仓库
    goto end
)

set "DEV_BRANCH=dev"
set "MASTER_BRANCH=master"
set "ORIGIN_NAME=origin"

echo.
echo ==== Step 1: 切换到 dev 分支 ====
git checkout %DEV_BRANCH%
if %errorlevel% neq 0 (
    echo ❌ 无法切换到 dev 分支
    goto end
)

echo.
echo ==== Step 2: 提交本地修改（如存在） ====
set "HAS_CHANGES=0"
for /f "delims=" %%i in ('git status --porcelain') do (
    set "HAS_CHANGES=1"
)

if %HAS_CHANGES%==1 (
    git add .
    git commit -m "auto: commit local changes before merge"
    if %errorlevel% neq 0 (
        echo ❌ 本地提交失败
        goto end
    )
    echo ✅ 本地修改已提交到 dev
) else (
    echo 无本地修改，跳过提交
)

echo.
echo ==== Step 3: 拉取远端 master ====
git fetch %ORIGIN_NAME%
if %errorlevel% neq 0 (
    echo ❌ fetch 失败
    goto end
)

git checkout %MASTER_BRANCH%
if %errorlevel% neq 0 (
    echo ❌ 无法切换到 master
    goto end
)

git pull %ORIGIN_NAME% %MASTER_BRANCH%
if %errorlevel% neq 0 (
    echo ❌ 拉取远端 master 失败
    goto end
)

echo.
echo ==== Step 4: 合并 master → dev ====
git checkout %DEV_BRANCH%
if %errorlevel% neq 0 (
    echo ❌ 无法切回 dev
    goto end
)

git merge %MASTER_BRANCH% --no-edit
if %errorlevel% neq 0 (
    echo ❌ 合并 master 到 dev 失败（可能存在冲突）
    goto end
)

echo.
echo ==== Step 5: 推送 dev 到远端 ====
git push %ORIGIN_NAME% %DEV_BRANCH%
if %errorlevel% neq 0 (
    echo ❌ 推送 dev 失败
    goto end
)

echo.
echo ✅ 所有操作完成
echo 当前分支：dev

:end
echo.
echo 请按任意键关闭窗口...
pause >nul

