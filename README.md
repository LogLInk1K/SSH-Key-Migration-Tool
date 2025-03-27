# SSH Key Migration Tool

![Batch Script]( https://img.shields.io/badge/Language-Batch-blueviolet )

A batch processing tool for migrating SSH keys between Windows systems, supporting backup and recovery modes.

## Functional characteristics
-One click backup of SSH key to script directory
-Automatically restore keys to the user directory of the new device
-Operation log recording function
-Automatic detection of administrator permissions

## Instructions for use
### Backup mode (old devices)
1. Right click **Run as an administrator** script
2. Select Mode 1
3. The script will automatically back up the key to the 'ssh-backup' folder in the same level directory

### Recovery mode (new device)
1. Copy the entire project folder to the new device
2. Run the script and select mode 2
3. The key will be restored to '% USERPROFILE% \. ssh'`

⚠️ **Important Notice**
Suggest resetting permissions after recovery:
```cmd
icacls "%USERPROFILE%\.ssh" /reset /T /C
```

# SSH 密钥迁移工具

![Batch Script](https://img.shields.io/badge/Language-Batch-blueviolet)

一个用于在Windows系统间迁移SSH密钥的批处理工具，支持备份和恢复模式。

## 功能特性
- 一键备份SSH密钥到脚本目录
- 自动恢复密钥到新设备的用户目录
- 操作日志记录功能
- 管理员权限自动检测

## 使用说明
### 备份模式（旧设备）
1. 右键**以管理员身份运行**脚本
2. 选择模式 1
3. 脚本会自动将密钥备份到同级目录的`ssh_backup`文件夹

### 恢复模式（新设备）
1. 将整个项目文件夹复制到新设备
2. 运行脚本并选择模式 2
3. 密钥会被还原到`%USERPROFILE%\.ssh`

⚠️ **重要提示**;  
建议在恢复后执行权限重置：
```cmd
icacls "%USERPROFILE%\.ssh" /reset /T /C
```