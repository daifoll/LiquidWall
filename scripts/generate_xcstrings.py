#!/usr/bin/env python3
"""Генерирует Localizable.xcstrings для LiquidWall."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "Sources" / "LiquidWall" / "Resources" / "Localizable.xcstrings"

LANGUAGES = ("en", "ru", "zh-Hans", "ja", "de", "es", "pt-BR", "fr", "ko", "pl")

# Ключ → {язык: перевод}
TRANSLATIONS: dict[str, dict[str, str]] = {
    "fill_mode.fill": {
        "en": "Fill",
        "ru": "Заполнить",
        "zh-Hans": "填充",
        "ja": "塗りつぶし",
        "de": "Füllen",
        "es": "Rellenar",
        "pt-BR": "Preencher",
        "fr": "Remplir",
        "ko": "채우기",
        "pl": "Wypełnij",
    },
    "fill_mode.fit": {
        "en": "Fit",
        "ru": "Вписать",
        "zh-Hans": "适应",
        "ja": "フィット",
        "de": "Anpassen",
        "es": "Ajustar",
        "pt-BR": "Ajustar",
        "fr": "Ajuster",
        "ko": "맞춤",
        "pl": "Dopasuj",
    },
    "gallery_category.videos": {
        "en": "Videos",
        "ru": "Видео",
        "zh-Hans": "视频",
        "ja": "動画",
        "de": "Videos",
        "es": "Videos",
        "pt-BR": "Vídeos",
        "fr": "Vidéos",
        "ko": "동영상",
        "pl": "Filmy",
    },
    "gallery_category.photos": {
        "en": "Photos",
        "ru": "Фото",
        "zh-Hans": "照片",
        "ja": "写真",
        "de": "Fotos",
        "es": "Fotos",
        "pt-BR": "Fotos",
        "fr": "Photos",
        "ko": "사진",
        "pl": "Zdjęcia",
    },
    "content_pane.gallery": {
        "en": "Gallery",
        "ru": "Галерея",
        "zh-Hans": "图库",
        "ja": "ギャラリー",
        "de": "Galerie",
        "es": "Galería",
        "pt-BR": "Galeria",
        "fr": "Galerie",
        "ko": "갤러리",
        "pl": "Galeria",
    },
    "content_pane.library": {
        "en": "Downloads",
        "ru": "Загрузки",
        "zh-Hans": "下载",
        "ja": "ダウンロード",
        "de": "Downloads",
        "es": "Descargas",
        "pt-BR": "Downloads",
        "fr": "Téléchargements",
        "ko": "다운로드",
        "pl": "Pobrane",
    },
    "display.main": {
        "en": "Main Display",
        "ru": "Основной дисплей",
        "zh-Hans": "主显示器",
        "ja": "メインディスプレイ",
        "de": "Hauptdisplay",
        "es": "Pantalla principal",
        "pt-BR": "Tela principal",
        "fr": "Écran principal",
        "ko": "기본 디스플레이",
        "pl": "Główny wyświetlacz",
    },
    "display.all": {
        "en": "All Displays",
        "ru": "Все дисплеи",
        "zh-Hans": "所有显示器",
        "ja": "すべてのディスプレイ",
        "de": "Alle Displays",
        "es": "Todas las pantallas",
        "pt-BR": "Todas as telas",
        "fr": "Tous les écrans",
        "ko": "모든 디스플레이",
        "pl": "Wszystkie wyświetlacze",
    },
    "settings.title": {
        "en": "Settings",
        "ru": "Настройки",
        "zh-Hans": "设置",
        "ja": "設定",
        "de": "Einstellungen",
        "es": "Ajustes",
        "pt-BR": "Configurações",
        "fr": "Réglages",
        "ko": "설정",
        "pl": "Ustawienia",
    },
    "settings.display": {
        "en": "Display",
        "ru": "Дисплей",
        "zh-Hans": "显示器",
        "ja": "ディスプレイ",
        "de": "Display",
        "es": "Pantalla",
        "pt-BR": "Tela",
        "fr": "Écran",
        "ko": "디스플레이",
        "pl": "Wyświetlacz",
    },
    "settings.language": {
        "en": "Language",
        "ru": "Язык",
        "zh-Hans": "语言",
        "ja": "言語",
        "de": "Sprache",
        "es": "Idioma",
        "pt-BR": "Idioma",
        "fr": "Langue",
        "ko": "언어",
        "pl": "Język",
    },
    "settings.launch_at_login": {
        "en": "Launch at login",
        "ru": "Запускать при входе",
        "zh-Hans": "登录时启动",
        "ja": "ログイン時に起動",
        "de": "Beim Anmelden starten",
        "es": "Iniciar al iniciar sesión",
        "pt-BR": "Iniciar ao fazer login",
        "fr": "Lancer à la connexion",
        "ko": "로그인 시 실행",
        "pl": "Uruchamiaj przy logowaniu",
    },
    "settings.pixabay_key": {
        "en": "Pixabay API Key",
        "ru": "Ключ API Pixabay",
        "zh-Hans": "Pixabay API 密钥",
        "ja": "Pixabay APIキー",
        "de": "Pixabay-API-Schlüssel",
        "es": "Clave API de Pixabay",
        "pt-BR": "Chave da API Pixabay",
        "fr": "Clé API Pixabay",
        "ko": "Pixabay API 키",
        "pl": "Klucz API Pixabay",
    },
    "settings.change": {
        "en": "Change",
        "ru": "Изменить",
        "zh-Hans": "更改",
        "ja": "変更",
        "de": "Ändern",
        "es": "Cambiar",
        "pt-BR": "Alterar",
        "fr": "Modifier",
        "ko": "변경",
        "pl": "Zmień",
    },
    "preview.drop_hint": {
        "en": "Drag a video or image here",
        "ru": "Перетащите видео или изображение сюда",
        "zh-Hans": "将视频或图像拖放到此处",
        "ja": "動画または画像をここにドラッグ",
        "de": "Video oder Bild hierher ziehen",
        "es": "Arrastra un vídeo o imagen aquí",
        "pt-BR": "Arraste um vídeo ou imagem aqui",
        "fr": "Glissez une vidéo ou une image ici",
        "ko": "동영상이나 이미지를 여기에 끌어다 놓으세요",
        "pl": "Przeciągnij wideo lub obraz tutaj",
    },
    "open_panel.message": {
        "en": "Choose a video or image for your wallpaper",
        "ru": "Выберите видео или изображение для обоев",
        "zh-Hans": "为您的壁纸选择视频或图像",
        "ja": "壁紙にする動画または画像を選択",
        "de": "Wähle ein Video oder Bild für dein Hintergrundbild",
        "es": "Elige un vídeo o imagen para tu fondo de pantalla",
        "pt-BR": "Escolha um vídeo ou imagem para o seu papel de parede",
        "fr": "Choisissez une vidéo ou une image pour votre fond d'écran",
        "ko": "배경화면으로 사용할 동영상이나 이미지를 선택하세요",
        "pl": "Wybierz wideo lub obraz na tapetę",
    },
    "onboarding.title": {
        "en": "Connect Pixabay Gallery",
        "ru": "Подключить галерею Pixabay",
        "zh-Hans": "连接 Pixabay 图库",
        "ja": "Pixabayギャラリーを接続",
        "de": "Pixabay-Galerie verbinden",
        "es": "Conectar la galería de Pixabay",
        "pt-BR": "Conectar a galeria Pixabay",
        "fr": "Connecter la galerie Pixabay",
        "ko": "Pixabay 갤러리 연결",
        "pl": "Połącz galerię Pixabay",
    },
    "onboarding.subtitle": {
        "en": (
            "Thousands of free videos and images for wallpapers.\n"
            "You only need a free API key — it takes a couple of minutes."
        ),
        "ru": (
            "Тысячи бесплатных видео и изображений для обоев.\n"
            "Нужен только бесплатный API-ключ — это займёт пару минут."
        ),
        "zh-Hans": (
            "数千张免费视频和图像可用于壁纸。\n"
            "您只需一个免费的 API 密钥——只需几分钟即可获取。"
        ),
        "ja": (
            "壁紙用の無料動画・画像が数千点。\n"
            "無料のAPIキーがあればOK — 数分で取得できます。"
        ),
        "de": (
            "Tausende kostenlose Videos und Bilder für Hintergrundbilder.\n"
            "Du brauchst nur einen kostenlosen API-Schlüssel — dauert nur ein paar Minuten."
        ),
        "es": (
            "Miles de vídeos e imágenes gratuitas para fondos de pantalla.\n"
            "Solo necesitas una clave API gratuita — te llevará un par de minutos."
        ),
        "pt-BR": (
            "Milhares de vídeos e imagens gratuitos para papéis de parede.\n"
            "Você só precisa de uma chave de API gratuita — leva apenas alguns minutos."
        ),
        "fr": (
            "Des milliers de vidéos et images gratuites pour vos fonds d'écran.\n"
            "Il vous suffit d'une clé API gratuite — cela ne prend que quelques minutes."
        ),
        "ko": (
            "배경화면용 무료 동영상과 이미지가 수천 개.\n"
            "무료 API 키만 있으면 됩니다 — 몇 분이면 충분합니다."
        ),
        "pl": (
            "Tysiące darmowych filmów i obrazów na tapety.\n"
            "Wystarczy darmowy klucz API — zajmie to kilka minut."
        ),
    },
    "onboarding.step1": {
        "en": "Register at pixabay.com",
        "ru": "Зарегистрируйтесь на pixabay.com",
        "zh-Hans": "在 pixabay.com 注册",
        "ja": "pixabay.comで登録",
        "de": "Auf pixabay.com registrieren",
        "es": "Regístrate en pixabay.com",
        "pt-BR": "Registre-se em pixabay.com",
        "fr": "Inscrivez-vous sur pixabay.com",
        "ko": "pixabay.com에서 가입",
        "pl": "Zarejestruj się na pixabay.com",
    },
    "onboarding.step2": {
        "en": "Open the API documentation page",
        "ru": "Откройте страницу документации API",
        "zh-Hans": "打开 API 文档页面",
        "ja": "APIドキュメントページを開く",
        "de": "API-Dokumentationsseite öffnen",
        "es": "Abre la página de documentación de la API",
        "pt-BR": "Abra a página de documentação da API",
        "fr": "Ouvrez la page de documentation de l'API",
        "ko": "API 문서 페이지 열기",
        "pl": "Otwórz stronę dokumentacji API",
    },
    "onboarding.step3": {
        "en": "Your key is shown in the Parameters section next to the key field",
        "ru": "Ключ отображается в разделе Parameters рядом с полем key",
        "zh-Hans": "密钥显示在 Parameters 部分中 key 字段旁",
        "ja": "キーはParametersセクションのkeyフィールドの横に表示されます",
        "de": "Dein Schlüssel wird im Abschnitt Parameters neben dem key-Feld angezeigt",
        "es": "Tu clave se muestra en la sección Parameters junto al campo key",
        "pt-BR": "Sua chave é exibida na seção Parameters ao lado do campo key",
        "fr": "Votre clé est affichée dans la section Parameters à côté du champ key",
        "ko": "API 키는 Parameters 섹션의 key 필드 옆에 표시됩니다",
        "pl": "Klucz jest wyświetlany w sekcji Parameters obok pola key",
    },
    "onboarding.step4": {
        "en": "Paste it here:",
        "ru": "Вставьте его сюда:",
        "zh-Hans": "在此处粘贴：",
        "ja": "ここに貼り付け：",
        "de": "Hier einfügen:",
        "es": "Pégala aquí:",
        "pt-BR": "Cole aqui:",
        "fr": "Collez-la ici :",
        "ko": "여기에 붙여넣기:",
        "pl": "Wklej go tutaj:",
    },
    "onboarding.api_key_placeholder": {
        "en": "API key",
        "ru": "API-ключ",
        "zh-Hans": "API 密钥",
        "ja": "APIキー",
        "de": "API-Schlüssel",
        "es": "Clave API",
        "pt-BR": "Chave da API",
        "fr": "Clé API",
        "ko": "API 키",
        "pl": "Klucz API",
    },
    "onboarding.save": {
        "en": "Save",
        "ru": "Сохранить",
        "zh-Hans": "保存",
        "ja": "保存",
        "de": "Speichern",
        "es": "Guardar",
        "pt-BR": "Salvar",
        "fr": "Enregistrer",
        "ko": "저장",
        "pl": "Zapisz",
    },
    "gallery.search_placeholder": {
        "en": "Search: nature, ocean, rain…",
        "ru": "Поиск: природа, океан, дождь…",
        "zh-Hans": "搜索：自然、海洋、雨…",
        "ja": "検索：自然、海、雨…",
        "de": "Suchen: Natur, Ozean, Regen…",
        "es": "Buscar: naturaleza, océano, lluvia…",
        "pt-BR": "Buscar: natureza, oceano, chuva…",
        "fr": "Rechercher : nature, océan, pluie…",
        "ko": "검색: 자연, 바다, 비…",
        "pl": "Szukaj: natura, ocean, deszcz…",
    },
    "gallery.clear_search": {
        "en": "Clear search",
        "ru": "Очистить поиск",
        "zh-Hans": "清除搜索",
        "ja": "検索をクリア",
        "de": "Suche löschen",
        "es": "Borrar búsqueda",
        "pt-BR": "Limpar busca",
        "fr": "Effacer la recherche",
        "ko": "검색 지우기",
        "pl": "Wyczyść wyszukiwanie",
    },
    "gallery.pixabay_attribution": {
        "en": "Media provided by Pixabay",
        "ru": "Медиа предоставлены Pixabay",
        "zh-Hans": "媒体内容由 Pixabay 提供",
        "ja": "メディアはPixabayが提供",
        "de": "Medien bereitgestellt von Pixabay",
        "es": "Contenido multimedia proporcionado por Pixabay",
        "pt-BR": "Mídia fornecida por Pixabay",
        "fr": "Médias fournis par Pixabay",
        "ko": "Pixabay에서 제공하는 미디어",
        "pl": "Media dostarczone przez Pixabay",
    },
    "preview.close": {
        "en": "Close",
        "ru": "Закрыть",
        "zh-Hans": "关闭",
        "ja": "閉じる",
        "de": "Schließen",
        "es": "Cerrar",
        "pt-BR": "Fechar",
        "fr": "Fermer",
        "ko": "닫기",
        "pl": "Zamknij",
    },
    "preview.apply": {
        "en": "Apply",
        "ru": "Применить",
        "zh-Hans": "应用",
        "ja": "適用",
        "de": "Anwenden",
        "es": "Aplicar",
        "pt-BR": "Aplicar",
        "fr": "Appliquer",
        "ko": "적용",
        "pl": "Zastosuj",
    },
    "library.empty": {
        "en": "Nothing downloaded yet",
        "ru": "Пока ничего не скачано",
        "zh-Hans": "尚未下载任何内容",
        "ja": "まだダウンロードされていません",
        "de": "Noch nichts heruntergeladen",
        "es": "Aún no hay descargas",
        "pt-BR": "Nada baixado ainda",
        "fr": "Rien n'a encore été téléchargé",
        "ko": "아직 다운로드한 항목이 없습니다",
        "pl": "Nic jeszcze nie pobrano",
    },
    "error.no_results": {
        "en": "No results found, try a different query",
        "ru": "Ничего не найдено, попробуйте другой запрос",
        "zh-Hans": "未找到结果，请尝试其他搜索词",
        "ja": "結果が見つかりません。別のキーワードを試してください",
        "de": "Keine Ergebnisse gefunden, versuche eine andere Suche",
        "es": "No se encontraron resultados, prueba otra búsqueda",
        "pt-BR": "Nenhum resultado encontrado, tente outra pesquisa",
        "fr": "Aucun résultat trouvé, essayez une autre recherche",
        "ko": "결과가 없습니다. 다른 검색어를 시도해 보세요",
        "pl": "Nie znaleziono wyników, spróbuj innego zapytania",
    },
    "error.download_failed": {
        "en": "Download failed: %@",
        "ru": "Не удалось скачать: %@",
        "zh-Hans": "下载失败：%@",
        "ja": "ダウンロードに失敗しました：%@",
        "de": "Download fehlgeschlagen: %@",
        "es": "Error al descargar: %@",
        "pt-BR": "Falha no download: %@",
        "fr": "Échec du téléchargement : %@",
        "ko": "다운로드 실패: %@",
        "pl": "Pobieranie nie powiodło się: %@",
    },
    "pixabay.error.invalid_key": {
        "en": "Invalid API key",
        "ru": "Недействительный API-ключ",
        "zh-Hans": "无效的 API 密钥",
        "ja": "無効なAPIキー",
        "de": "Ungültiger API-Schlüssel",
        "es": "Clave API no válida",
        "pt-BR": "Chave de API inválida",
        "fr": "Clé API invalide",
        "ko": "잘못된 API 키",
        "pl": "Nieprawidłowy klucz API",
    },
    "pixabay.error.rate_limited": {
        "en": "Rate limit exceeded, wait a minute",
        "ru": "Превышен лимит запросов, подождите минуту",
        "zh-Hans": "超出速率限制，请等待一分钟",
        "ja": "レート制限を超えました。1分お待ちください",
        "de": "Ratenlimit überschritten, warte eine Minute",
        "es": "Límite de solicitudes superado, espera un minuto",
        "pt-BR": "Limite de requisições excedido, aguarde um minuto",
        "fr": "Limite de requêtes dépassée, attendez une minute",
        "ko": "요청 한도를 초과했습니다. 1분 후 다시 시도하세요",
        "pl": "Przekroczono limit zapytań, odczekaj minutę",
    },
    "pixabay.error.server": {
        "en": "Server error (%lld)",
        "ru": "Ошибка сервера (%lld)",
        "zh-Hans": "服务器错误（%lld）",
        "ja": "サーバーエラー（%lld）",
        "de": "Serverfehler (%lld)",
        "es": "Error del servidor (%lld)",
        "pt-BR": "Erro no servidor (%lld)",
        "fr": "Erreur serveur (%lld)",
        "ko": "서버 오류 (%lld)",
        "pl": "Błąd serwera (%lld)",
    },
    "pixabay.error.bad_url": {
        "en": "Invalid file URL",
        "ru": "Недействительный URL файла",
        "zh-Hans": "无效的文件 URL",
        "ja": "無効なファイルURL",
        "de": "Ungültige Datei-URL",
        "es": "URL de archivo no válida",
        "pt-BR": "URL de arquivo inválida",
        "fr": "URL de fichier invalide",
        "ko": "잘못된 파일 URL",
        "pl": "Nieprawidłowy adres URL pliku",
    },
    "help.subtitle": {
        "en": "Live wallpapers for macOS · v%@",
        "ru": "Живые обои для macOS · v%@",
        "zh-Hans": "macOS 动态壁纸 · v%@",
        "ja": "macOS用ライブ壁紙 · v%@",
        "de": "Live-Hintergrundbilder für macOS · v%@",
        "es": "Fondos de pantalla animados para macOS · v%@",
        "pt-BR": "Papéis de parede animados para macOS · v%@",
        "fr": "Fonds d'écran animés pour macOS · v%@",
        "ko": "macOS용 라이브 배경화면 · v%@",
        "pl": "Animowane tapety dla macOS · v%@",
    },
    "help.about.title": {
        "en": "About",
        "ru": "О приложении",
        "zh-Hans": "关于",
        "ja": "このアプリについて",
        "de": "Über",
        "es": "Acerca de",
        "pt-BR": "Sobre",
        "fr": "À propos",
        "ko": "정보",
        "pl": "O aplikacji",
    },
    "help.about.body": {
        "en": (
            "LiquidWall turns any video or image into a live desktop wallpaper. "
            "Content is rendered in a borderless window at the desktop level — above the system "
            "wallpaper, below your icons and app windows. Video decoding is fully hardware-accelerated "
            "(AVFoundation), so CPU usage stays minimal."
        ),
        "ru": (
            "LiquidWall превращает любое видео или изображение в живые обои рабочего стола. "
            "Контент отображается в безрамочном окне на уровне рабочего стола — поверх системных "
            "обоев, но под иконками и окнами приложений. Декодирование видео полностью аппаратное "
            "(AVFoundation), поэтому нагрузка на процессор минимальна."
        ),
        "zh-Hans": (
            "LiquidWall 可将任何视频或图像变为动态桌面壁纸。内容在桌面层级通过无边框窗口渲染——"
            "位于系统壁纸之上、图标和应用窗口之下。视频解码完全由硬件加速（AVFoundation），CPU 占用极低。"
        ),
        "ja": (
            "LiquidWallは動画や画像をライブデスクトップ壁紙に変換します。コンテンツはデスクトップレベルの"
            "ボーダーレスウィンドウで描画され、システム壁紙の上、アイコンとアプリウィンドウの下に表示されます。"
            "動画デコードは完全にハードウェアアクセラレーション（AVFoundation）され、CPU使用率は最小限です。"
        ),
        "de": (
            "LiquidWall verwandelt jedes Video oder Bild in ein Live-Hintergrundbild. Der Inhalt wird "
            "in einem rahmenlosen Fenster auf Desktop-Ebene gerendert — über dem System-Hintergrundbild, "
            "unter deinen Symbolen und App-Fenstern. Die Videodekodierung ist vollständig hardwarebeschleunigt "
            "(AVFoundation), sodass die CPU-Auslastung minimal bleibt."
        ),
        "es": (
            "LiquidWall convierte cualquier vídeo o imagen en un fondo de pantalla animado. El contenido "
            "se renderiza en una ventana sin bordes a nivel de escritorio, por encima del fondo del sistema "
            "y debajo de tus iconos y ventanas de aplicaciones. La decodificación de vídeo está totalmente "
            "acelerada por hardware (AVFoundation), por lo que el uso de CPU es mínimo."
        ),
        "pt-BR": (
            "O LiquidWall transforma qualquer vídeo ou imagem em um papel de parede animado. O conteúdo "
            "é renderizado em uma janela sem bordas no nível da área de trabalho — acima do papel de parede "
            "do sistema, abaixo dos ícones e janelas de aplicativos. A decodificação de vídeo é totalmente "
            "acelerada por hardware (AVFoundation), mantendo o uso da CPU ao mínimo."
        ),
        "fr": (
            "LiquidWall transforme n'importe quelle vidéo ou image en fond d'écran animé. Le contenu est "
            "affiché dans une fenêtre sans bordure au niveau du bureau — au-dessus du fond d'écran système, "
            "sous vos icônes et fenêtres d'applications. Le décodage vidéo est entièrement accéléré par le "
            "matériel (AVFoundation), pour une utilisation minimale du processeur."
        ),
        "ko": (
            "LiquidWall은 동영상이나 이미지를 라이브 데스크톱 배경화면으로 바꿔 줍니다. 콘텐츠는 데스크톱 "
            "수준의 테두리 없는 창에 렌더링되어 시스템 배경화면 위, 아이콘과 앱 창 아래에 표시됩니다. "
            "동영상 디코딩은 완전히 하드웨어 가속(AVFoundation)되어 CPU 사용량을 최소화합니다."
        ),
        "pl": (
            "LiquidWall zamienia dowolne wideo lub obraz w animowaną tapetę pulpitu. Treść jest renderowana "
            "w oknie bez ramek na poziomie pulpitu — nad tapetą systemową, pod ikonami i oknami aplikacji. "
            "Dekodowanie wideo jest w pełni sprzętowo przyspieszone (AVFoundation), więc obciążenie procesora "
            "pozostaje minimalne."
        ),
    },
    "help.getting_started.title": {
        "en": "Getting Started",
        "ru": "Начало работы",
        "zh-Hans": "入门指南",
        "ja": "はじめに",
        "de": "Erste Schritte",
        "es": "Primeros pasos",
        "pt-BR": "Primeiros passos",
        "fr": "Premiers pas",
        "ko": "시작하기",
        "pl": "Pierwsze kroki",
    },
    "help.getting_started.body": {
        "en": (
            "• Drag & drop a video (MP4, MOV) or image onto the preview card, or click the folder "
            "button to pick a file.\n"
            "• Browse the built-in Pixabay gallery: search thousands of free videos and photos, preview "
            "them, and apply in one click. A free API key is required.\n"
            "• Downloaded files are kept in the Library tab, where you can re-apply or delete them."
        ),
        "ru": (
            "• Перетащите видео (MP4, MOV) или изображение на карточку предпросмотра или нажмите кнопку "
            "папки, чтобы выбрать файл.\n"
            "• Просматривайте встроенную галерею Pixabay: ищите среди тысяч бесплатных видео и фото, "
            "просматривайте и применяйте одним кликом. Требуется бесплатный API-ключ.\n"
            "• Скачанные файлы хранятся на вкладке «Загрузки», где их можно снова применить или удалить."
        ),
        "zh-Hans": (
            "• 将视频（MP4、MOV）或图像拖放到预览卡片上，或点击文件夹按钮选择文件。\n"
            "• 浏览内置 Pixabay 图库：搜索数千张免费视频和照片，预览并一键应用。需要免费的 API 密钥。\n"
            "• 下载的文件保存在「下载」标签页中，您可以重新应用或删除它们。"
        ),
        "ja": (
            "• 動画（MP4、MOV）または画像をプレビューカードにドラッグ＆ドロップするか、フォルダボタンを"
            "クリックしてファイルを選択します。\n"
            "• 内蔵のPixabayギャラリーを閲覧：数千の無料動画・写真を検索し、プレビューしてワンクリックで"
            "適用。無料のAPIキーが必要です。\n"
            "• ダウンロードしたファイルはライブラリタブに保存され、再適用や削除ができます。"
        ),
        "de": (
            "• Ziehe ein Video (MP4, MOV) oder Bild auf die Vorschaukarte oder klicke auf die "
            "Ordnerschaltfläche, um eine Datei auszuwählen.\n"
            "• Durchsuche die integrierte Pixabay-Galerie: Suche Tausende kostenloser Videos und Fotos, "
            "sieh sie dir an und wende sie mit einem Klick an. Ein kostenloser API-Schlüssel ist erforderlich.\n"
            "• Heruntergeladene Dateien werden im Tab \"Downloads\" gespeichert, wo du sie erneut anwenden "
            "oder löschen kannst."
        ),
        "es": (
            "• Arrastra y suelta un vídeo (MP4, MOV) o imagen en la tarjeta de vista previa, o haz clic "
            "en el botón de carpeta para elegir un archivo.\n"
            "• Explora la galería integrada de Pixabay: busca miles de vídeos y fotos gratuitos, "
            "previsualízalos y aplícalos con un clic. Se requiere una clave API gratuita.\n"
            "• Los archivos descargados se guardan en la pestaña Descargas, donde puedes volver a "
            "aplicarlos o eliminarlos."
        ),
        "pt-BR": (
            "• Arraste e solte um vídeo (MP4, MOV) ou imagem no cartão de pré-visualização, ou clique no "
            "botão de pasta para escolher um arquivo.\n"
            "• Navegue pela galeria Pixabay integrada: pesquise milhares de vídeos e fotos gratuitos, "
            "visualize e aplique com um clique. É necessária uma chave de API gratuita.\n"
            "• Os arquivos baixados ficam na aba Downloads, onde você pode reaplicá-los ou excluí-los."
        ),
        "fr": (
            "• Glissez-déposez une vidéo (MP4, MOV) ou une image sur la carte d'aperçu, ou cliquez sur le "
            "bouton dossier pour choisir un fichier.\n"
            "• Parcourez la galerie Pixabay intégrée : recherchez des milliers de vidéos et photos gratuites, "
            "prévisualisez-les et appliquez-les en un clic. Une clé API gratuite est requise.\n"
            "• Les fichiers téléchargés sont conservés dans l'onglet Téléchargements, où vous pouvez les "
            "réappliquer ou les supprimer."
        ),
        "ko": (
            "• 동영상(MP4, MOV)이나 이미지를 미리보기 카드에 끌어다 놓거나 폴더 버튼을 클릭해 파일을 "
            "선택하세요.\n"
            "• 내장 Pixabay 갤러리를 탐색하세요: 수천 개의 무료 동영상과 사진을 검색하고, 미리보기한 뒤 "
            "한 번의 클릭으로 적용하세요. 무료 API 키가 필요합니다.\n"
            "• 다운로드한 파일은 다운로드 탭에 보관되며, 다시 적용하거나 삭제할 수 있습니다."
        ),
        "pl": (
            "• Przeciągnij i upuść wideo (MP4, MOV) lub obraz na kartę podglądu albo kliknij przycisk "
            "folderu, aby wybrać plik.\n"
            "• Przeglądaj wbudowaną galerię Pixabay: wyszukuj tysiące darmowych filmów i zdjęć, podglądaj "
            "je i stosuj jednym kliknięciem. Wymagany jest darmowy klucz API.\n"
            "• Pobrane pliki są przechowywane na karcie Pobrane, gdzie możesz je ponownie zastosować "
            "lub usunąć."
        ),
    },
    "help.displays.title": {
        "en": "Displays",
        "ru": "Дисплеи",
        "zh-Hans": "显示器",
        "ja": "ディスプレイ",
        "de": "Displays",
        "es": "Pantallas",
        "pt-BR": "Telas",
        "fr": "Écrans",
        "ko": "디스플레이",
        "pl": "Wyświetlacze",
    },
    "help.displays.body": {
        "en": (
            "By default the wallpaper is shown on the main display. Use the Screen picker in Settings "
            "to target all displays or a specific one."
        ),
        "ru": (
            "По умолчанию обои отображаются на основном дисплее. В настройках используйте выбор экрана, "
            "чтобы применить ко всем дисплеям или к конкретному."
        ),
        "zh-Hans": "默认情况下，壁纸显示在主显示器上。在设置中使用屏幕选择器，可选择所有显示器或特定显示器。",
        "ja": (
            "デフォルトでは壁紙はメインディスプレイに表示されます。設定の画面ピッカーで、すべての"
            "ディスプレイまたは特定のディスプレイを選択できます。"
        ),
        "de": (
            "Standardmäßig wird das Hintergrundbild auf dem Hauptdisplay angezeigt. Verwende in den "
            "Einstellungen die Bildschirmauswahl, um alle Displays oder ein bestimmtes zu wählen."
        ),
        "es": (
            "Por defecto, el fondo de pantalla se muestra en la pantalla principal. Usa el selector de "
            "pantalla en Ajustes para elegir todas las pantallas o una específica."
        ),
        "pt-BR": (
            "Por padrão, o papel de parede é exibido na tela principal. Use o seletor de tela em "
            "Configurações para aplicar em todas as telas ou em uma específica."
        ),
        "fr": (
            "Par défaut, le fond d'écran s'affiche sur l'écran principal. Utilisez le sélecteur d'écran "
            "dans les Réglages pour cibler tous les écrans ou un écran spécifique."
        ),
        "ko": (
            "기본적으로 배경화면은 기본 디스플레이에 표시됩니다. 설정의 화면 선택기를 사용해 모든 "
            "디스플레이 또는 특정 디스플레이를 지정할 수 있습니다."
        ),
        "pl": (
            "Domyślnie tapeta jest wyświetlana na głównym wyświetlaczu. W ustawieniach użyj selektora "
            "ekranu, aby wybrać wszystkie wyświetlacze lub konkretny."
        ),
    },
    "help.power.title": {
        "en": "Power Efficiency",
        "ru": "Энергоэффективность",
        "zh-Hans": "能效",
        "ja": "電力効率",
        "de": "Energieeffizienz",
        "es": "Eficiencia energética",
        "pt-BR": "Eficiência energética",
        "fr": "Efficacité énergétique",
        "ko": "전력 효율",
        "pl": "Oszczędność energii",
    },
    "help.power.body": {
        "en": (
            "Playback pauses automatically when the desktop is fully covered by windows or a full-screen "
            "app, when the screen is locked, and during sleep. The wallpaper never prevents your display "
            "from sleeping."
        ),
        "ru": (
            "Воспроизведение автоматически приостанавливается, когда рабочий стол полностью закрыт "
            "окнами или полноэкранным приложением, при блокировке экрана и во время сна. Обои никогда "
            "не мешают отключению дисплея."
        ),
        "zh-Hans": (
            "当桌面被窗口或全屏应用完全覆盖、屏幕锁定时以及睡眠期间，播放会自动暂停。"
            "壁纸绝不会阻止显示器进入睡眠。"
        ),
        "ja": (
            "デスクトップがウィンドウやフルスクリーンアプリで完全に覆われたとき、画面がロックされたとき、"
            "スリープ中に再生は自動的に一時停止します。壁紙がディスプレイのスリープを妨げることはありません。"
        ),
        "de": (
            "Die Wiedergabe wird automatisch pausiert, wenn der Desktop vollständig von Fenstern oder einer "
            "Vollbild-App bedeckt ist, wenn der Bildschirm gesperrt ist und im Ruhezustand. Das "
            "Hintergrundbild verhindert niemals, dass dein Display in den Schlafmodus wechselt."
        ),
        "es": (
            "La reproducción se pausa automáticamente cuando el escritorio está completamente cubierto por "
            "ventanas o una aplicación a pantalla completa, cuando la pantalla está bloqueada y durante el "
            "modo de suspensión. El fondo de pantalla nunca impide que tu pantalla se apague."
        ),
        "pt-BR": (
            "A reprodução é pausada automaticamente quando a área de trabalho está totalmente coberta por "
            "janelas ou um aplicativo em tela cheia, quando a tela está bloqueada e durante o sono. O papel "
            "de parede nunca impede que a tela entre em modo de suspensão."
        ),
        "fr": (
            "La lecture s'interrompt automatiquement lorsque le bureau est entièrement recouvert par des "
            "fenêtres ou une application en plein écran, lorsque l'écran est verrouillé et pendant la "
            "veille. Le fond d'écran n'empêche jamais votre écran de se mettre en veille."
        ),
        "ko": (
            "데스크톱이 창이나 전체 화면 앱에 완전히 가려지거나, 화면이 잠기거나, 절전 중일 때 재생이 "
            "자동으로 일시 정지됩니다. 배경화면은 디스플레이가 절전 모드로 들어가는 것을 방해하지 않습니다."
        ),
        "pl": (
            "Odtwarzanie jest automatycznie wstrzymywane, gdy pulpit jest w pełni zakryty oknami lub "
            "aplikacją pełnoekranową, gdy ekran jest zablokowany oraz podczas uśpienia. Tapeta nigdy nie "
            "uniemożliwia przejścia wyświetlacza w tryb uśpienia."
        ),
    },
    "help.notes.title": {
        "en": "Notes",
        "ru": "Примечания",
        "zh-Hans": "说明",
        "ja": "注意事項",
        "de": "Hinweise",
        "es": "Notas",
        "pt-BR": "Observações",
        "fr": "Remarques",
        "ko": "참고 사항",
        "pl": "Uwagi",
    },
    "help.notes.body": {
        "en": (
            "• The wallpaper is not visible over full-screen apps.\n"
            "• Media provided by Pixabay under the Pixabay Content License."
        ),
        "ru": (
            "• Обои не видны поверх полноэкранных приложений.\n"
            "• Медиа предоставлены Pixabay по лицензии Pixabay Content License."
        ),
        "zh-Hans": (
            "• 壁纸在全屏应用上方不可见。\n"
            "• 媒体内容由 Pixabay 根据 Pixabay Content License 提供。"
        ),
        "ja": (
            "• 壁紙はフルスクリーンアプリの上では表示されません。\n"
            "• メディアはPixabay Content LicenseのもとPixabayが提供しています。"
        ),
        "de": (
            "• Das Hintergrundbild ist über Vollbild-Apps nicht sichtbar.\n"
            "• Medien bereitgestellt von Pixabay unter der Pixabay Content License."
        ),
        "es": (
            "• El fondo de pantalla no es visible sobre aplicaciones a pantalla completa.\n"
            "• Contenido multimedia proporcionado por Pixabay bajo la Licencia de Contenido de Pixabay."
        ),
        "pt-BR": (
            "• O papel de parede não fica visível sobre aplicativos em tela cheia.\n"
            "• Mídia fornecida por Pixabay sob a Pixabay Content License."
        ),
        "fr": (
            "• Le fond d'écran n'est pas visible par-dessus les applications en plein écran.\n"
            "• Médias fournis par Pixabay sous la licence Pixabay Content License."
        ),
        "ko": (
            "• 배경화면은 전체 화면 앱 위에서는 보이지 않습니다.\n"
            "• 미디어는 Pixabay Content License에 따라 Pixabay에서 제공합니다."
        ),
        "pl": (
            "• Tapeta nie jest widoczna nad aplikacjami pełnoekranowymi.\n"
            "• Media dostarczone przez Pixabay na licencji Pixabay Content License."
        ),
    },
    "help.created_by": {
        "en": "Created by daifoll",
        "ru": "Создано daifoll",
        "zh-Hans": "作者：daifoll",
        "ja": "作成者：daifoll",
        "de": "Erstellt von daifoll",
        "es": "Creado por daifoll",
        "pt-BR": "Criado por daifoll",
        "fr": "Créé par daifoll",
        "ko": "제작: daifoll",
        "pl": "Stworzone przez daifoll",
    },
    "help.ai_dev_credit": {
        "en": "Built with AI-assisted development (vibe coding) using the Fable 5 model in Cursor.",
        "ru": "Создано с помощью AI-разработки (vibe coding) с использованием модели Fable 5 в Cursor.",
        "zh-Hans": "使用 Cursor 中的 Fable 5 模型通过 AI 辅助开发（vibe coding）构建。",
        "ja": "CursorのFable 5モデルを使用したAI支援開発（vibe coding）で構築。",
        "de": (
            "Entwickelt mit KI-gestützter Entwicklung (Vibe Coding) unter Verwendung des Fable-5-Modells "
            "in Cursor."
        ),
        "es": "Desarrollado con desarrollo asistido por IA (vibe coding) usando el modelo Fable 5 en Cursor.",
        "pt-BR": (
            "Desenvolvido com desenvolvimento assistido por IA (vibe coding) usando o modelo Fable 5 no Cursor."
        ),
        "fr": (
            "Développé avec une assistance IA (vibe coding) grâce au modèle Fable 5 dans Cursor."
        ),
        "ko": "Cursor의 Fable 5 모델을 사용한 AI 지원 개발(vibe coding)로 제작되었습니다.",
        "pl": (
            "Zbudowano z pomocą rozwoju wspomaganego AI (vibe coding) przy użyciu modelu Fable 5 w Cursor."
        ),
    },
    "help.ai_translation_note": {
        "en": "UI translations were generated with AI and may contain inaccuracies.",
        "ru": "Переводы интерфейса сгенерированы с помощью ИИ и могут содержать неточности.",
        "zh-Hans": "界面翻译由 AI 生成，可能包含不准确之处。",
        "ja": "UIの翻訳はAIで生成されており、不正確な箇所がある場合があります。",
        "de": "UI-Übersetzungen wurden mit KI generiert und können Ungenauigkeiten enthalten.",
        "es": "Las traducciones de la interfaz se generaron con IA y pueden contener imprecisiones.",
        "pt-BR": "As traduções da interface foram geradas com IA e podem conter imprecisões.",
        "fr": "Les traductions de l'interface ont été générées par IA et peuvent contenir des inexactitudes.",
        "ko": "UI 번역은 AI로 생성되었으며 부정확한 부분이 있을 수 있습니다.",
        "pl": "Tłumaczenia interfejsu zostały wygenerowane przez AI i mogą zawierać nieścisłości.",
    },
    "menu.help": {
        "en": "LiquidWall Help",
        "ru": "Справка LiquidWall",
        "zh-Hans": "LiquidWall 帮助",
        "ja": "LiquidWallヘルプ",
        "de": "LiquidWall-Hilfe",
        "es": "Ayuda de LiquidWall",
        "pt-BR": "Ajuda do LiquidWall",
        "fr": "Aide LiquidWall",
        "ko": "LiquidWall 도움말",
        "pl": "Pomoc LiquidWall",
    },
    "language.system": {
        "en": "System",
        "ru": "Системный",
        "zh-Hans": "跟随系统",
        "ja": "システム",
        "de": "System",
        "es": "Sistema",
        "pt-BR": "Sistema",
        "fr": "Système",
        "ko": "시스템",
        "pl": "Systemowy",
    },
    "duration.seconds": {
        "en": "%lld s",
        "ru": "%lld с",
        "zh-Hans": "%lld 秒",
        "ja": "%lld秒",
        "de": "%lld s",
        "es": "%lld s",
        "pt-BR": "%lld s",
        "fr": "%lld s",
        "ko": "%lld초",
        "pl": "%lld s",
    },
    "app.version": {
        "en": "LiquidWall %@",
        "ru": "LiquidWall %@",
        "zh-Hans": "LiquidWall %@",
        "ja": "LiquidWall %@",
        "de": "LiquidWall %@",
        "es": "LiquidWall %@",
        "pt-BR": "LiquidWall %@",
        "fr": "LiquidWall %@",
        "ko": "LiquidWall %@",
        "pl": "LiquidWall %@",
    },
}


def build_catalog() -> dict:
    strings: dict[str, dict] = {}

    for key, locales in TRANSLATIONS.items():
        missing = [lang for lang in LANGUAGES if lang not in locales]
        if missing:
            raise ValueError(f"Ключ {key!r}: отсутствуют переводы для {missing}")

        strings[key] = {
            "extractionState": "manual",
            "localizations": {
                lang: {
                    "stringUnit": {
                        "state": "translated",
                        "value": locales[lang],
                    }
                }
                for lang in LANGUAGES
            },
        }

    return {
        "sourceLanguage": "en",
        "strings": strings,
        "version": "1.0",
    }


def main() -> None:
    catalog = build_catalog()
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(
        json.dumps(catalog, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    size = OUTPUT.stat().st_size
    print(f"Wrote {OUTPUT}")
    print(f"Keys: {len(catalog['strings'])}")
    print(f"Languages: {len(LANGUAGES)}")
    print(f"Size: {size:,} bytes")


if __name__ == "__main__":
    main()
