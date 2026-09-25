# Specifikace zpracování otázek ZOZ

Vstup: `/home/claude/zoz/questions_raw.json` (pole objektů {n, text, images, page}). Obrázky k otázkám: `/home/claude/zoz/img/qNNN_k.png` – VŽDY si obrázek prohlédni (Read), bez něj otázku nejde zodpovědět.
Kontext: `/home/claude/zoz/PREDPISY_GUIDE.md` a mapy `/home/claude/zoz/prehled/*.md` (řádky v txt → Read s offset/limit). Texty předpisů `/home/claude/zoz/txt/*.txt`, OCR skenů `/home/claude/zoz/ocr/*.txt`. Přílohy V2 dekódované: `/home/claude/zoz/txt/V2_dekod.txt`.

## Výstup: JSON pole do `/home/claude/zoz/answers/batch_<od>_<do>.json`
Každý objekt:
```json
{
  "n": 28,
  "otazka": "text otázky beze změny",
  "obrazky": ["img/q028_1.png"],
  "tema": "jedna z: Návěsti | Jízda vlaku | GSM-R a rádio | Písemné rozkazy | Výprava a odjezd | PMD | Posun | Brzdy | Vozidla a VZ | Elektrický provoz | Mimořádné události | Doprovod vlaku | Sunuté vlaky | Ostatní",
  "predpis": "SŽ D1",
  "zdroje": [ {"predpis": "SŽ D1", "clanek": "čl. 410 odst. (3)"} ],
  "odpoved": "Zkrácená správná odpověď, 1–3 řádky (max ~250 znaků). Konkrétní čísla, rychlosti, vzdálenosti, kdo/komu/co. Formulace jako věta – tak, jak by zněla správná možnost v testu.",
  "plne_zneni": "Doslovná citace relevantního článku/odstavce z předpisu (klidně 5–15 řádků; vynech nepodstatné pododstavce, vynechávky označ […]). Uveď na začátku 'SŽ D1 čl. 410 odst. (3):'. Více zdrojů odděl prázdným řádkem.",
  "distraktory": ["nesprávná možnost 1", "nesprávná možnost 2"],
  "jistota": "vysoká | střední | nízká",
  "poznamka": "jen pokud je něco nejasné (chybí předpis, otázka dvojznačná, obrázek nečitelný)"
}
```

## Pravidla pro odpověď
- **KRÁTCE: 1–2 řádky, max ~180 znaků.** Odpověď je jen to, co tazatel chce vědět (postup, hodnota, ano/ne + důvod). Neopakuj zadání ani to, co je vidět na obrázku nebo v textu otázky (např. „návěstidlo má označovací pás s červenými a bílými pruhy" je vidět na obrázku → nepatří do odpovědi; „návěst Stůj má absolutní význam" je klíčová informace → zůstává).
- Vzor (otázka 1): „Vlak smí pokračovat za návěstidlo jen na pokyn výpravčího přední stanice (popř. prostřednictvím výpravčího zadní stanice); strojvedoucí se mu ohlásí po 5 minutách." – NE: „Návěstidlo má označovací pás …, návěst Stůj má absolutní význam. Vlak smí …"
- Podrobnosti, výjimky a odkazy na další články patří do `plne_zneni`, ne do `odpoved`.
- Musí odpovídat aktuálnímu znění předpisů ve složce (D1 změna 1 od 14.12.2025, Z11 od 14.12.2025, GSM-R změna 1 od 1.6.2026, D2 změna 1, V2 změna 2, V15/I 2025).
- Zdroj vždy konkrétní článek + odstavec (u D1/Z11/D1-1 „čl. NNN odst. (k)“, u D2/V2/V15 „čl. NNN“, u Z1/Z2 „čl. k.k.k.n“, u PŘ GSM-R „kap. x.y“). Může být více zdrojů, ale první je hlavní.
- Odpověď stavěj tak, aby se skládala ze dvou částí (podmínka/postup + konkrétní hodnota/činnost), např. „Vlak smí pokračovat bez svolení výpravčího, jede podle rozhledových poměrů nejvýše 40 km/h až k následujícímu hlavnímu návěstidlu.“
- Pokud předpis pro otázku ve složce chybí (např. V65/1 pro ASDEK/IHL), odpověz podle nejlepší znalosti, uveď jistota „nízká“ a do poznámky napiš, který předpis chybí.

## Pravidla pro distraktory (2 ks)
- Věrohodné, gramaticky správné, stejné délky a stylu jako správná odpověď. Nikdy zjevný nesmysl.
- Distraktor A: první část věty stejná/podobná jako správná, druhá část se liší v konkrétní hodnotě nebo činnosti (např. 40 km/h → 30 km/h; „bez svolení“ → „po svolení výpravčího“; 250 m → 200 m; „k následujícímu hlavnímu návěstidlu“ → „k následujícímu oddílovému návěstidlu“).
- Distraktor B: liší se v jiné části (nebo v obou), ale stále v rámci reálných pojmů z předpisu (jiná návěst, jiný zaměstnanec, jiný dokument, jiná rychlost z řady 10/20/30/40/60/100).
- Čísla volit blízká reálným hodnotám v předpisech (10/20/30/40 km/h, 100/150/200/250/300 m, 3,5/4,5/5 bar, 5/10/20 ‰…), aby se nedalo hádat „to divné číslo je špatně“.
- Distraktory nesmí být náhodou také správné (zkontroluj proti předpisu).
- Distraktory mají stejnou délku jako správná odpověď (1–2 řádky) – délka nesmí prozrazovat správnou možnost.
