<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Live video &amp; photo wallpapers for macOS with a native Liquid Glass UI.
</p>

<p align="center">
  <a href="README.ru.md">Русская версия</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26+">
  <img src="https://img.shields.io/badge/Swift-6.2-orange" alt="Swift 6.2">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

A lightweight Wallpaper Engine alternative for the Mac. Turns any video or image
into a desktop wallpaper, with a built-in [Pixabay](https://pixabay.com) gallery
for discovering free content — search, preview, and apply in one click.

## Features

- **Video & photo wallpapers** — MP4/MOV videos with seamless looping, or static images
- **Multi-display** — main display by default, all displays, or a specific one
- **Pixabay gallery built in** — search thousands of free videos and photos,
  infinite scroll, streaming preview before applying, parallel downloads with progress
- **Library tab** — re-apply or delete previously downloaded media
- **Drag & drop** — drop any local file onto the preview card
- **Power-efficient** — hardware-accelerated decoding (~2–3% CPU for 1080p video),
  playback pauses automatically when the desktop is covered, the screen is locked,
  or the system sleeps
- **Launch at login** — optional, toggled in settings
- **Native Liquid Glass UI** — built with SwiftUI on macOS Tahoe

## Install

1. Download the latest `.dmg` from [Releases](https://github.com/daifoll/LiquidWall/releases)
2. Open it and drag **LiquidWall** to **Applications**
3. On first launch macOS Gatekeeper will warn about an unsigned app. Either go to
   **System Settings → Privacy & Security → Open Anyway**, or run:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Requires **macOS Tahoe (26.0) or later**.

## Pixabay API key

The gallery needs a free Pixabay API key (takes two minutes):

1. Register at [pixabay.com](https://pixabay.com/accounts/register/)
2. Open the [API documentation](https://pixabay.com/api/docs/) — your key is shown
   in the *Parameters* section next to the `key` field
3. Paste it into the app when prompted

## Build from source

Requires Xcode 26+ (Swift 6.2+).

```bash
./build.sh                     # builds build/LiquidWall.app
open build/LiquidWall.app
```

To package a DMG (requires [dmgbuild](https://github.com/dmgbuild/dmgbuild),
`pip3 install dmgbuild`):

```bash
./package.sh                   # builds build/LiquidWall-<version>.dmg
```

## How it works

macOS has no public API for video wallpapers, so LiquidWall renders content in a
borderless window at the desktop window level (`kCGDesktopWindowLevel`) — above the
system wallpaper, below icons and app windows. Video plays through
`AVQueuePlayer` + `AVPlayerLooper` with a hardware-accelerated `AVPlayerLayer`;
static images use a plain `CALayer` (0% CPU).

Project layout:

| Path | Purpose |
| --- | --- |
| `Sources/LiquidWall/WallpaperEngine.swift` | Desktop-level windows, playback, display targeting |
| `Sources/LiquidWall/AppModel.swift` | App state, search, downloads, library, launch-at-login |
| `Sources/LiquidWall/ContentView.swift` | Window layout and sidebar |
| `Sources/LiquidWall/GalleryView.swift` | Pixabay gallery, preview, downloads library |
| `Sources/LiquidWall/PixabayClient.swift` | Pixabay API client |
| `dmg-settings.py` | DMG installer layout ([dmgbuild](https://github.com/dmgbuild/dmgbuild)) |

## Limitations

- The wallpaper is not visible over full-screen apps (it sits behind them)
- Pixabay photos are limited to 1280 px unless your API account is approved
  for full resolution; videos have no such limit

## Credits

- Media provided by [Pixabay](https://pixabay.com) under the Pixabay Content License
- Created by [daifoll](https://github.com/daifoll)

## License

[MIT](LICENSE)
