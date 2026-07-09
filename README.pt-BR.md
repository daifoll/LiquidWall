<p align="center">
  <img src="docs/icon.png" width="128" alt="LiquidWall icon">
</p>

<h1 align="center">LiquidWall</h1>

<p align="center">
  Papéis de parede ao vivo (vídeo e foto) para macOS com interface Liquid Glass nativa.
</p>

<p align="center">
  <a href="README.md">English</a> ·
  <a href="README.ru.md">Русский</a> ·
  <a href="README.zh-Hans.md">简体中文</a> ·
  <a href="README.ja.md">日本語</a> ·
  <a href="README.de.md">Deutsch</a> ·
  <a href="README.es.md">Español</a> ·
  <strong>Português (Brasil)</strong> ·
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

Alternativa leve ao Wallpaper Engine para Mac. Transforma qualquer vídeo ou imagem
em papel de parede, com galeria [Pixabay](https://pixabay.com) integrada:
pesquisar, pré-visualizar e aplicar com um clique.

## Recursos

- **Papéis de vídeo e foto** — MP4/MOV em loop contínuo ou imagens estáticas
- **Vários monitores** — principal (padrão), todos ou um específico
- **Galeria Pixabay** — milhares de vídeos e fotos gratuitos, rolagem infinita,
  prévia em streaming, downloads paralelos com progresso
- **Aba Biblioteca** — reaplicar ou excluir mídia baixada
- **Arrastar e soltar** — solte um arquivo local no cartão de prévia
- **10 idiomas** — seletor no app (inglês, russo, chinês, japonês, alemão,
  espanhol, português, francês, coreano, polonês) mais Sistema; ajuda e
  busca Pixabay seguem o idioma escolhido
- **Eficiência energética** — decodificação por hardware (~2–3% CPU em 1080p),
  pausa automática com desktop coberto, tela bloqueada ou suspensão
- **Iniciar ao fazer login** — opcional nas configurações
- **UI Liquid Glass nativa** — SwiftUI no macOS Tahoe

## Instalação

1. Baixe o `.dmg` mais recente em [Releases](https://github.com/daifoll/LiquidWall/releases)
2. Abra e arraste **LiquidWall** para **Aplicativos**
3. No primeiro uso, o Gatekeeper avisará. **Ajustes do Sistema → Privacidade e Segurança → Abrir Mesmo Assim**, ou:

```bash
xattr -d com.apple.quarantine /Applications/LiquidWall.app
```

> Requer **macOS Tahoe (26.0) ou superior**.

## Chave API Pixabay

A galeria precisa de uma chave API gratuita do Pixabay (dois minutos):

1. Cadastre-se em [pixabay.com](https://pixabay.com/accounts/register/)
2. Abra a [documentação da API](https://pixabay.com/api/docs/) — a chave fica ao lado de `key`
3. Cole no app quando solicitado

## Compilar do código-fonte

Requer Xcode 26+ (Swift 6.2+).

```bash
./build.sh
open build/LiquidWall.app
```

Empacotar DMG ([dmgbuild](https://github.com/dmgbuild/dmgbuild), `pip3 install dmgbuild`):

```bash
./package.sh
```

## Limitações

- O papel de parede não aparece sobre apps em tela cheia
- Fotos Pixabay limitadas a 1280 px sem conta API aprovada; vídeos sem limite

## Traduções

README disponível em 10 idiomas — links no topo da página.

> **Nota:** traduções da interface e do README foram geradas por IA e podem conter imprecisões.
> Abra uma issue ou pull request se encontrar um erro.

## Créditos

- Mídia fornecida por [Pixabay](https://pixabay.com) (Pixabay Content License)
- Criado por [daifoll](https://github.com/daifoll)
- Desenvolvimento assistido por IA com **Fable 5** no [Cursor](https://cursor.com)

## Licença

[MIT](LICENSE)
