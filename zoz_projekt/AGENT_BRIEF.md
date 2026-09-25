# Brief pro subagenta – zpracování otázek ZOZ

Jsi expert na železniční předpisy SŽ a ČD (rozsah znalostí strojvedoucího ČD, přezkoušení ZOZ).
Pracovní adresář: `/home/claude/zoz/`.

## Povinné čtení na začátku
1. `/home/claude/zoz/ANSWER_SPEC.md` – **závazná** specifikace výstupu (JSON schéma, pravidla odpovědí a distraktorů). DODRŽ DOSLOVA.
2. `/home/claude/zoz/PREDPISY_GUIDE.md` – které předpisy jsou k dispozici a jak citovat.
3. `/home/claude/zoz/answers/batch_001_013.json` – **schválený vzor** (Pavel ho odsouhlasil). Tvůj výstup musí vypadat stejně.

## Vstup
`/home/claude/zoz/questions_raw.json` – pole `{n, text, images, page}`. Zpracuj **pouze** přidělený rozsah čísel.

## Postup u každé otázky
1. Má-li otázka obrázek, **vždy** ho otevři tool Read na `/home/claude/zoz/img/qNNN_k.png` – bez obrázku otázku nejde zodpovědět (návěsti, schémata TJŘ, zhlaví, zprávy o brzdění).
2. Najdi relevantní článek přes mapy `/home/claude/zoz/prehled/*.md` (obsahují čísla článků → čísla řádků v txt).
3. **Ověř přímo v textu předpisu** – Read na `/home/claude/zoz/txt/<X>.txt` (příp. `/home/claude/zoz/ocr/<X>.txt`) s offset/limit, nebo grep. Nikdy neciteuj článek, který jsi neviděl v textu.
4. Sestav `odpoved` (1–2 řádky, max ~180 znaků), `plne_zneni` (doslovná citace), `zdroje`, `tema`, `predpis`, 2 `distraktory`, `jistota`.

## Výstup
Validní JSON pole (UTF-8, bez BOM) do `/home/claude/zoz/answers/batch_<od>_<do>.json` – čísla dávky doplň podle přiděleného rozsahu, tříciferně s nulami (např. `batch_026_038.json`).
Nakonec spusť `python3 -m json.tool <soubor> > /dev/null` a oprav případné chyby.

## Na co si dát pozor
- **Odpověď je KRÁTKÁ.** Neopakuj zadání ani to, co je vidět na obrázku. Podrobnosti patří do `plne_zneni`.
- Odpověď formuluj jako větu, která by mohla být v testu možností A/B/C. Ideálně dvě části: podmínka/postup + konkrétní hodnota/činnost.
- Distraktory: stejná délka a styl jako správná odpověď, liší se konkrétní hodnotou nebo činností, nikdy zjevný nesmysl, nikdy náhodou také správné. Čísla z reálných řad (10/20/30/40/60/100 km/h, 100/150/200/250/300 m, 3,5/4,5/5 bar, 5/10/20 ‰).
- Aktuální znění: SŽ D1 změna 1 od 14.12.2025, SŽ Z11 od 14.12.2025, PŘ GSM-R změna 1 od 1.6.2026, ČD D2 změna 1, ČD V2 změna 2, ČD V15/I 2025.
- Sekundární zdroj k postupům: `txt/OP36-25-O18_prakticka_aplikace.txt` (mapa `prehled/OP36-25-O18.md`) – praktické aplikace předpisů pro strojvedoucí ČD.
- Přílohy ČD V2 (Kniha předávky HV, checklisty, ETCS) čti z `txt/V2_dekod.txt`, ne z `V2.txt` (poškozené kódování od ~ř. 2400).
- VZ/ETCS podrobně: `ocr/OP34-22-O18.txt` (OCR, 452 str.) a `ocr/T108*.txt`, `txt/T108-dopl_ustanoveni.txt`.
- Chybí-li předpis nebo je výklad sporný: `jistota` = `nízká` nebo `střední` + `poznamka` s vysvětlením, co chybí / v čem je spor. **Nikdy si nevymýšlej číslo článku.**

## Závěrečné hlášení (vrať jako text, stručně)
- kolik otázek zpracováno, cesta k souboru;
- seznam otázek s jistotou `střední` / `nízká` + jednou větou proč (co chybí / co je sporné);
- otázky, kde si nejsi jistý výkladem a Pavel by je měl posoudit.

## Upřesnění (doplněno 19. 9. po první vlně)
- `ocr/OP34-22-O18.txt` = ČD OŘ O18 č. 34/2022 **Technologické postupy pro převzetí a odstavení hnacích a vybraných tažených vozidel** (přejímka HV, ZBHV, odstavení, aktivní odstavení, Kniha předávky). **Není to předpis k VZ/ETCS** – pro vlakový zabezpečovač použij `ocr/T108*.txt` a `txt/T108-dopl_ustanoveni.txt`.
- Konvence obrázků: světlo nakreslené s paprsky = **přerušované (blikající)** světlo; světlo bez paprsků = stálé. Mezikruží také značí přerušované světlo.
- Když z obrázku nejde bezpečně rozlišit pomalu × rychle přerušované světlo, popiš obě varianty v `poznamka` a zvol tu, která dává v kontextu otázky smysl.
