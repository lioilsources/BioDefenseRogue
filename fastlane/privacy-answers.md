# Odpovědi do formulářů o soukromí (App Privacy, Data safety)

Připravené odpovědi pro první build s anonymními statistikami hraní
(`docs/telemetry.md`, plán `DevConventions/Prompts/04-PLAN-analytika.md` §7).
**Vyplnit až po zveřejnění nové `docs/privacy.html`** a před odesláním buildu
s klíčem. Odpovídají `immunorun/ios/Runner/PrivacyInfo.xcprivacy` a
`immunorun/macos/Runner/PrivacyInfo.xcprivacy`. Před vyplněním ověř aktuální
znění formulářů.

**Pozor na cílovou skupinu.** Texty obchodu říkají „pro děti od 10 let i
dospělé“. Než se nastaví klíč, rozhoduje vlastník o zařazení (Apple Kids
category, Google Play Target audience a Families; plán 04 §10.3, OQ-8 v
`Prompts/05-kniha/open-questions.md`). Když na Play bude cílová skupina
zahrnovat děti pod 13, na Androidu se neměří (jako Lexify) a Data safety
zůstává bez statistik.

**Privacy Policy URL:** `https://lioilsources.github.io/BioDefenseRogue/privacy.html`
(GitHub Pages z `main` `/docs` je potřeba zapnout).

## App Store Connect → App Privacy

**Do you or your third-party partners collect data from this app?** **Yes.**

| Category → type | Linked to the user? | Used for tracking? | Purpose |
|---|---|---|---|
| Usage Data → **Product Interaction** | **No** | **No** | **Analytics** |
| Diagnostics → **Performance Data** | **No** | **No** | **Analytics** |
| Location → **Coarse Location** | **No** | **No** | **Analytics** |

Proč:

- *Product Interaction*: spuštění, obrazovky a čas na nich, začátek a konec
  runu, výběr upgradu a dveří, otevření knihy, kvíz, velikost písma, zvuk.
- *Performance Data*: čas od spuštění po menu v milisekundách (`menu_ready`).
- *Coarse Location*: vlastní příjemce vývojáře odvodí zemi z IP spojení,
  uloží jen zemi, IP neukládá. Když vlastník zemi na příjemci vypne,
  odškrtnout a odebrat `NSPrivacyCollectedDataTypeCoarseLocation` z obou
  manifestů.

Nesbírá se (nechat neoznačené): Contact Info, Health & Fitness, Financial
Info, Precise Location, Sensitive Info, Contacts, User Content, Browsing
History, Search History, Identifiers (žádné User ID ani Device ID: ID relace
je náhodné, jen v paměti a nikdy se znovu nepoužije), Purchases, Other Usage
Data, Crash Data, Other Diagnostic Data, Other Data.

**Linked to the user: No** u všech typů: žádný účet, žádný identifikátor,
dvě relace nejde spojit.

**Tracking: No.** Nic se nekombinuje s daty jiných firem, nejsou reklamy,
ATT dialog není potřeba (`NSPrivacyTracking` je `false`).

## Google Play Console → Data safety

Statistiky přijímá a ukládá jen vývojář na vlastním serveru v EU (Česko),
žádná třetí strana je nedostane, proto *collected*, ne *shared*.

- Does your app collect or share any of the required user data types? **Yes.**
- Is all user data encrypted in transit? **Yes** (klient odmítne host bez `https`).
- Do you provide a way for users to request that their data is deleted?
  **No.** Appka nemá účet, statistiky nenesou identifikátor, takže záznam
  nejde dohledat k osobě. Jdou vypnout v hlavním menu (smaže neodeslané
  záznamy v zařízení) a po 12 měsících se mažou.
- Datové typy, všechny **Collected**, **not shared**:

| Data type | Purpose | Ephemeral? | Required or optional |
|---|---|---|---|
| App activity → **App interactions** | **Analytics** | No | **Optional** (přepínač STATISTIKY v hlavním menu) |
| App info and performance → **Diagnostics** | **Analytics** | No | **Optional** (týž přepínač; čas načítání) |
| Location → **Approximate location** | **Analytics** | No | **Optional** (týž přepínač; země z IP, IP se neukládá) |

Když vlastník zemi na příjemci vypne, řádek *Approximate location* vypustit.

Nesbírá se: přesná poloha, osobní údaje, finanční údaje (appka nemá nákupy),
ID zařízení ani jiná ID, kontakty, soubory, zprávy, historie prohlížení.
**Advertising ID: No.**
