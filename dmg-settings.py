# Настройки dmgbuild: раскладка окна установщика
# Использование: dmgbuild -s dmg-settings.py -D app=build/LiquidWall.app "LiquidWall" out.dmg
import os.path

app = defines.get("app", "build/LiquidWall.app")  # noqa: F821
appname = os.path.basename(app)

format = "UDZO"
files = [app]
symlinks = {"Applications": "/Applications"}

badge_icon = "Resources/AppIcon.icns"
background = "Resources/dmg-background.png"

window_rect = ((200, 200), (660, 400))
icon_size = 110
text_size = 13

icon_locations = {
    appname: (165, 175),
    "Applications": (495, 175),
}

default_view = "icon-view"
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False
