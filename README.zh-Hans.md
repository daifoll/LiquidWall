<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  适用于 macOS 的动态视频与照片壁纸，原生 Liquid Glass 界面。
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <strong>简体中文</strong> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.de.md">Deutsch</a> ·
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

Mac 上的轻量级 Wallpaper Engine 替代品。将任意视频或图片设为桌面壁纸，
内置 [Pixabay](https://pixabay.com) 图库 — 搜索、预览、一键应用。

## 功能

- **视频与照片壁纸** — MP4/MOV 无缝循环，或静态图片
- **多显示器** — 默认主显示器、全部或指定屏幕
- **内置 Pixabay 图库** — 数千免费视频与照片，无限滚动，
  应用前流式预览，并行下载并显示进度
- **下载库** — 重新应用或删除已下载媒体
- **拖放** — 将本地文件拖到预览卡片
- **10 种语言** — 应用内语言切换（英、俄、中、日、德、西、葡、法、韩、波）
  及跟随系统；帮助与 Pixabay 搜索随所选语言变化
- **省电** — 硬件解码（1080p 约 2–3% CPU），桌面被遮挡、锁屏或睡眠时自动暂停
- **登录时启动** — 可在设置中开启
- **原生 Liquid Glass UI** — 基于 SwiftUI，macOS Tahoe

## 安装

1. 从 [Releases](https://github.com/daifoll/LiquidWall/releases) 下载最新 `.dmg`
2. 打开并将 **LiquidWall** 拖入 **应用程序**
3. 首次启动时 Gatekeeper 会提示未签名应用。前往
   **系统设置 → 隐私与安全性 → 仍要打开**，或运行：

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> 需要 **macOS Tahoe (26.0) 或更高版本**。

## Pixabay API 密钥

图库需要免费的 Pixabay API 密钥（约两分钟）：

1. 在 [pixabay.com](https://pixabay.com/accounts/register/) 注册
2. 打开 [API 文档](https://pixabay.com/api/docs/) — 密钥显示在
   *Parameters* 中 `key` 字段旁
3. 按提示粘贴到应用中

## 从源码构建

需要 Xcode 26+（Swift 6.2+）。

```bash
./build.sh
open build/LiquidWall.app
```

打包 DMG（需要 [dmgbuild](https://github.com/dmgbuild/dmgbuild)，`pip3 install dmgbuild`）：

```bash
./package.sh
```

## 工作原理

macOS 没有公开的视频壁纸 API，LiquidWall 在桌面窗口层级
（`kCGDesktopWindowLevel`）的无边框窗口中渲染 — 在系统壁纸之上、
图标与窗口之下。视频通过 `AVQueuePlayer` + `AVPlayerLooper` 硬件加速播放；
静态图片使用 `CALayer`（0% CPU）。

## 限制

- 全屏应用时壁纸不可见（窗口在其后方）
- 未经批准的 Pixabay 账户，照片最高 1280 px；视频无此限制

## 翻译

README 提供 10 种语言 — 见页面顶部链接。

> **说明：** 界面与 README 翻译由 AI 生成，可能存在不准确之处。
> 欢迎提交 issue 或 pull request。

## 致谢

- 媒体来自 [Pixabay](https://pixabay.com)，遵循 Pixabay Content License
- 作者 [daifoll](https://github.com/daifoll)
- 使用 **Fable 5** 模型在 [Cursor](https://cursor.com) 中进行 AI 辅助开发

## 许可证

[MIT](LICENSE)
