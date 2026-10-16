# Lexikon zdraví – formát obsahu

Obsah knihy ve hře IMMUNORUN. Úplná pravidla jsou v `Prompts/05-kniha/03-redakcni-standard.md`,
tady je jen stručný přehled pro autora, který nezná Dart.

## Soubory

- `cs/<id>.md` – kapitola, např. `cs/05-horecka.md`. Id kapitol jsou pevná (`00-mikroskop` až
  `12-pamet-a-ockovani`).
- `cs/glossary.md` – slovníček: `## Název {#id}` a pod ním 1–2 věty definice.
- `images/<id>-hero.webp`, `images/<id>-schema-<n>.webp` – obrázky (od K4).

## Kapitola

Na začátku je hlavička (YAML) mezi `---` a `---`: `id`, `title`, `part` (1–4), `palette`
(mint/sky/peach/lavender podle části), `hero`, `lore` (id pojmů z registru hry) a `quiz`
(3 otázky × 3 odpovědi, právě jedna `correct: true`, věta `why`).

Pod ní jsou stránky oddělené řádkem `---`. Každá stránka začíná `## Nadpis {#kotva}`.

| Zápis | Význam |
|---|---|
| `**pyrogen**`, `**pyrogeny\|pyrogen**` | heslo slovníčku (za svislítkem id hesla) |
| `*Staphylococcus aureus*` | latinský název |
| `![Popisek](05-horecka-schema-1.webp)` | schéma |
| `> [!doopravdy]`, `> [!vedel]`, `> [!zvedave]`, `> [!prakticky]` | box |
| `<!-- src: JANEWAY s. 85 -->`, `<!-- TODO-FACT: JANEWAY – co ověřit -->` | zdroj odstavce (klíče v `Prompts/05-kniha/sources.md`) |
| `{{balance.feverFebrilStart\|degC}}` | číslo ze hry (dosadí se z `balance.dart`) |

Nic jiného (tabulky, odkazy, číslované seznamy) se v kapitole nepoužívá. Kontrolu dělá
`flutter test test/book/`.
