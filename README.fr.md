<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Fonds d'écran vidéo et photo animés pour macOS avec interface Liquid Glass native.
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <a href="README.pt-BR.md">Português (Brasil)</a> ·
  <strong>Français</strong> ·
  <a href="README.ko.md">한국어</a> ·
  <a href="README.pl.md">Polski</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-26%2B-blue" alt="macOS 26+">
  <img src="https://img.shields.io/badge/Swift-6.2-orange" alt="Swift 6.2">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="MIT License">
</p>

---

Alternative légère à Wallpaper Engine pour Mac. Transforme toute vidéo ou image
en fond d'écran, avec une galerie [Pixabay](https://pixabay.com) intégrée :
recherche, aperçu et application en un clic.

## Fonctionnalités

- **Fonds vidéo et photo** — MP4/MOV en boucle fluide ou images statiques
- **Multi-écrans** — principal (par défaut), tous ou un écran précis
- **Galerie Pixabay** — milliers de vidéos et photos gratuites, défilement infini,
  aperçu en streaming, téléchargements parallèles avec progression
- **Onglet Bibliothèque** — réappliquer ou supprimer les médias téléchargés
- **Glisser-déposer** — déposez un fichier local sur la carte d'aperçu
- **10 langues** — sélecteur dans l'app (anglais, russe, chinois, japonais, allemand,
  espagnol, portugais, français, coréen, polonais) plus Système ; l'aide et
  la recherche Pixabay suivent la langue choisie
- **Économe en énergie** — décodage matériel (~2–3 % CPU en 1080p), pause automatique
  lorsque le bureau est couvert, écran verrouillé ou veille
- **Lancer à la connexion** — optionnel dans les réglages
- **UI Liquid Glass native** — SwiftUI sur macOS Tahoe

## Installation

1. Téléchargez le dernier `.dmg` sur [Releases](https://github.com/daifoll/LiquidWall/releases)
2. Ouvrez-le et glissez **LiquidWall** dans **Applications**
3. Au premier lancement, Gatekeeper avertira. **Réglages système → Confidentialité et sécurité → Ouvrir quand même**, ou :

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Nécessite **macOS Tahoe (26.0) ou ultérieur**.

## Clé API Pixabay

La galerie nécessite une clé API Pixabay gratuite (deux minutes) :

1. Inscrivez-vous sur [pixabay.com](https://pixabay.com/accounts/register/)
2. Ouvrez la [documentation API](https://pixabay.com/api/docs/) — la clé est à côté de `key`
3. Collez-la dans l'app lorsque demandé

## Compiler depuis les sources

Xcode 26+ (Swift 6.2+) requis.

```bash
./build.sh
open build/LiquidWall.app
```

Créer un DMG ([dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`) :

```bash
./package.sh
```

## Limitations

- Le fond n'est pas visible par-dessus les apps plein écran
- Photos Pixabay limitées à 1280 px sans compte API approuvé ; pas de limite pour les vidéos

## Traductions

README disponible en 10 langues — liens en haut de page.

> **Note :** les traductions de l'interface et du README ont été générées par IA et peuvent
> contenir des imprécisions. Ouvrez une issue ou une pull request en cas d'erreur.

## Crédits

- Médias fournis par [Pixabay](https://pixabay.com) (Pixabay Content License)
- Créé par [daifoll](https://github.com/daifoll)
- Développement assisté par IA avec **Fable 5** dans [Cursor](https://cursor.com)

## Licence

[MIT](LICENSE)
