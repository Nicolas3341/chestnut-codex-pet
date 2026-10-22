# Windows 安装说明

适用于仓库当前发布版：站立待机、露肚交互、舔爪和打哈欠。体型修订预览尚未并入此发布版。

Windows 的宠物功能见 [OpenAI 官方 Pets 文档](https://learn.chatgpt.com/docs/pets)。本项目目前在 macOS 完成资源检查和云端上传，**尚未在 Windows 实机验证本角色的加载、切换和播放**。下面的本地安装方法以应用支持兼容的本地自定义角色加载器为前提。

## 先检查宠物列表

在 Windows 桌面应用中登录自己的账号，打开“设置 → Pets / 宠物”（旧版入口可能在“外观”）。如果列表已有自己的「栗子（动作扩展版）」，先直接选择。

GitHub 下载不会把制作者的云端宠物自动加入你的账号；跨设备是否出现取决于当前应用与账号的同步情况。已迁移到云端的旧栗子也不会因为本地文件被覆盖而自动更新。

## 下载与手动安装

1. 从 [Release 下载页面](https://github.com/Nicolas3341/chestnut-codex-pet/releases/tag/v1.1.0) 下载 `chestnut-codex-pet-v1.1.0.zip`，右键“全部解压”。也可在仓库首页选择 Code → Download ZIP 后解压。
2. 打开解压目录，找到 `pet` 文件夹，确认里面有 `pet.json` 和 `spritesheet.webp`。不要在压缩包内部直接操作。
3. 完全退出桌面应用。对于使用默认 Codex home 的 Windows 本地环境，按 Win+R，输入 `%USERPROFILE%\.codex` 并回车；目录不存在时可在用户目录下创建 `.codex`。若应用明确设置了其他 `CODEX_HOME`，使用应用实际采用的目录。
4. 在该目录下创建 `pets` 文件夹。如果已有 `pets\chestnut`，先把整个旧 `chestnut` 复制到 `.codex\pet-backups\chestnut-日期时间`，再覆盖。备份不要留在 `pets` 内。
5. 将下载的 `pet` 文件夹中的两个文件复制至 `pets\chestnut`。最终目录应为：

```text
C:\Users\你的用户名\.codex\
├─ pets\
│  └─ chestnut\
│     ├─ pet.json
│     └─ spritesheet.webp
└─ pet-backups\
   └─ chestnut-日期时间\      （有旧版时才需要）
```

不要多套一层 `pet` 或 `chestnut`；不要将整份仓库放入 `pets`。资源无需转换格式，`pet.json` 中的相对路径保持 `spritesheet.webp`。本地复制不需要管理员权限，也不需要修改注册表、应用程序目录或全局配置。

## 可选：用 PowerShell 完成复制和备份

在**解压后的仓库根目录**打开 Windows PowerShell，确认当前目录下能看到 `pet` 文件夹，再粘贴执行以下代码。它只负责安装文件，不负责云端上传或切换角色；请先退出桌面应用。

```powershell
$ErrorActionPreference = 'Stop'
$source = Join-Path (Get-Location) 'pet'
if (-not (Test-Path -LiteralPath (Join-Path $source 'pet.json') -PathType Leaf) -or
    -not (Test-Path -LiteralPath (Join-Path $source 'spritesheet.webp') -PathType Leaf)) {
    throw '请先进入解压后的仓库根目录，确认 pet 文件夹包含两个资源文件。'
}
$petHome = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
    Join-Path $env:USERPROFILE '.codex'
} else {
    $env:CODEX_HOME
}
$target = Join-Path $petHome 'pets\chestnut'
if (Test-Path -LiteralPath $target) {
    $backupRoot = Join-Path $petHome 'pet-backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $backup = Join-Path $backupRoot ('chestnut-' + (Get-Date -Format 'yyyyMMdd-HHmmssfff'))
    Copy-Item -LiteralPath $target -Destination $backup -Recurse -ErrorAction Stop
    Write-Host "旧版备份：$backup"
}
New-Item -ItemType Directory -Path $target -Force | Out-Null
foreach ($file in @('pet.json', 'spritesheet.webp')) {
    $src = Join-Path $source $file
    $dst = Join-Path $target $file
    Copy-Item -LiteralPath $src -Destination $dst -Force
    if ((Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash -ne
        (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash) {
        throw "复制后校验失败：$file"
    }
}
Write-Host "资源复制并核对完成：$target"
```

这段 PowerShell 示例尚未在 Windows 执行验证。当前 PowerShell 的 `CODEX_HOME` 需要与桌面应用实际使用的一致；临时设置在一个终端中的环境变量，不代表已打开的桌面应用也采用了它。仓库的 `scripts/install.sh` 是 shell 脚本，不能作为 PowerShell 脚本执行。

## 选择角色与检查

重新启动桌面应用，在宠物列表选择「栗子（动作扩展版）」。有自定义宠物刷新入口时可先刷新列表。

检查默认待机、透明背景、拖动时左右朝向，以及任务状态切换。露肚使用现有 `jumping` 交互槽位，舔爪使用 `waving`，打哈欠使用 `waiting`；它们不是新增的独立按钮，能否触发及触发时机由应用控制。行走仍存在滑步。

## 看不到角色或仍是旧版

- 核对目录层级和文件名，注意不要把 `pet.json` 保存成 `pet.json.txt`。
- 核对应用实际使用的 `CODEX_HOME`；WSL 模式可能使用不同环境的 home。不要默认认为 Windows 的 `.codex` 与 WSL 的 `~/.codex` 是同一个位置，也不要盲目向多个目录复制。
- 如果已有同名云端栗子，覆盖本地文件可能不会改变云端版本。需要使用应用提供的自定义宠物更新能力上传本仓库的 `pet/spritesheet.webp`，并更新已有角色；目录安装本身不会执行这一步。
- 如果当前版本没有兼容的本地导入入口，保留文件并使用应用提供的宠物导入/创建功能。不要修改应用本体或缓存来强行替换。

## 回退

退出应用，将当前 `pets\chestnut` 移到 `pets` 之外留存，再把之前备份的整个 `chestnut` 恢复到原位置，重启后重新选择角色。没有旧版本时，可以移出新加入的角色目录。此方法只回退本地文件，云端更新需要单独处理。
