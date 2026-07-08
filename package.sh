#!/bin/zsh
# Упаковка LiquidWall в .dmg для установки на другом маке.
# Требуется dmgbuild: pip3 install dmgbuild
set -e
cd "$(dirname "$0")"

./build.sh

VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" build/LiquidWall.app/Contents/Info.plist)
DMG="build/LiquidWall-$VERSION.dmg"

rm -f "$DMG"

dmgbuild -s dmg-settings.py -D app=build/LiquidWall.app "LiquidWall" "$DMG"

echo ""
echo "Готово: $DMG"
echo "Установка: открыть DMG и перетащить LiquidWall в Applications."
