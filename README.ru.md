<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Живые видео- и фото-обои для macOS с нативным интерфейсом Liquid Glass.
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <strong>Русский</strong> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
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

Лёгкий аналог Wallpaper Engine для Mac. Превращает любое видео или изображение
в обои рабочего стола, со встроенной галереей [Pixabay](https://pixabay.com) —
поиск, предпросмотр и установка в один клик.

## Возможности

- **Видео- и фото-обои** — MP4/MOV с бесшовным лупом или статичные изображения
- **Несколько мониторов** — основной (по умолчанию), все или конкретный
- **Галерея Pixabay** — тысячи бесплатных видео и фото, бесконечный скролл,
  потоковый предпросмотр, параллельные загрузки с прогрессом
- **Вкладка «Загрузки»** — повторная установка и удаление скачанного
- **Drag & drop** — перетащите локальный файл на карточку предпросмотра
- **10 языков** — переключатель в настройках (английский, русский, китайский,
  японский, немецкий, испанский, португальский, французский, корейский, польский)
  плюс системный; справка и поиск Pixabay следуют выбранной локали
- **Энергоэффективность** — аппаратное декодирование (~2–3% CPU для 1080p),
  пауза при перекрытии рабочего стола, блокировке экрана и сне
- **Автозапуск** — опционально, в настройках
- **Нативный Liquid Glass UI** — SwiftUI на macOS Tahoe

## Установка

1. Скачайте последний `.dmg` из [Releases](https://github.com/daifoll/LiquidWall/releases)
2. Откройте и перетащите **LiquidWall** в **Программы**
3. При первом запуске Gatekeeper предупредит о неподписанном приложении.
   **Системные настройки → Конфиденциальность и безопасность → Всё равно открыть**,
   либо:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Требуется **macOS Tahoe (26.0) или новее**.

## Ключ API Pixabay

Галерее нужен бесплатный API-ключ (занимает пару минут):

1. Зарегистрируйтесь на [pixabay.com](https://pixabay.com/accounts/register/)
2. Откройте [документацию API](https://pixabay.com/api/docs/) — ключ в разделе
   *Parameters* рядом с полем `key`
3. Вставьте его в приложение при первом запуске

## Сборка из исходников

Нужен Xcode 26+ (Swift 6.2+).

```bash
./build.sh                     # соберёт build/LiquidWall.app
open build/LiquidWall.app
```

DMG (нужен [dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`):

```bash
./package.sh                   # соберёт build/LiquidWall-<версия>.dmg
```

## Как это работает

В macOS нет публичного API для видео-обоев, поэтому LiquidWall рендерит контент
в безрамочном окне на уровне рабочего стола (`kCGDesktopWindowLevel`) — над
системными обоями, под иконками и окнами. Видео через `AVQueuePlayer` +
`AVPlayerLooper` с аппаратным `AVPlayerLayer`; картинки — `CALayer` (0% CPU).

| Путь | Назначение |
| --- | --- |
| `Sources/LiquidWall/WallpaperEngine.swift` | Окна на уровне рабочего стола, воспроизведение |
| `Sources/LiquidWall/AppModel.swift` | Состояние, поиск, загрузки, библиотека |
| `Sources/LiquidWall/ContentView.swift` | Компоновка окна и сайдбар |
| `Sources/LiquidWall/GalleryView.swift` | Галерея Pixabay, предпросмотр, загрузки |
| `Sources/LiquidWall/PixabayClient.swift` | Клиент Pixabay API |
| `Sources/LiquidWall/Localization.swift` | Переключатель языка и resource bundle |
| `dmg-settings.py` | Раскладка DMG ([dmgbuild](https://github.com/dmgbuild/dmgbuild)) |

## Ограничения

- Обои не видны поверх полноэкранных приложений (окно за ними)
- Фото Pixabay ограничены 1280 px без одобренного API-аккаунта; видео — без лимита

## Переводы

README доступен на 10 языках — ссылки вверху страницы.

> **Примечание:** переводы интерфейса и README сгенерированы с помощью ИИ и могут
> содержать неточности. Если заметите ошибку — откройте issue или pull request.

## Автор

- Медиа от [Pixabay](https://pixabay.com) по лицензии Pixabay Content License
- Создано [daifoll](https://github.com/daifoll)
- Разработано с помощью AI (вайбкодинг) на модели **Fable 5** в [Cursor](https://cursor.com)

## Лицензия

[MIT](LICENSE)
