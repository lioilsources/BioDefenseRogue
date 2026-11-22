#!/usr/bin/env python3
"""Nahraje screenshoty z fastlane/metadata do App Store Connect a Google Play (nahradí stávající).
Nic neodesílá ke kontrole.

  python3 tool/upload_store_screenshots.py ios      # env APP_STORE_CONNECT_API_KEY_PATH (fastlane api_key json)
  python3 tool/upload_store_screenshots.py android  # env SUPPLY_JSON_KEY (service account json)
  --dry-run  jen vypíše, co by nahrál

iOS: do verze ve stavu k úpravě (PREPARE_FOR_SUBMISSION…), jen do lokalizací, které ve verzi už existují.
Android: přes edit (images deleteall + upload + commit) do listingů, které v Play existují.
Soubory vyrábí tool/store_screenshots.sh.
"""
import base64, hashlib, json, os, subprocess, sys, tempfile, time, urllib.parse, urllib.request, urllib.error
from pathlib import Path

BUNDLE = "com.ol1n.bioDefenseRogue"
META = Path(__file__).resolve().parents[2] / "fastlane" / "metadata"
DRY = "--dry-run" in sys.argv

# ─── App Store Connect ──────────────────────────────────────────────────────
IOS_SETS = {"iphone69": "APP_IPHONE_67", "ipad13": "APP_IPAD_PRO_3GEN_129"}  # 6,9" / 13"
EDITABLE = {"PREPARE_FOR_SUBMISSION", "DEVELOPER_REJECTED", "REJECTED", "METADATA_REJECTED", "INVALID_BINARY"}


def asc_token():
    k = json.load(open(os.environ["APP_STORE_CONNECT_API_KEY_PATH"]))
    b = lambda x: base64.urlsafe_b64encode(x).rstrip(b"=")
    h = b(json.dumps({"alg": "ES256", "kid": k["key_id"], "typ": "JWT"}).encode())
    now = int(time.time())
    c = b(json.dumps({"iss": k["issuer_id"], "iat": now, "exp": now + 1100, "aud": "appstoreconnect-v1"}).encode())
    with tempfile.NamedTemporaryFile("w", delete=False) as f:
        f.write(k["key"])
    der = subprocess.run(["openssl", "dgst", "-sha256", "-sign", f.name], input=h + b"." + c,
                         capture_output=True, check=True).stdout
    os.unlink(f.name)
    i, sig = (2 if der[1] < 0x80 else 3), b""
    for _ in range(2):
        n = der[i + 1]; sig += der[i + 2:i + 2 + n].lstrip(b"\0").rjust(32, b"\0"); i += 2 + n
    return (h + b"." + c + b"." + b(sig)).decode()


def asc(path, method="GET", body=None, tok=[]):
    tok = tok or tok.append(asc_token()) or tok
    url = path if path.startswith("http") else "https://api.appstoreconnect.apple.com" + path
    req = urllib.request.Request(url, json.dumps(body).encode() if body else None,
                                 {"Authorization": "Bearer " + tok[0], "Content-Type": "application/json"}, method=method)
    try:
        r = urllib.request.urlopen(req).read()
        return json.loads(r) if r else {}
    except urllib.error.HTTPError as e:
        raise SystemExit(f"{method} {path}: {e.code} {e.read().decode()[:600]}")


