:: Version: 1.0.0
:: Last Updated: 2025-03-27

@echo off
setlocal enabledelayedexpansion

:: Constants
set "BackupFolder=ssh_backup"
set "PrivateKey=id_rsa"
set "PublicKey=id_rsa.pub"
set "LogFile=%~dp0ssh_migration.log"

:: Initialize log
echo [%date% %time%] Script started >> "%LogFile%"

:: Main Menu
:main_menu
cls
echo === SSH Key Migration Tool (Local Version) ===
echo After successful migration, set up Git config (optional but recommended):
echo git config --global user.name "Your Name"
echo git config --global user.email "email@example.com"
echo 1. Backup Mode - Export keys to script directory (for old machine)
echo 2. Restore Mode - Import keys from script directory (for new machine)
set /p choice=Select operation mode (1/2):

if "%choice%"=="1" goto backup_mode
if "%choice%"=="2" goto restore_mode
echo Invalid option, please try again!
timeout /t 2 >nul
goto main_menu

:: Backup Mode
:backup_mode
echo [%date% %time%] Entered Backup Mode >> "%LogFile%"

:: Administrator check
net session >nul 2>&1 || (
echo Error: Please run as Administrator!
echo Right-click script and select "Run as administrator"
echo [%date% %time%] Failed: Insufficient privileges >> "%LogFile%"
timeout /t 5
exit /b 1
)

set "source_dir=%USERPROFILE%\.ssh"
set "source_private=%source_dir%\%PrivateKey%"
set "source_public=%source_dir%\%PublicKey%"

:: Verify key existence
if not exist "%source_private%" (
echo Error: Private key not found at %source_private%
echo [%date% %time%] Missing private key >> "%LogFile%"
goto end_with_pause
)
if not exist "%source_public%" (
echo Error: Public key not found at %source_public%
echo [%date% %time%] Missing public key >> "%LogFile%"
goto end_with_pause
)

:: Create backup directory
set "backup_path=%~dp0%BackupFolder%"
if not exist "%backup_path%" (
mkdir "%backup_path%" 2>nul || (
echo Error: Failed to create backup directory %backup_path%
echo [%date% %time%] Directory creation failed >> "%LogFile%"
goto end_with_pause
)
)

:: Copy files
copy /Y "%source_private%" "%backup_path%\" >nul && (
echo [%date% %time%] Private key copied to %backup_path% >> "%LogFile%"
) || (
echo Error: Failed to copy private key
echo [Error Details] Source: %source_private% >> "%LogFile%"
echo [Error Details] Destination: %backup_path% >> "%LogFile%"
goto end_with_pause
)

copy /Y "%source_public%" "%backup_path%\" >nul && (
echo [%date% %time%] Public key copied to %backup_path% >> "%LogFile%"
) || (
echo Error: Failed to copy public key
goto end_with_pause
)

echo Backup completed! Keys saved to:
echo %backup_path%
echo Copy this folder to the new machine's script directory
goto end_with_pause

:: Restore Mode
:restore_mode
echo [%date% %time%] Entered Restore Mode >> "%LogFile%"

set "backup_path=%~dp0\%BackupFolder%"
set "backup_private=%backup_path%\%PrivateKey%"
set "backup_public=%backup_path%\%PublicKey%"

:: Verify backup files
if not exist "%backup_private%" (
echo Error: Backup private key not found
echo Ensure:
echo 1. Backup mode was executed
echo 2. %BackupFolder% exists in script directory
goto end_with_pause
)
if not exist "%backup_public%" (
echo Error: Backup public key not found
goto end_with_pause
)

:: Create target directory
set "target_dir=%USERPROFILE%\.ssh"
if not exist "%target_dir%" (
mkdir "%target_dir%" 2>nul || (
echo Error: Failed to create directory %target_dir%
echo Try running as Administrator!
goto end_with_pause
)
)

:: Restore files
copy /Y "%backup_private%" "%target_dir%\" >nul && (
echo [%date% %time%] Private key restored to %target_dir% >> "%LogFile%"
) || (
echo Error: Failed to restore private key
goto end_with_pause
)

copy /Y "%backup_public%" "%target_dir%\" >nul && (
echo [%date% %time%] Public key restored to %target_dir% >> "%LogFile%"
) || (
echo Error: Failed to restore public key
goto end_with_pause
)

echo Restoration completed! Keys deployed to:
echo %target_dir%
echo Recommended command: icacls "%target_dir%" /reset /T /C
goto end_with_pause

:: Common exit
:end_with_pause
echo Press any key to return to main menu...
pause >nul
goto main_menu
