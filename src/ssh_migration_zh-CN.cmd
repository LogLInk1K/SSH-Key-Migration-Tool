:: Version: 1.0.0
:: Last Updated: 2025-03-27

@echo off
setlocal enabledelayedexpansion

:: 常量定义
set "BackupFolder=ssh_backup"
set "PrivateKey=id_rsa"
set "PublicKey=id_rsa.pub"
set "LogFile=%~dp0ssh_migration.log"

:: 初始化日志
echo [%date% %time%] 脚本启动 >> "%LogFile%"

:: 主菜单
:main_menu
cls
echo === SSH密钥迁移工具（本地版） ===
echo 建议迁移成功后，补充Git全局配置（非必须但建议）
echo git config --global user.name "Your Name"
echo git config --global user.email "email@example.com"
echo 1. 备份模式 - 从本机备份密钥到脚本目录（旧电脑使用）
echo 2. 恢复模式 - 从脚本目录恢复密钥到本机（新电脑使用）
set /p choice=请选择操作模式 (1/2):

if "%choice%"=="1" goto backup_mode
if "%choice%"=="2" goto restore_mode
echo 无效选项，请重新输入！
timeout /t 2 >nul
goto main_menu

:: 备份模式
:backup_mode
echo [%date% %time%] 进入备份模式 >> "%LogFile%"

:: 管理员权限检查
net session >nul 2>&1 || (
    echo 错误：需要以管理员身份运行！
    echo 请右键点击脚本选择“以管理员身份运行”
    echo [%date% %time%] 权限不足导致失败 >> "%LogFile%"
    timeout /t 5
    exit /b 1
)

set "source_dir=%USERPROFILE%\.ssh"
set "source_private=%source_dir%\%PrivateKey%"
set "source_public=%source_dir%\%PublicKey%"

:: 检查密钥是否存在
if not exist "%source_private%" (
    echo 错误：未找到私钥文件 %source_private%
    echo [%date% %time%] 私钥文件缺失 >> "%LogFile%"
    goto end_with_pause
)
if not exist "%source_public%" (
    echo 错误：未找到公钥文件 %source_public%
    echo [%date% %time%] 公钥文件缺失 >> "%LogFile%"
    goto end_with_pause
)

:: 创建备份目录（智能路径构造）
set "backup_path=%~dp0%BackupFolder%"
if not exist "%backup_path%" (
    mkdir "%backup_path%" 2>nul || (
        echo 错误：无法创建备份目录 %backup_path%
        echo [%date% %time%] 目录创建失败 >> "%LogFile%"
        goto end_with_pause
    )
)

:: 复制文件（带详细错误日志）
copy /Y "%source_private%" "%backup_path%\" >nul && (
    echo [%date% %time%] 已复制私钥到 %backup_path% >> "%LogFile%"
) || (
    echo 错误：私钥复制失败
    echo [错误详情] 源文件: %source_private% >> "%LogFile%"
    echo [错误详情] 目标路径: %backup_path% >> "%LogFile%"
    goto end_with_pause
)

copy /Y "%source_public%" "%backup_path%\" >nul && (
    echo [%date% %time%] 已复制公钥到 %backup_path% >> "%LogFile%"
) || (
    echo 错误：公钥复制失败
    goto end_with_pause
)

echo 备份成功！密钥已保存到：
echo %backup_path%
echo 请将此文件夹复制到新电脑的脚本目录下
goto end_with_pause

:: 恢复模式（修复不完整代码）
:restore_mode
echo [%date% %time%] 进入恢复模式 >> "%LogFile%"

set "backup_path=%~dp0\%BackupFolder%"
set "backup_private=%backup_path%\%PrivateKey%"
set "backup_public=%backup_path%\%PublicKey%"

:: 检查备份文件
if not exist "%backup_private%" (
    echo 错误：备份私钥文件不存在
    echo 请确保：
    echo 1. 已运行备份模式
    echo 2. %BackupFolder% 文件夹与脚本同级
    goto end_with_pause
)
if not exist "%backup_public%" (
    echo 错误：备份公钥文件不存在
    goto end_with_pause
)

:: 创建目标目录（新增完整逻辑）
set "target_dir=%USERPROFILE%\.ssh"
if not exist "%target_dir%" (
    mkdir "%target_dir%" 2>nul || (
        echo 错误：无法创建目录 %target_dir%
        echo 尝试以管理员身份运行脚本！
        goto end_with_pause
    )
)

:: 恢复文件（添加覆盖确认）
copy /Y "%backup_private%" "%target_dir%\" >nul && (
    echo [%date% %time%] 已恢复私钥到 %target_dir% >> "%LogFile%"
) || (
    echo 错误：私钥恢复失败
    goto end_with_pause
)

copy /Y "%backup_public%" "%target_dir%\" >nul && (
    echo [%date% %time%] 已恢复公钥到 %target_dir% >> "%LogFile%"
) || (
    echo 错误：公钥恢复失败
    goto end_with_pause
)

echo 恢复成功！密钥已部署到：
echo %target_dir%
echo 建议执行命令：icacls "%target_dir%" /reset /T /C
goto end_with_pause

:: 公共结束模块
:end_with_pause
echo 按任意键返回主菜单...
pause >nul
goto main_menu
