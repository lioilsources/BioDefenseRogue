#!/usr/bin/env python3
"""Vybrané mastery z art/fx/selected/ → immunorun/assets/images/{fx,bg}/ + CREDITS.md.

  python3 art/fx/install.py

Velikosti: FX sprity 128 px (ve hře mají 12–28 px), ikona mety 256 px, pozadí obrazovek
1664 px na šířku, dlaždice arény 1024 px. Sekce v CREDITS.md se pokaždé přepíše celá.
Závislosti: Pillow.
"""
import json
import sys
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
ASSETS = REPO / "immunorun" / "assets" / "images"
CREDITS = REPO / "immunorun" / "assets" / "CREDITS.md"
HEADER = "## FX, pozadí a menu"

# kind → (cílová složka, max. strana, kvalita WebP)
TARGET = {
    "fx":         ("fx", 128, 90),
    "icon":       ("fx", 256, 90),
    "background": ("bg", 1664, 80),
    "tile":       ("bg", 1024, 85),
}


def main():
    m = json.loads((ROOT / "manifest.json").read_text())
    backend = m["backend"]
    model = backend["model"].split(":")[0]
    lines = [
        HEADER,
        "Generováno podle art/fx/manifest.json (L40S, ComfyUI). Formát: soubor | model, seed | "
        "licence | prompt",
    ]
    missing = []
    for it in m["items"]:
        seed = it.get("selected")
        src = next((p for p in (ROOT / "selected").glob(it["id"] + ".*")), None)
        if seed is None or src is None:
            missing.append(it["id"])
            continue
        folder, side, quality = TARGET[it["kind"]]
        out = ASSETS / folder / f"{it['id']}.webp"
        out.parent.mkdir(parents=True, exist_ok=True)
        img = Image.open(src)
        img = img.convert("RGBA" if it.get("cutout") else "RGB")
        img.thumbnail((side, side), Image.LANCZOS)
        img.save(out, "WEBP", quality=quality, method=6)
        cut = "; výřez BiRefNet" if it.get("cutout") else ""
        lines.append(
            f"- assets/images/{folder}/{it['id']}.webp | {model}, seed {seed}{cut} | "
            f"{backend['license']} | prompt v art/fx/manifest.json"
        )
        print(f"{out.relative_to(REPO)}  {img.size[0]}×{img.size[1]}  {out.stat().st_size // 1024} kB")
    if missing:
        sys.exit(f"chybí výběr nebo master: {', '.join(missing)}")

    text = CREDITS.read_text()
    block = "\n".join(lines) + "\n"
    if HEADER in text:
        start = text.index(HEADER)
        nxt = text.find("\n## ", start + len(HEADER))
        text = text[:start] + block + (text[nxt + 1:] if nxt != -1 else "")
    else:
        text = text.rstrip("\n") + "\n\n" + block
    CREDITS.write_text(text)


if __name__ == "__main__":
    main()
