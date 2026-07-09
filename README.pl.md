<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Żywe tapety wideo i zdjęć na macOS z natywnym interfejsem Liquid Glass.
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
  <a href="README.ko.md">한국어</a> ·
  <strong>Polski</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26+">
  <img src="https://img.shields.io/badge/Swift-6.2-orange" alt="Swift 6.2">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

Lekka alternatywa dla Wallpaper Engine na Maca. Zamienia dowolne wideo lub obraz
w tapetę pulpitu, ze wbudowaną galerią [Pixabay](https://pixabay.com):
wyszukiwanie, podgląd i zastosowanie jednym kliknięciem.

## Funkcje

- **Tapety wideo i zdjęć** — MP4/MOV w pętli lub statyczne obrazy
- **Wiele monitorów** — główny (domyślnie), wszystkie lub wybrany
- **Galeria Pixabay** — tysiące darmowych wideo i zdjęć, nieskończony scroll,
  podgląd strumieniowy przed zastosowaniem, równoległe pobieranie z postępem
- **Zakładka Biblioteka** — ponowne zastosowanie lub usunięcie pobranych mediów
- **Przeciągnij i upuść** — upuść lokalny plik na kartę podglądu
- **10 języków** — przełącznik w aplikacji (angielski, rosyjski, chiński, japoński,
  niemiecki, hiszpański, portugalski, francuski, koreański, polski) plus System;
  pomoc i wyszukiwanie Pixabay podążają za wybraną lokalizacją
- **Oszczędność energii** — dekodowanie sprzętowe (~2–3% CPU przy 1080p),
  automatyczna pauza przy zasłoniętym pulpicie, blokadzie ekranu i uśpieniu
- **Uruchamianie przy logowaniu** — opcjonalnie w ustawieniach
- **Natywny interfejs Liquid Glass** — SwiftUI na macOS Tahoe

## Instalacja

1. Pobierz najnowszy `.dmg` z [Releases](https://github.com/daifoll/LiquidWall/releases)
2. Otwórz i przeciągnij **LiquidWall** do **Aplikacje**
3. Przy pierwszym uruchomieniu Gatekeeper ostrzeże. **Ustawienia systemowe → Prywatność i ochrona → Otwórz mimo to**, lub:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Wymaga **macOS Tahoe (26.0) lub nowszego**.

## Klucz API Pixabay

Galeria wymaga darmowego klucza API Pixabay (ok. 2 minuty):

1. Zarejestruj się na [pixabay.com](https://pixabay.com/accounts/register/)
2. Otwórz [dokumentację API](https://pixabay.com/api/docs/) — klucz obok pola `key`
3. Wklej w aplikacji po monicie

## Budowanie ze źródeł

Wymaga Xcode 26+ (Swift 6.2+).

```bash
./build.sh
open build/LiquidWall.app
```

Pakiet DMG ([dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`):

```bash
./package.sh
```

## Ograniczenia

- Tapeta niewidoczna nad aplikacjami pełnoekranowymi
- Zdjęcia Pixabay do 1280 px bez zatwierdzonego konta API; wideo bez limitu

## Tłumaczenia

README w 10 językach — linki u góry strony.

> **Uwaga:** tłumaczenia interfejsu i README wygenerowano przez AI i mogą zawierać
> nieścisłości. Zgłoś błąd przez issue lub pull request.

## Autorzy

- Media: [Pixabay](https://pixabay.com) (Pixabay Content License)
- Autor: [daifoll](https://github.com/daifoll)
- Rozwój wspomagany AI z modelem **Fable 5** w [Cursor](https://cursor.com)

## Licencja

[MIT](LICENSE)
