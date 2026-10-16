#!/usr/bin/env python3
"""Obrázky knihy Lexikon zdraví podle art/book/manifest.json (05-kniha K4, ADR 0004).

  python3 art/book/gen.py submit [id…]      # odešle joby (jen v okně backendu), stáhne do drafts/raw/
  python3 art/book/gen.py post [id…]        # gradient map / zmenšení / WebP → drafts/post/
  python3 art/book/gen.py sheet [id…]       # kontaktní arch variant pro výběr → drafts/sheet_<id>.png
  python3 art/book/gen.py select <id> <seed>  # zapíše výběr do manifestu
  python3 art/book/gen.py install           # vybrané varianty → immunorun/assets/book/images/ + CREDITS.md

Fronta na SPARKu je sdílená: dávku předem ohlásit session Director, nejvýš 2 souběžné joby,
neposílat duplikáty (Prompts/04-PLAN-grafika.md §3.3). Každý výstup projít očima: žádný text,
popisek ani měřítko v obrázku (ADR 0004); vadnou variantu nevybírat.

Závislosti: stdlib + Pillow.
"""
import json
import sys
import time
import urllib.request
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime
from pathlib import Path

from PIL import Image, ImageDraw, ImageOps

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent.parent
MANIFEST_PATH = ROOT / "manifest.json"
DRAFTS = ROOT / "drafts"
IMAGES = REPO / "immunorun" / "assets" / "book" / "images"
CREDITS = REPO / "immunorun" / "assets" / "CREDITS.md"
CREDITS_HEADER = "## Kniha (Lexikon zdraví)"

MAX_CONCURRENT = 2
POLL_INTERVAL_S = 5
POLL_TIMEOUT_S = 45 * 60
HTTP_TIMEOUT_S = 60


def load():
    return json.loads(MANIFEST_PATH.read_text())


def save(m):
    MANIFEST_PATH.write_text(json.dumps(m, indent=2, ensure_ascii=False) + "\n")


def pick(m, ids):
    images = m["images"]
    if not ids:
        return images
    known = {e["id"] for e in images}
    unknown = [i for i in ids if i not in known]
    if unknown:
        sys.exit(f"neznámé id: {', '.join(unknown)}")
    return [e for e in images if e["id"] in ids]


def prompt_of(m, e):
    return f'{m["styles"][e["style"]]}, {e["subject"]}'


def in_window(windows, now=None):
    h = (now or datetime.now()).hour
    return any(a <= h < b or a <= h + 24 < b for a, b in windows)


def raw_path(e, seed):
    return DRAFTS / "raw" / f'{e["id"]}_{seed}.jpg'


def post_path(e, seed):
    return DRAFTS / "post" / f'{e["id"]}_{seed}.webp'


# ─── HTTP ────────────────────────────────────────────────────────────────────

def http(method, url, body=None, raw=False):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method,
                                 headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=HTTP_TIMEOUT_S) as r:
        payload = r.read()
    return payload if raw else json.loads(payload)


# flux-schnell NIM bere jen strany 768–1344 po 64 px (1024×640 vrací 422): generuje se nejbližší
# povolený rozměr se stejným poměrem stran a po stažení se ořízne a zmenší na e["size"].
NIM_SIDES = range(768, 1345, 64)


def gen_size(w, h):
    if w in NIM_SIDES and h in NIM_SIDES:
        return w, h
    return min(((a, b) for a in NIM_SIDES for b in NIM_SIDES),
               key=lambda s: (abs(s[0] / s[1] - w / h), -s[0] * s[1]))


def run_job(m, e, seed):
    out = raw_path(e, seed)
    if out.exists():
        return f"{out.name}: už stažen"
    base = m["backend"]["url"]
    w, h = e["size"]
    gw, gh = gen_size(w, h)
    job = http("POST", f"{base}/v1/infer", {
        "prompt": prompt_of(m, e), "width": gw, "height": gh,
        "seed": seed, "steps": m["backend"]["steps"],
    })
    deadline = time.time() + POLL_TIMEOUT_S
    while time.time() < deadline:
        st = http("GET", f'{base}/jobs/{job["id"]}')
        if st.get("status") == "done":
            out.parent.mkdir(parents=True, exist_ok=True)
            out.write_bytes(http("GET", f'{base}/jobs/{job["id"]}/result', raw=True))
            if (gw, gh) != (w, h):
                ImageOps.fit(Image.open(out).convert("RGB"), (w, h), Image.LANCZOS).save(out, "JPEG", quality=95)
            return f"{out.name}: hotovo"
        if st.get("status") == "error":
            return f"{out.name}: CHYBA {st}"
        time.sleep(POLL_INTERVAL_S)
    return f"{out.name}: timeout"


def cmd_submit(ids):
    m = load()
    if m["backend"]["model"] not in m["models_allowed"]:
        sys.exit("model backendu není v models_allowed (OQ-2)")
    if not in_window(m["backend"]["windows"]):
        sys.exit(f'mimo okno backendu {m["backend"]["windows"]} – zkus později')
    jobs = [(e, s) for e in pick(m, ids) for s in e["seeds"] if not raw_path(e, s).exists()]
    print(f"{len(jobs)} jobů (max {MAX_CONCURRENT} souběžně)")
    with ThreadPoolExecutor(MAX_CONCURRENT) as pool:
        for msg in pool.map(lambda j: run_job(m, *j), jobs):
            print(msg, flush=True)


