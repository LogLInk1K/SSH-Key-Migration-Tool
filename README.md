# SSH Key Migration Tool

![Batch Script]( https://img.shields.io/badge/Language-Batch-blueviolet )

A batch processing tool for migrating SSH keys between Windows systems, supporting backup and recovery modes.

  <p align="center">
    <a href="/docs/usage_zh-CN.md">简体中文</a>
  </p>

## Functional characteristics
-One click backup of SSH key to script directory
-Automatically restore keys to the user directory of the new device
-Operation log recording function
-Automatic detection of administrator permissions

## Instructions for use
### Backup mode (old devices)
1. Right click&zwnj** Run * *&zwnj; as an administrator; script
2. Select Mode 1
3. The script will automatically back up the key to the 'ssh-backup' folder in the same level directory

### Recovery mode (new device)
1. Copy the entire project folder to the new device
2. Run the script and select mode 2
3. The key will be restored to '% USERPROFILE% \. ssh'`

⚠️ &zwnj;**Important Notice**&zwnj;
Suggest resetting permissions after recovery:
```cmd
icacls "%USERPROFILE%\.ssh" /reset /T /C

