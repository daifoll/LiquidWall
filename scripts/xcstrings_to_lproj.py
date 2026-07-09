#!/usr/bin/env python3
"""Компилирует Localizable.xcstrings в .lproj/Localizable.strings для SPM swift build."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def escape(value: str) -> str:
    return (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )


def main() -> None:
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <Localizable.xcstrings> <output-dir>", file=sys.stderr)
        sys.exit(1)

    xcstrings_path = Path(sys.argv[1])
    output_dir = Path(sys.argv[2])
    catalog = json.loads(xcstrings_path.read_text(encoding="utf-8"))
    strings = catalog.get("strings", {})

    locales: set[str] = set()
    for entry in strings.values():
        locales.update(entry.get("localizations", {}).keys())

    if not locales:
        print("No localizations found in catalog", file=sys.stderr)
        sys.exit(1)

    for locale in sorted(locales):
        lproj = output_dir / f"{locale}.lproj"
        lproj.mkdir(parents=True, exist_ok=True)
        lines: list[str] = []
        for key in sorted(strings.keys()):
            entry = strings[key]
            loc = entry.get("localizations", {}).get(locale)
            if loc is None:
                loc = entry.get("localizations", {}).get("en")
            if loc is None:
                continue
            unit = loc.get("stringUnit")
            if unit is None:
                continue
            value = unit.get("value", key)
            lines.append(f'"{escape(key)}" = "{escape(value)}";')
        (lproj / "Localizable.strings").write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"Wrote {lproj / 'Localizable.strings'} ({len(lines)} keys)")


if __name__ == "__main__":
    main()