# ─── Postprocess ─────────────────────────────────────────────────────────────

def hex_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def gradmap(img, ramp):
    """Šedá → barva přes lineární rampu (paleta hry, plán grafiky §1)."""
    gray = ImageOps.grayscale(img)
    stops = [hex_rgb(c) for c in ramp]
    n = len(stops) - 1
    lut = []
    for ch in range(3):
        for v in range(256):
            t = v / 255 * n
            i = min(int(t), n - 1)
            f = t - i
            lut.append(round(stops[i][ch] * (1 - f) + stops[i + 1][ch] * f))
    return Image.merge("RGB", [gray.point(lut[c * 256:(c + 1) * 256]) for c in range(3)])


def process(m, e, seed):
    src = raw_path(e, seed)
    if not src.exists():
        return None
    img = Image.open(src).convert("RGB")
    quality = 80
    for step in e["post"]:
        name, _, arg = step.partition(":")
        if name == "gradmap":
            img = gradmap(img, m["ramps"][e["ramp"]])
        elif name == "resize":
            w = int(arg)
            img = img.resize((w, round(img.height * w / img.width)), Image.LANCZOS)
        elif name == "webp":
            quality = int(arg)
        else:
            sys.exit(f"{e['id']}: neznámý krok {step}")
    out = post_path(e, seed)
    out.parent.mkdir(parents=True, exist_ok=True)
    img.save(out, "WEBP", quality=quality, method=6)
    return out


def cmd_post(ids):
    m = load()
    for e in pick(m, ids):
        for s in e["seeds"]:
            out = process(m, e, s)
            if out:
                print(f"{out.name}: {out.stat().st_size // 1024} kB")


def cmd_sheet(ids):
    m = load()
    for e in pick(m, ids):
        tiles = [(s, post_path(e, s)) for s in e["seeds"] if post_path(e, s).exists()]
        if not tiles:
            continue
        ims = [Image.open(p).convert("RGB") for _, p in tiles]
        tw, th = ims[0].size
        sheet = Image.new("RGB", (tw * 2 + 30, (th + 40) * ((len(ims) + 1) // 2) + 10), "white")
        d = ImageDraw.Draw(sheet)
        for i, ((seed, _), im) in enumerate(zip(tiles, ims)):
            x, y = 10 + (i % 2) * (tw + 10), 10 + (i // 2) * (th + 40)
            sheet.paste(im, (x, y))
            d.text((x, y + th + 8), f"seed {seed}", fill="black")
        out = DRAFTS / f'sheet_{e["id"]}.png'
        sheet.save(out)
        print(out)


def cmd_select(image_id, seed):
    m = load()
    e = pick(m, [image_id])[0]
    if int(seed) not in e["seeds"]:
        sys.exit(f"seed {seed} není mezi {e['seeds']}")
    e["selected"] = int(seed)
    save(m)
    print(f"{image_id}: vybrán seed {seed}")


def credit_line(m, e):
    b = m["backend"]
    lic = b["license"] + ("" if b["license_verified"] else " (licence neověřena, 05-kniha OQ-2)")
    return (f'- assets/book/images/{e["id"]}.webp | {b["model"]}, seed {e["selected"]}, '
            f'{e["register"]} | {lic} | prompt v art/book/manifest.json')


def cmd_install():
    m = load()
    IMAGES.mkdir(parents=True, exist_ok=True)
    lines = []
    for e in m["images"]:
        if e["selected"] is None:
            continue
        src = post_path(e, e["selected"])
        if not src.exists():
            sys.exit(f'{e["id"]}: chybí {src} – spusť post')
        (IMAGES / f'{e["id"]}.webp').write_bytes(src.read_bytes())
        lines.append(credit_line(m, e))
    text = CREDITS.read_text()
    head, _, rest = text.partition(CREDITS_HEADER)
    _, nxt, tail = rest.partition("\n## ")  # sekce za knihou zůstanou
    block = (f"{CREDITS_HEADER}\n"
             "Generováno z art/book/manifest.json (art/book/gen.py). Formát: soubor | model, seed, registr "
             "| licence | prompt\n" + "\n".join(lines) + "\n")
    CREDITS.write_text(head.rstrip("\n") + "\n\n" + block + (f"\n## {tail}" if nxt else ""))
    print(f"{len(lines)} obrázků v {IMAGES.relative_to(REPO)}, CREDITS.md aktualizován")


def main(argv):
    if not argv:
        sys.exit(__doc__)
    cmd, args = argv[0], argv[1:]
    if cmd == "submit":
        cmd_submit(args)
    elif cmd == "post":
        cmd_post(args)
    elif cmd == "sheet":
        cmd_sheet(args)
    elif cmd == "select" and len(args) == 2:
        cmd_select(*args)
    elif cmd == "install":
        cmd_install()
    else:
        sys.exit(__doc__)


if __name__ == "__main__":
    main(sys.argv[1:])
