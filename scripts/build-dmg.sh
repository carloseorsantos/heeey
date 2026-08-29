#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MACOS_DIR="$PROJECT_ROOT/apps/macos"
DIST_DIR="$PROJECT_ROOT/dist"
APP_NAME="Heeey"
APP_BUNDLE="$DIST_DIR/$APP_NAME.app"
DMG_NAME="$DIST_DIR/$APP_NAME-Installer.dmg"
ZIP_NAME="$DIST_DIR/$APP_NAME-macOS.zip"

echo "🔨 [1/5] Compilando Heeey em modo Release..."
cd "$MACOS_DIR"
swift build -c release --arch arm64

echo "📦 [2/5] Criando o bundle $APP_NAME.app..."
rm -rf "$DIST_DIR"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

# Copia o binário
cp "$MACOS_DIR/.build/arm64-apple-macosx/release/$APP_NAME" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
chmod +x "$APP_BUNDLE/Contents/MacOS/$APP_NAME"

# Copia o Info.plist
cp "$MACOS_DIR/Resources/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

echo "🔏 [3/5] Assinando o binário para execução no macOS (Ad-Hoc)..."
codesign --force --deep --sign - "$APP_BUNDLE"

echo "🗜️  [4/5] Gerando arquivo ZIP para download direto..."
cd "$DIST_DIR"
zip -r -q "$ZIP_NAME" "$APP_NAME.app"

echo "💿 [5/5] Gerando Instalador DMG com atalho de Aplicativos..."
DMG_TEMP="$DIST_DIR/dmg_temp"
rm -rf "$DMG_TEMP"
mkdir -p "$DMG_TEMP"

# Copia o app e cria o link simbólico para Applications
cp -R "$APP_BUNDLE" "$DMG_TEMP/"
ln -s /Applications "$DMG_TEMP/Applications"

# Gera o arquivo DMG comprimido
rm -f "$DMG_NAME"
hdiutil create -volname "$APP_NAME Installer" -srcfolder "$DMG_TEMP" -ov -format UDZO "$DMG_NAME" > /dev/null

rm -rf "$DMG_TEMP"

echo ""
echo "🎉 SUCESSO! Instaladores gerados em: $DIST_DIR"
echo "  👉 Instalador DMG: $DMG_NAME"
echo "  👉 Pacote ZIP:     $ZIP_NAME"
echo "  👉 App Bundle:     $APP_BUNDLE"
echo ""
echo "Para instalar no seu Mac agora mesmo:"
echo "  cp -R \"$APP_BUNDLE\" /Applications/"
echo "  open /Applications/$APP_NAME.app"
