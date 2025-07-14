@echo off
setlocal enabledelayedexpansion

:: 设置临时目录和副本脚本路径
set "TEMP_DIR=%TEMP%\temp_git_script_sync_all"
set "TEMP_SCRIPT=%TEMP_DIR%\sync_all_temp.bat"

:: 获取当前脚本所在目录
set "ORIGINAL_DIR=%~dp0"
if "%ORIGINAL_DIR:~-1%"=="\" set "ORIGINAL_DIR=%ORIGINAL_DIR:~0,-1%"

:: 显示原始目录
echo Original Directory: %ORIGINAL_DIR%

:: 创建临时目录（如果不存在）
if not exist "%TEMP_DIR%" (
    mkdir "%TEMP_DIR%"
)

:: 拷贝自身到临时脚本
copy /Y "%~f0" "%TEMP_SCRIPT%" >nul

:: 判断是否是临时脚本自身在运行
set "IS_MAIN_SCRIPT=0"
for %%f in (%0) do (
    set "FILE_NAME=%%~nxf"
)
if "!FILE_NAME!"=="sync_all_temp.bat" (
    set "IS_MAIN_SCRIPT=1"
)

:: 如果不是副本，则重新启动一个 cmd 执行副本，并等待完成
if %IS_MAIN_SCRIPT%==0 (
    start "" cmd /k ""%TEMP_SCRIPT%" %ORIGINAL_DIR%"
    echo.
    echo 请在新窗口中完成操作后按任意键继续...
    pause >nul
    goto :end
)

:: =========================
:: 以下是实际执行部分
:: =========================

:: 从参数恢复原始路径
set "ORIGINAL_DIR=%~1"
cd /d "%ORIGINAL_DIR%"

echo.
echo === 执行当前目录 sync.bat ===
if exist "%ORIGINAL_DIR%\sync.bat" (
    call "%ORIGINAL_DIR%\sync.bat"
) else (
    echo 未找到: %ORIGINAL_DIR%\sync.bat
)

echo.
echo === 执行 zhishi3d\sync.bat ===
if exist "%ORIGINAL_DIR%\zhishi3d\sync.bat" (
    pushd "%ORIGINAL_DIR%\zhishi3d"
    call sync.bat
    popd
) else (
    echo 未找到: %ORIGINAL_DIR%\zhishi3d\sync.bat
)

echo.
echo === 执行 custom_nodes\ComfyUI-Manager\sync.bat ===
if exist "%ORIGINAL_DIR%\custom_nodes\ComfyUI-Manager\sync.bat" (
    pushd "%ORIGINAL_DIR%\custom_nodes\ComfyUI-Manager"
    call sync.bat
    popd
) else (
    echo 未找到: %ORIGINAL_DIR%\custom_nodes\ComfyUI-Manager\sync.bat
)

echo.
echo === 所有操作完成 ===
pause

:end
endlocal
exit