def upload_ios():
    app = asc(f"/v1/apps?filter[bundleId]={BUNDLE}")["data"]
    if not app:
        raise SystemExit(f"{BUNDLE} v App Store Connect neexistuje")
    versions = [v for v in asc(f"/v1/apps/{app[0]['id']}/appStoreVersions?filter[platform]=IOS")["data"]
                if v["attributes"]["appStoreState"] in EDITABLE]
    if not versions:
        raise SystemExit("žádná verze k úpravě")
    v = versions[0]
    print(f"verze {v['attributes']['versionString']} ({v['attributes']['appStoreState']})")
    locs = {l["attributes"]["locale"]: l["id"] for l in
            asc(f"/v1/appStoreVersions/{v['id']}/appStoreVersionLocalizations?limit=50")["data"]}
    for d in sorted((META / "ios").glob("*/screenshots")):
        locale = d.parent.name
        if locale not in locs:
            print(f"  {locale}: lokalizace ve verzi není, přeskočeno")
            continue
        sets = {s["attributes"]["screenshotDisplayType"]: s["id"] for s in
                asc(f"/v1/appStoreVersionLocalizations/{locs[locale]}/appScreenshotSets")["data"]}
        for prefix, display in IOS_SETS.items():
            files = sorted(d.glob(f"{prefix}_*.png"))
            if not files:
                continue
            print(f"  {locale} {display}: {len(files)} ×")
            if DRY:
                continue
            sid = sets.get(display) or asc("/v1/appScreenshotSets", "POST", {"data": {
                "type": "appScreenshotSets", "attributes": {"screenshotDisplayType": display},
                "relationships": {"appStoreVersionLocalization": {"data": {
                    "type": "appStoreVersionLocalizations", "id": locs[locale]}}}}})["data"]["id"]
            for old in asc(f"/v1/appScreenshotSets/{sid}/appScreenshots?limit=50")["data"]:
                asc(f"/v1/appScreenshots/{old['id']}", "DELETE")
            for f in files:
                data = f.read_bytes()
                shot = asc("/v1/appScreenshots", "POST", {"data": {
                    "type": "appScreenshots", "attributes": {"fileName": f.name, "fileSize": len(data)},
                    "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": sid}}}}})["data"]
                for op in shot["attributes"]["uploadOperations"]:
                    part = data[op["offset"]:op["offset"] + op["length"]]
                    hdr = {h["name"]: h["value"] for h in op["requestHeaders"]}
                    urllib.request.urlopen(urllib.request.Request(op["url"], part, hdr, method=op["method"]))
                asc(f"/v1/appScreenshots/{shot['id']}", "PATCH", {"data": {
                    "type": "appScreenshots", "id": shot["id"],
                    "attributes": {"uploaded": True, "sourceFileChecksum": hashlib.md5(data).hexdigest()}}})
    print("hotovo (ke kontrole nic neodesláno)")


# ─── Google Play ────────────────────────────────────────────────────────────
PLAY_TYPES = ["phoneScreenshots", "sevenInchScreenshots", "tenInchScreenshots"]


def play_token():
    k = json.load(open(os.environ["SUPPLY_JSON_KEY"]))
    b = lambda x: base64.urlsafe_b64encode(x).rstrip(b"=")
    now = int(time.time())
    h = b(json.dumps({"alg": "RS256", "typ": "JWT"}).encode())
    c = b(json.dumps({"iss": k["client_email"], "scope": "https://www.googleapis.com/auth/androidpublisher",
                      "aud": "https://oauth2.googleapis.com/token", "iat": now, "exp": now + 3600}).encode())
    with tempfile.NamedTemporaryFile("w", delete=False) as f:
        f.write(k["private_key"])
    sig = subprocess.run(["openssl", "dgst", "-sha256", "-sign", f.name], input=h + b"." + c,
                         capture_output=True, check=True).stdout
    os.unlink(f.name)
    body = urllib.parse.urlencode({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                                   "assertion": (h + b"." + c + b"." + b(sig)).decode()}).encode()
    return json.load(urllib.request.urlopen("https://oauth2.googleapis.com/token", body))["access_token"]


def upload_android():
    tok = play_token()
    base = f"https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{BUNDLE}/edits"

    def call(url, method="GET", data=None, ctype="application/json"):
        req = urllib.request.Request(url, data, {"Authorization": "Bearer " + tok, "Content-Type": ctype}, method=method)
        try:
            r = urllib.request.urlopen(req).read()
            return json.loads(r) if r else {}
        except urllib.error.HTTPError as e:
            raise SystemExit(f"{method} {url}: {e.code} {e.read().decode()[:400]}")

    edit = call(base, "POST", b"{}")["id"]
    langs = {l["language"] for l in call(f"{base}/{edit}/listings").get("listings", [])}
    changed = False
    for d in sorted((META / "android").glob("*/images")):
        lang = d.parent.name
        for kind in PLAY_TYPES:
            files = sorted((d / kind).glob("*.png"))
            if not files:
                continue
            if lang not in langs:
                print(f"  {lang}: listing v Play není, přeskočeno")
                break
            print(f"  {lang} {kind}: {len(files)} ×")
            if DRY:
                continue
            call(f"{base}/{edit}/listings/{lang}/{kind}", "DELETE")
            for f in files:
                call(f"https://androidpublisher.googleapis.com/upload/androidpublisher/v3/applications/{BUNDLE}"
                     f"/edits/{edit}/listings/{lang}/{kind}?uploadType=media", "POST", f.read_bytes(), "image/png")
            changed = True
    if changed and not DRY:
        call(f"{base}/{edit}:commit", "POST", b"")
        print("edit commitnut")
    else:
        call(f"{base}/{edit}", "DELETE")


if __name__ == "__main__":
    target = next((a for a in sys.argv[1:] if not a.startswith("-")), "")
    {"ios": upload_ios, "android": upload_android}.get(target, lambda: sys.exit(__doc__))()
