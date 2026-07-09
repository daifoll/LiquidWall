<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  macOS 向けのライブ動画・写真壁紙。ネイティブ Liquid Glass UI。
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <strong>日本語</strong> ·
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

Mac 用の軽量 Wallpaper Engine 代替。動画や画像をデスクトップ壁紙にし、
内蔵 [Pixabay](https://pixabay.com) ギャラリーで検索・プレビュー・ワンクリック適用。

## 機能

- **動画・写真壁紙** — MP4/MOV のシームレスループ、または静止画
- **マルチディスプレイ** — メイン（既定）、すべて、または特定の画面
- **Pixabay ギャラリー** — 無料の動画・写真を検索、無限スクロール、
  適用前のストリーミングプレビュー、並列ダウンロードと進捗表示
- **ライブラリ** — ダウンロード済みメディアの再適用・削除
- **ドラッグ＆ドロップ** — ローカルファイルをプレビューにドロップ
- **10 言語** — アプリ内言語切替（英・露・中・日・独・西・葡・仏・韓・波）とシステム追従；
  ヘルプと Pixabay 検索も選択したロケールに連動
- **省電力** — ハードウェアデコード（1080p で約 2–3% CPU）、
  デスクトップが隠れたとき・ロック・スリープで自動一時停止
- **ログイン時に起動** — 設定で切替
- **ネイティブ Liquid Glass UI** — macOS Tahoe 上の SwiftUI

## インストール

1. [Releases](https://github.com/daifoll/LiquidWall/releases) から最新 `.dmg` を取得
2. 開いて **LiquidWall** を **アプリケーション** にドラッグ
3. 初回起動時に Gatekeeper の警告が出たら
   **システム設定 → プライバシーとセキュリティ → このまま開く**、または：

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> **macOS Tahoe (26.0) 以降**が必要です。

## Pixabay API キー

ギャラリーには無料の Pixabay API キーが必要です（約 2 分）：

1. [pixabay.com](https://pixabay.com/accounts/register/) で登録
2. [API ドキュメント](https://pixabay.com/api/docs/) を開く — `key` 横にキーが表示
3. プロンプトに従ってアプリに貼り付け

## ソースからビルド

Xcode 26+（Swift 6.2+）が必要です。

```bash
./build.sh
open build/LiquidWall.app
```

DMG パッケージ（[dmgbuild](https://github.com/dmgbuild/dmgbuild)、`pip3 install dmgbuild`）：

```bash
./package.sh
```

## 制限事項

- フルスクリーンアプリの上では壁紙は見えません
- 未承認の Pixabay アカウントでは写真は最大 1280 px；動画に制限なし

## 翻訳

README は 10 言語で提供 — ページ上部のリンクを参照。

> **注:** UI と README の翻訳は AI 生成のため、不正確な箇所がある場合があります。
> issue または pull request をお願いします。

## クレジット

- メディア: [Pixabay](https://pixabay.com)（Pixabay Content License）
- 作成: [daifoll](https://github.com/daifoll)
- [Cursor](https://cursor.com) の **Fable 5** による AI 支援開発

## ライセンス

[MIT](LICENSE)
