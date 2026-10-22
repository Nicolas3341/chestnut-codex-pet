#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PET_HOME="${CODEX_HOME:-$HOME/.codex}"
TARGET="$PET_HOME/pets/chestnut"
test -f "$ROOT/pet/pet.json"
test -f "$ROOT/pet/spritesheet.webp"
if [ -e "$TARGET" ]; then
  BACKUP="$PET_HOME/pet-backups/chestnut-$(date +%Y%m%d-%H%M%S)-$$"
  mkdir -p "$(dirname "$BACKUP")"
  cp -R "$TARGET" "$BACKUP"
  echo "旧版已备份：$BACKUP"
fi
mkdir -p "$TARGET"
cp "$ROOT/pet/pet.json" "$TARGET/pet.json"
cp "$ROOT/pet/spritesheet.webp" "$TARGET/spritesheet.webp"
cmp "$ROOT/pet/pet.json" "$TARGET/pet.json"
cmp "$ROOT/pet/spritesheet.webp" "$TARGET/spritesheet.webp"
echo "安装完成：$TARGET"
echo "在宠物列表选择栗子（动作扩展版）。已有云端角色请参阅README的云端更新说明。"
