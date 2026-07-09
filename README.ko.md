<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  macOS용 라이브 동영상·사진 배경화면, 네이티브 Liquid Glass UI.
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português (Brasil)</a> ·
  <a href="README.fr.md">Français</a> ·
  <strong>한국어</strong> ·
  <a href="README.pl.md">Polski</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26+">
  <img src="https://img.shields.io/badge/Swift-6.2-orange" alt="Swift 6.2">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

Mac용 가벼운 Wallpaper Engine 대안. 동영상이나 이미지를 바탕화면으로 설정하고,
내장 [Pixabay](https://pixabay.com) 갤러리에서 검색·미리보기·원클릭 적용.

## 기능

- **동영상·사진 배경화면** — MP4/MOV 끊김 없는 루프 또는 정적 이미지
- **다중 디스플레이** — 기본 주 모니터, 전체 또는 특정 화면
- **Pixabay 갤러리** — 수천 개의 무료 동영상·사진, 무한 스크롤,
  적용 전 스트리밍 미리보기, 병렬 다운로드 및 진행률
- **라이브러리 탭** — 다운로드한 미디어 재적용·삭제
- **드래그 앤 드롭** — 로컬 파일을 미리보기 카드에 놓기
- **10개 언어** — 앱 내 언어 전환(영·러·중·일·독·서·포·불·한·폴) 및 시스템 따르기;
  도움말과 Pixabay 검색이 선택한 로케일을 따름
- **전력 효율** — 하드웨어 디코딩(1080p 약 2–3% CPU),
  바탕화면 가림·잠금·절전 시 자동 일시정지
- **로그인 시 실행** — 설정에서 선택
- **네이티브 Liquid Glass UI** — macOS Tahoe SwiftUI

## 설치

1. [Releases](https://github.com/daifoll/LiquidWall/releases)에서 최신 `.dmg` 다운로드
2. 열어 **LiquidWall**을 **응용 프로그램**으로 드래그
3. 첫 실행 시 Gatekeeper 경고. **시스템 설정 → 개인 정보 보호 및 보안 → 그래도 열기**, 또는:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> **macOS Tahoe (26.0) 이상** 필요.

## Pixabay API 키

갤러리에 무료 Pixabay API 키가 필요합니다(약 2분):

1. [pixabay.com](https://pixabay.com/accounts/register/) 가입
2. [API 문서](https://pixabay.com/api/docs/) 열기 — `key` 옆에 키 표시
3. 안내에 따라 앱에 붙여넣기

## 소스에서 빌드

Xcode 26+(Swift 6.2+) 필요.

```bash
./build.sh
open build/LiquidWall.app
```

DMG 패키징([dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`):

```bash
./package.sh
```

## 제한 사항

- 전체 화면 앱 위에서는 배경화면이 보이지 않음
- 승인되지 않은 Pixabay 계정은 사진 최대 1280px; 동영상은 제한 없음

## 번역

README 10개 언어 제공 — 페이지 상단 링크 참고.

> **참고:** UI 및 README 번역은 AI로 생성되었으며 부정확할 수 있습니다.
> 오류 발견 시 issue 또는 pull request를 열어 주세요.

## 크레딧

- 미디어: [Pixabay](https://pixabay.com)(Pixabay Content License)
- 제작: [daifoll](https://github.com/daifoll)
- [Cursor](https://cursor.com) **Fable 5** AI 보조 개발

## 라이선스

[MIT](LICENSE)
