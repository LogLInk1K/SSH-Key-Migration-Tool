# SSH 密钥迁移工具

![Batch Script](https://img.shields.io/badge/Language-Batch-blueviolet)

一个用于在Windows系统间迁移SSH密钥的批处理工具，支持备份和恢复模式。

<a href="/docs/usage_zh-CN.md">简体中文</a>

## 功能特性
- 一键备份SSH密钥到脚本目录
- 自动恢复密钥到新设备的用户目录
- 操作日志记录功能
- 管理员权限自动检测

## 使用说明
### 备份模式（旧设备）
1. 右键&zwnj;**以管理员身份运行**&zwnj;脚本
2. 选择模式 1
3. 脚本会自动将密钥备份到同级目录的`ssh_backup`文件夹

### 恢复模式（新设备）
1. 将整个项目文件夹复制到新设备
2. 运行脚本并选择模式 2
3. 密钥会被还原到`%USERPROFILE%\.ssh`

⚠️ &zwnj;**重要提示**&zwnj;  
建议在恢复后执行权限重置：
```cmd
icacls "%USERPROFILE%\.ssh" /reset /T /C
