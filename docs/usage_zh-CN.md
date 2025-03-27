# SSH 密钥迁移工具

![Batch Script](https://img.shields.io/badge/Language-Batch-blueviolet)

一个用于在Windows系统间迁移SSH密钥的批处理工具，支持备份和恢复模式。
A batch processing tool for migrating SSH keys between Windows systems, supporting backup and recovery modes.

## 功能特性 Functional characteristics
- 一键备份SSH密钥到脚本目录 One click backup of SSH key to script directory
- 自动恢复密钥到新设备的用户目录 Automatically restore keys to the user directory of the new device
- 操作日志记录功能 Operation log recording function
- 管理员权限自动检测 Automatic detection of administrator permissions

## 使用说明 Instructions for use
### 备份模式（旧设备） Backup mode (old devices) 
1. 右键&zwnj;**以管理员身份运行**&zwnj;脚本 Right click&zwnj** Run * *&zwnj; as an administrator; script
2. 选择模式 1 Select Mode 1
3. 脚本会自动将密钥备份到同级目录的`ssh_backup`文件夹 The script will automatically back up the key to the 'ssh-backup' folder in the same level directory

### 恢复模式（新设备） Recovery mode (new device)
1. 将整个项目文件夹复制到新设备 Copy the entire project folder to the new device
2. 运行脚本并选择模式 2 Run the script and select mode 2
3. 密钥会被还原到`%USERPROFILE%\.ssh` The key will be restored to '% USERPROFILE% \. ssh'`

⚠️ &zwnj;**重要提示**&zwnj; &zwnj;**Important Notice**&zwnj;
建议在恢复后执行权限重置 Suggest resetting permissions after recovery:：
```cmd
icacls "%USERPROFILE%\.ssh" /reset /T /C
