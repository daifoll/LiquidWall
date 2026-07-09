<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Live-Video- und Foto-Hintergründe für macOS mit nativer Liquid-Glass-Oberfläche.
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <strong>Deutsch</strong> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português (Brasil)</a> ·
  <a href="README.fr.md">Français</a> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pl.md">Polski</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26+">
  <img src="https://img.shields.io/badge/Swift-6.2-orange" alt="Swift 6.2">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

Eine leichte Wallpaper-Engine-Alternative für den Mac. Jedes Video oder Bild wird
zum Desktop-Hintergrund — mit eingebauter [Pixabay](https://pixabay.com)-Galerie:
suchen, Vorschau, mit einem Klick anwenden.

## Funktionen

- **Video- & Foto-Hintergründe** — MP4/MOV mit nahtloser Schleife oder statische Bilder
- **Mehrere Displays** — Hauptdisplay (Standard), alle oder ein bestimmtes
- **Pixabay-Galerie** — Tausende kostenlose Videos und Fotos, Endlos-Scroll,
  Streaming-Vorschau, parallele Downloads mit Fortschritt
- **Bibliothek** — Heruntergeladene Medien erneut anwenden oder löschen
- **Drag & Drop** — lokale Datei auf die Vorschaukarte ziehen
- **10 Sprachen** — Sprachumschalter in der App (EN, RU, ZH, JA, DE, ES, PT, FR, KO, PL)
  plus Systemstandard; Hilfe und Pixabay-Suche folgen der gewählten Sprache
- **Energieeffizient** — Hardware-Decoding (~2–3 % CPU bei 1080p), Pause bei
  verdecktem Desktop, Sperrbildschirm und Ruhezustand
- **Beim Anmelden starten** — optional in den Einstellungen
- **Native Liquid-Glass-UI** — SwiftUI auf macOS Tahoe

## Installation

1. Neuestes `.dmg` von [Releases](https://github.com/daifoll/LiquidWall/releases) laden
2. Öffnen und **LiquidWall** nach **Programme** ziehen
3. Beim ersten Start warnt Gatekeeper. **Systemeinstellungen → Datenschutz & Sicherheit → Trotzdem öffnen**, oder:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Erfordert **macOS Tahoe (26.0) oder neuer**.

## Pixabay-API-Schlüssel

Die Galerie benötigt einen kostenlosen Pixabay-API-Schlüssel (ca. 2 Minuten):

1. Registrierung auf [pixabay.com](https://pixabay.com/accounts/register/)
2. [API-Dokumentation](https://pixabay.com/api/docs/) öffnen — Schlüssel neben `key`
3. In der App einfügen, wenn danach gefragt wird

## Aus Quellcode bauen

Xcode 26+ (Swift 6.2+) erforderlich.

```bash
./build.sh
open build/LiquidWall.app
```

DMG-Paket ([dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`):

```bash
./package.sh
```

## Einschränkungen

- Hintergrund nicht über Vollbild-Apps sichtbar
- Pixabay-Fotos max. 1280 px ohne genehmigtes API-Konto; Videos ohne Limit

## Übersetzungen

README in 10 Sprachen — Links oben auf der Seite.

> **Hinweis:** UI- und README-Übersetzungen wurden mit KI erstellt und können ungenau sein.
> Fehler bitte per Issue oder Pull Request melden.

## Danksagungen

- Medien von [Pixabay](https://pixabay.com) (Pixabay Content License)
- Erstellt von [daifoll](https://github.com/daifoll)
- KI-gestützte Entwicklung mit **Fable 5** in [Cursor](https://cursor.com)

## Lizenz

[MIT](LICENSE)
