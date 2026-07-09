#!/bin/zsh
# Сборка LiquidWall.app из SPM-пакета
set -e
cd "$(dirname "$0")"

swift build -c release

APP="build/LiquidWall.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp Resources/Info.plist "$APP/Contents/Info.plist"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
cp .build/release/LiquidWall "$APP/Contents/MacOS/LiquidWall"

# SPM кладёт String Catalog в resource bundle — без него переводы не работают
BUNDLE=".build/release/LiquidWall_LiquidWall.bundle"
if [[ -d "$BUNDLE" ]]; then
    cp -R "$BUNDLE" "$APP/Contents/Resources/"
fi

codesign --force --sign - "$APP"

echo "Готово: $APP"
