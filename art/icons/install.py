#!/usr/bin/env python3
"""Vybrané ikony (art/icons/selected/*.png, 1024 RGBA) → immunorun/assets/images/icons/ + CREDITS.md.

  python3 art/icons/install.py

Zmenší na 512 px (sprite ve hře má nejvýš ~100 pt, tedy ≤ 400 px při DPR 4) a uloží WebP
s alfou. Sekci „Ikony“ v CREDITS.md přepíše podle manifestu (model, licence, seed).

Závislosti: stdlib + Pillow.
"""
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
OUT = REPO / "immunorun" / "assets" / "images" / "icons"
CREDITS = REPO / "immunorun" / "assets" / "CREDITS.md"
CREDITS_HEADER = "## Ikony buněk a patogenů"

SIZE = 512
QUALITY = 85


def main():
    m = json.loads((ROOT / "manifest.json").read_text())
    OUT.mkdir(parents=True, exist_ok=True)
    backend = m["backend"]
    lines = [
        CREDITS_HEADER,
        "Generováno podle art/icons/manifest.json (L40S, ComfyUI). Formát: soubor | model, seed | licence | prompt",
    ]
    for e in m["icons"]:
        seed = e.get("selected")
        if seed is None:
            raise SystemExit(f"{e['id']}: chybí selected")
        src = ROOT / "selected" / f"{e['id']}.png"
        img = Image.open(src).convert("RGBA").resize((SIZE, SIZE), Image.LANCZOS)
        img.save(OUT / f"{e['id']}.webp", "WEBP", quality=QUALITY, method=6)
        lines.append(
            f"- assets/images/icons/{e['id']}.webp | Qwen-Image fp8, seed {seed}; výřez BiRefNet"
            f" | {backend['license']} | prompt v art/icons/manifest.json"
        )
        print(f"{e['id']}.webp  {(OUT / (e['id'] + '.webp')).stat().st_size // 1024} kB")

    text = CREDITS.read_text()
    block = "\n".join(lines) + "\n"
    if CREDITS_HEADER in text:
        head, rest = text.split(CREDITS_HEADER, 1)
        nxt = rest.find("\n## ")
        tail = rest[nxt + 1:] if nxt >= 0 else ""
        text = head + block + ("\n" + tail if tail else "")
    else:
        text = text.rstrip("\n") + "\n\n" + block
    CREDITS.write_text(text)


if __name__ == "__main__":
    main()
