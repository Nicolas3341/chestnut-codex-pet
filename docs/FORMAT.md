# 资源格式

`pet/pet.json` 引用同目录 `spritesheet.webp`。当前版本使用 spriteVersionNumber=1，1536×1872 RGBA，8×9 格，每格192×208。

九行依次为 idle、running-right、running-left、waving、jumping、failed、waiting、running、review。有效帧数依次6、8、8、4、5、8、6、6、6，从每行最左侧开始；其余格完全透明。透明像素RGB清零。

帧率、触发时机由应用控制；角色配置不含自定义动作触发器或任意帧率字段。仅使用已观察到的 displayName、description、spriteVersionNumber、spritesheetPath 字段。

2026-10-22 在制作者本机检查和测试。Codex 后续版本可能调整加载方式；云端迁移后的角色需要通过云端更新功能同步，不能只覆盖本地目录。
