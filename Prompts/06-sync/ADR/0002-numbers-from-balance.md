# ADR 0002: Čísla v textech jen jako placeholdery z `balance.dart`

- Status: accepted (2026-10-15)
- Context: 01-scope.md, sekce 3 a 9 (rozhodnutí 2); `CLAUDE.md` („všechna laditelná čísla
  v balance.dart, žádné magic numbers jinde").

## Rozhodnutí

Věty v registru (`inGameCz`), popisy upgradů a text kapitol knihy neobsahují tuning čísla hry
natvrdo. Používají `{{balance.<konstanta>|<formát>}}`; render (`domain/lore_text.dart`) dosadí
hodnotu z generované mapy `balance_map.g.dart`. Formáty: `pct`, `pctDelta`, `s`, `degC`, `int`.
Neznámá konstanta nebo formát je chyba testu, ne tichý prázdný řetězec.

Výjimka: čísla, která nejsou tuning hry (normální teplota člověka, letopočty, velikost bakterie),
jsou v textu natvrdo se zdrojem v `sources.md`.

## Proč

Dnešní `descCz` („bere +25 % poškození po 4 s") je kopie `Balance.opsonizedDamageTakenMulti`
a `Balance.opsonizedDuration`. Jakmile se balance ladí (a bude, viz 01-PLAN §5 „tady strav nejvíc
času"), kniha i karty lžou. Pravidlo „žádné magic numbers" už platí pro kód; tímto platí i pro text.

## Důsledky

- `tool/gen_balance_map.dart` a CI gen-check; generovaný soubor se needituje ručně.
- Garant nečte placeholdery: `lore_report --render` vyrenderuje čistý Markdown.
- Věta musí přežít změnu hodnoty: dosazuje se číslo, ne sloveso. Změna znaménka (zpomalí →
  zrychlí) vyžaduje změnu textu a testu na znaménko.
