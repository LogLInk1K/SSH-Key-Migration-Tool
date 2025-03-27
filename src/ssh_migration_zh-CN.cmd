:: Version: 1.0.0
:: Last Updated: 2025-03-27

@echo off
setlocal enabledelayedexpansion

:: ��������
set "BackupFolder=ssh_backup"
set "PrivateKey=id_rsa"
set "PublicKey=id_rsa.pub"
set "LogFile=%~dp0ssh_migration.log"

:: ��ʼ����־
echo [%date% %time%] �ű����� >> "%LogFile%"

:: ���˵�
:main_menu
cls
echo === SSH��ԿǨ�ƹ��ߣ����ذ棩 ===
echo ����Ǩ�Ƴɹ��󣬲���Gitȫ�����ã��Ǳ��뵫���飩
echo git config --global user.name "Your Name"
echo git config --global user.email "email@example.com"
echo 1. ����ģʽ - �ӱ���������Կ���ű�Ŀ¼���ɵ���ʹ�ã�
echo 2. �ָ�ģʽ - �ӽű�Ŀ¼�ָ���Կ���������µ���ʹ�ã�
set /p choice=��ѡ�����ģʽ (1/2):

if "%choice%"=="1" goto backup_mode
if "%choice%"=="2" goto restore_mode
echo ��Чѡ����������룡
timeout /t 2 >nul
goto main_menu

:: ����ģʽ
:backup_mode
echo [%date% %time%] ���뱸��ģʽ >> "%LogFile%"

:: ����ԱȨ�޼��
net session >nul 2>&1 || (
    echo ������Ҫ�Թ���Ա������У�
    echo ���Ҽ�����ű�ѡ���Թ���Ա������С�
    echo [%date% %time%] Ȩ�޲��㵼��ʧ�� >> "%LogFile%"
    timeout /t 5
    exit /b 1
)

set "source_dir=%USERPROFILE%\.ssh"
set "source_private=%source_dir%\%PrivateKey%"
set "source_public=%source_dir%\%PublicKey%"

:: �����Կ�Ƿ����
if not exist "%source_private%" (
    echo ����δ�ҵ�˽Կ�ļ� %source_private%
    echo [%date% %time%] ˽Կ�ļ�ȱʧ >> "%LogFile%"
    goto end_with_pause
)
if not exist "%source_public%" (
    echo ����δ�ҵ���Կ�ļ� %source_public%
    echo [%date% %time%] ��Կ�ļ�ȱʧ >> "%LogFile%"
    goto end_with_pause
)

:: ��������Ŀ¼������·�����죩
set "backup_path=%~dp0%BackupFolder%"
if not exist "%backup_path%" (
    mkdir "%backup_path%" 2>nul || (
        echo �����޷���������Ŀ¼ %backup_path%
        echo [%date% %time%] Ŀ¼����ʧ�� >> "%LogFile%"
        goto end_with_pause
    )
)

:: �����ļ�������ϸ������־��
copy /Y "%source_private%" "%backup_path%\" >nul && (
    echo [%date% %time%] �Ѹ���˽Կ�� %backup_path% >> "%LogFile%"
) || (
    echo ����˽Կ����ʧ��
    echo [��������] Դ�ļ�: %source_private% >> "%LogFile%"
    echo [��������] Ŀ��·��: %backup_path% >> "%LogFile%"
    goto end_with_pause
)

copy /Y "%source_public%" "%backup_path%\" >nul && (
    echo [%date% %time%] �Ѹ��ƹ�Կ�� %backup_path% >> "%LogFile%"
) || (
    echo ���󣺹�Կ����ʧ��
    goto end_with_pause
)

echo ���ݳɹ�����Կ�ѱ��浽��
echo %backup_path%
echo �뽫���ļ��и��Ƶ��µ��ԵĽű�Ŀ¼��
goto end_with_pause

:: �ָ�ģʽ���޸����������룩
:restore_mode
echo [%date% %time%] ����ָ�ģʽ >> "%LogFile%"

set "backup_path=%~dp0\%BackupFolder%"
set "backup_private=%backup_path%\%PrivateKey%"
set "backup_public=%backup_path%\%PublicKey%"

:: ��鱸���ļ�
if not exist "%backup_private%" (
    echo ���󣺱���˽Կ�ļ�������
    echo ��ȷ����
    echo 1. �����б���ģʽ
    echo 2. %BackupFolder% �ļ�����ű�ͬ��
    goto end_with_pause
)
if not exist "%backup_public%" (
    echo ���󣺱��ݹ�Կ�ļ�������
    goto end_with_pause
)

:: ����Ŀ��Ŀ¼�����������߼���
set "target_dir=%USERPROFILE%\.ssh"
if not exist "%target_dir%" (
    mkdir "%target_dir%" 2>nul || (
        echo �����޷�����Ŀ¼ %target_dir%
        echo �����Թ���Ա������нű���
        goto end_with_pause
    )
)

:: �ָ��ļ�����Ӹ���ȷ�ϣ�
copy /Y "%backup_private%" "%target_dir%\" >nul && (
    echo [%date% %time%] �ѻָ�˽Կ�� %target_dir% >> "%LogFile%"
) || (
    echo ����˽Կ�ָ�ʧ��
    goto end_with_pause
)

copy /Y "%backup_public%" "%target_dir%\" >nul && (
    echo [%date% %time%] �ѻָ���Կ�� %target_dir% >> "%LogFile%"
) || (
    echo ���󣺹�Կ�ָ�ʧ��
    goto end_with_pause
)

echo �ָ��ɹ�����Կ�Ѳ��𵽣�
echo %target_dir%
echo ����ִ�����icacls "%target_dir%" /reset /T /C
goto end_with_pause

:: ��������ģ��
:end_with_pause
echo ��������������˵�...
pause >nul
goto main_menu
