# ZOZ Trenažér – předávací dokument (pro pokračování v jiné session / s Opusem)

Stav k 20. 9. 2026 večer – **všech 275 otázek zpracováno, ověřeno a projito s Pavlem**; artifact publikován (verze 8). Otevřené zůstávají 3 otázky (107, 108, 132) – viz `OTAZKY_K_POSOUZENI.md`.

## 1. Cíl projektu
Pavel (strojvedoucí ČD) má v prosinci 2026 periodické přezkoušení ZOZ. Ze souboru `otázky ZOZ.pdf` (275 otevřených otázek, řada s obrázky) vzniká HTML aplikace **ZOZ Trenažér**:
- ke každé otázce **zkrácená správná odpověď (1–2 řádky)**, **odkaz na konkrétní předpis + článek/odstavec**, **rozklikávací plné znění článku**, obrázek;
- **testový režim ABC** (1 správná + 2 věrohodné distraktory), volba počtu otázek / časového limitu / tématu / předpisu, kartičky, ukládání výsledků a slabých otázek v prohlížeči.

Pavel schválil formát na vzorku otázek 1–25. **Otázky 26–275 zpracovány 19.–20. 9. 2026 ve 20 dávkách subagenty, poté proběhl ověřovací průchod všech 275 otázek** (kontrola citací proti textu předpisů, kontrola distraktorů, zkrácení odpovědí na ≤180 znaků). Zbývá: projít s Pavlem 39 otázek bez jednoznačné odpovědi (seznam v `OTAZKY_K_POSOUZENI.md`) a doplnit chybějící předpisy.

## 2. Kde co je

### Na Pavlově počítači (složka `C:\Users\Administrátor\Desktop\předpisy`, v Coworku připojená jako `$HOME/mnt/předpisy`)
| Cesta | Obsah |
|---|---|
| `*.pdf` (27 ks) | Původní předpisy SŽ/ČD + `otázky ZOZ.pdf` |
| `md/*.txt` | Texty všech PDF (`pdftotext -layout`) – čitelné vše kromě skenů |
| `md/SR15_ocr.txt`, `md/SR49_ocr.txt`, `md/T108*_ocr.txt` | Skeny převedené OCR (tesseract, ces) – bloky `=== STRANA n ===` |
| `md/V2_prilohy_dekod.txt` | Přílohy ČD V2 (od ř. ~2121: Kniha předávky HV, checklisty, ETCS) – v `V2.txt` jsou kvůli kódování písma nečitelné, tady dekódované (~95 %) |
| `md/prehled/00_PRUVODCE.md` | Přehled předpisů, co upravují, konvence číslování článků |
| `md/prehled/*.md` | **Kontextové mapy** každého předpisu: struktura kapitol → čísla článků → číslo řádku v txt, tabulka „kde hledat co" pro strojvedoucího, zkratky. Klíčové: `D1.md` (74 kB), `Z11.md`, `GSMR.md`, `D2.md`, `V2.md`, `V15.md` |
| `ZOZ_trenazer.html` | Samostatná kopie aplikace (otevře se offline) |
| `zoz_projekt/` | **Kompletní pracovní adresář** (viz níže) – zkopírovaný z cloud kontejneru, aby nová session mohla pokračovat |

### Pracovní adresář `zoz_projekt/` (v kontejneru byl `/home/claude/zoz/`)
```
HANDOVER.md              ← tento soubor
PREDPISY_GUIDE.md        ← průvodce předpisy (stejný jako md/prehled/00_PRUVODCE.md)
ANSWER_SPEC.md           ← ZÁVAZNÁ specifikace výstupu pro zpracování otázek (JSON schéma, pravidla odpovědí a distraktorů)
CHYBEJICI_PREDPISY.md    ← analýza: které otázky nemají podklad ve složce, rozdělení otázek podle předpisů
questions_raw.json       ← 275 otázek: {n, text, images:[img/qNNN_k.png], page}
questions_list.txt       ← totéž jako prostý seznam (číslo, [img], text)
img/qNNN_k.png           ← 127 obrázků k otázkám (vyříznuté z PDF, 160 dpi)
prehled/*.md             ← kontextové mapy předpisů (kopie md/prehled)
answers/batch_001_013.json, batch_014_025.json   ← HOTOVÉ, schválené (po zkrácení)
answers/batch_<od>_<do>.json                     ← sem přibývají další dávky
web/template.html        ← šablona aplikace (placeholdery __DATA__, __IMG__, __BUILD__)
web/img/*.webp           ← obrázky pro web (max 1000 px, q82) – všech 127 hotovo
web/zoz.html             ← sestavená stránka pro Artifact (bez <html>/<head>/<body>)
web/ZOZ_trenazer.html    ← sestavená samostatná stránka (plný HTML dokument)
build.py                 ← sestavení: sloučí answers/*.json, validuje schéma, vloží obrázky base64, vyrobí obě HTML
```
Nové texty (19. 9. odpoledne) jsou v `md/`: `V65-1.txt`, `D5-3.txt`, `OP36-25-O18_prakticka_aplikace.txt`, `OP38-2020-O18_provozni_aplikace_tablet.txt`, `PPD6-2008_ES64U4.txt`, `OP34-22-O18_ocr.txt` (v kontejneru `txt/` resp. `ocr/OP34-22-O18.txt`).

Texty předpisů pro subagenty: v kontejneru byly v `/home/claude/zoz/txt/*.txt` a `/home/claude/zoz/ocr/*.txt` – v nové session je buď znovu nastaguj z `md/` (device_stage_files), nebo pracuj přímo na počítači přes device_bash (`$HOME/mnt/předpisy/md/`). Cesty v `prehled/*.md` odkazují na `/home/claude/zoz/txt/<NÁZEV>.txt` – při jiném umístění je stačí mentálně přemapovat (názvy souborů jsou stejné, jen `*_ocr.txt` → `ocr/*.txt`).

## 3. Postup zpracování otázek (ověřený workflow)
1. **Dávka = ~12–13 otázek na jednoho subagenta** (general-purpose; model Opus stačí). Paralelně lze pustit 3–5 dávek najednou. Jeden agent na 12 otázek trvá ~8 min a spotřebuje ~200k tokenů.
2. Prompt pro agenta (osvědčený, použij doslova a doplň čísla):
   > Jsi expert na železniční předpisy SŽ a ČD (strojvedoucí). Přečti `/…/ANSWER_SPEC.md` a `/…/PREDPISY_GUIDE.md` a přesně podle nich zpracuj otázky č. **X až Y** z `/…/questions_raw.json`. Ke každé otázce: prohlédni obrázek (pokud je, Read na `img/qNNN_k.png`), najdi v mapách `/…/prehled/*.md` relevantní článek, ověř přímo v textu předpisu (Read s offset/limit), a sestav odpověď, plné znění, zdroje a 2 distraktory. Výstup ulož jako validní JSON pole do `/…/answers/batch_XXX_YYY.json`. Na závěr zkontroluj JSON (`python3 -m json.tool`) a vrať krátké shrnutí: které otázky mají jistotu nízká/střední a proč.
   Do promptu přidej nápovědu k tématům dávky (např. „PMD → D1.md čl. 255–256; posun → D1 čl. 227–248, D2; GSM-R → Z11.md + GSMR.md; brzdy → V15.md; rychloměry → V08.md; ETCS/VZ → T108, T108-dopl.md; přílohy V2 → V2_dekod.txt").
3. Po dávce: `python3 build.py` → zkontroluj výpis (počet otázek, obrázků, velikost). Build validuje povinná pole a přesně 2 distraktory.
4. **Ověřovací průchod** (po všech dávkách, nebo po každých ~50 otázkách): jiný subagent dostane batch a instrukci „u každé otázky otevři citovaný článek v txt a potvrď, že odpověď odpovídá textu; oprav chyby; zkontroluj, že žádný distraktor není také správně; zkrať odpovědi nad 180 znaků". Výstup zapisuje zpět do téhož JSON.
5. Rozdělení témat podle CHYBEJICI_PREDPISY.md: D1 ~130 otázek, D2 38, V15 27, Z11 26, V2 13, PŘ GSM-R 11, V8 6, T108 6, D17 4, D1/1 3, SR15 2, PPD-01/2025 2, V62 1.

## 4. Publikace
- **Artifact** (claude.ai): `https://claude.ai/artifact/LjMaimmWJxTWZMo4znfMJY` – aktualizovat přes Artifact tool s `url` = tento odkaz a `file_path` = `web/zoz.html` (nejdřív `action: read` s tím url, pak publish). Ikona „train" – při republishi `icon` neposílat.
- **Lokální kopie**: `web/ZOZ_trenazer.html` → zkopírovat do `předpisy\ZOZ_trenazer.html` (device_commit_files nebo device_bash `cp`).
- Aplikace ukládá pokrok do localStorage (klíč `zoz-stats-v1`), republish ho nemaže.

## 5. Poučení z kontroly vzorku (Pavlovy požadavky – DODRŽET)
- Odpověď **1–2 řádky, max ~180 znaků**. Neopakovat zadání ani to, co je vidět na obrázku. Příklad (ot. 1): NE „Návěstidlo má označovací pás s červenými a bílými pruhy, kryje výhybku, návěst Stůj má absolutní význam. Vlak smí…" → ANO „Vlak smí pokračovat za návěstidlo jen na pokyn výpravčího přední stanice (popř. prostřednictvím výpravčího zadní stanice); strojvedoucí se mu ohlásí po 5 minutách."
- Distraktory: stejná délka a styl jako správná odpověď; A = stejná první část, jiná hodnota/činnost ve druhé (40→30 km/h, 250→200 m, „bez svolení"→„po svolení"); B = liší se jinde, ale v reálných pojmech předpisu. Nikdy nesmysl. Čísla blízká reálným hodnotám z předpisů.
- Vždy konkrétní zdroj (předpis + článek + odstavec); u chybějícího předpisu jistota „nízká" + poznámka.
- Sporné výklady napsat do `poznamka` (Pavel je posoudí) – např. ot. 22 (PN u projíždějícího vlaku), ot. 10 (plný/prázdný trojúhelník v TJŘ).

## 6. Chybějící podklady – stav po doplnění 19. 9. odpoledne
Pavel dodal 6 PDF (převedené do `md/`, viz tabulka v PREDPISY_GUIDE.md a sekce „Stav po doplnění" v `CHYBEJICI_PREDPISY.md`):
- **V65/1** (`md/V65-1.txt`) – definice IHL/IHO/IPK, stupně K/STOP, obsah vyrozumění (čl. 51). Postup strojvedoucího ale je v **PPD 4/2017**, které v souboru není.
- **OP36/2025 Praktická aplikace** (`md/OP36-25-O18_prakticka_aplikace.txt`, mapa `prehled/OP36-25-O18.md`) – **používej jako sekundární zdroj u mnoha otázek** (postupy u návěstidel, zkoušky brzd, MU, ETCS, ASDEK kap. 11A–C).
- **OP38/2020 Provozní aplikace pro strojvedoucí** (`md/OP38-2020-O18_provozni_aplikace_tablet.txt`) – tablet, synchronizace (kap. A, ř. ~859) → ot. 268; porucha tabletu → ot. 16.
- **D5-3**, **PPD 6/2008 (ES64U4)** – okrajové.
- **OP34/22 (VZ/ETCS, 452 str.)** – `ocr/OP34-22-O18.txt` (OCR; PDF text má rozbité kódování) → otázky k VZ/ETCS (185, 204, 205, 225–227), možná 174.

**Stále chybí:** SŽDC **PPD č. 4/2017** (čj. S 6735/2017-SŽDC-O14) a ČD **OŘ O18 č. 32/2025** – postup strojvedoucího při ASDEK/IHL (ot. 12, 18, 79); **PŘ SRD** (ot. 182). Jakmile dorazí: `pdftotext -layout` do `md/`, řádek do PREDPISY_GUIDE.md, přepracovat dotčené otázky.

**Nedodělky po přerušení (Opus session limit 19. 9.):** mapy `prehled/D5-3.md`, `prehled/OP38-2020-O18.md`, `prehled/OP34-22-O18.md` nevytvořeny (V65-1.md a OP36-25-O18.md hotové – ověř, že OP36 mapa je úplná); otázky 12 a 18 zatím nepřepracované (jistota „nízká" zůstává) – přepracuj po dodání PPD 4/2017 / OŘ 32/2025, do té doby cituj V65/1 čl. 51 + V2 příl. 8 + OP36 kap. 11A.

## 7. Todoist (projekt „Claude")
Pravidla v paměti `[[todoist-prehled]]`. Otevřené úkoly k tomuto projektu: „ZOZ trenažér: zkontrolovat vzorek…" (Zkontrolovat – po schválení odškrtnout), „ZOZ trenažér: zpracovat zbývajících 250 otázek…" (Plán → přesunout do Rozdělané), „ZOZ trenažér: dodat předpis SŽ V65/1" (Chybí doplnit). Na konci každé odpovědi, kde se Todoist měnil, řádek „Todoist: +X založeno, Y aktualizováno, Z hotovo".

## 8. Rychlý start v nové session (checklist)
1. Připojit složku `předpisy`; `ls $HOME/mnt/předpisy/zoz_projekt`.
2. Nastagovat do kontejneru `zoz_projekt/` (celý) a `md/*.txt` → do `/home/claude/zoz/txt/` (OCR soubory do `/home/claude/zoz/ocr/` pod původními názvy bez `_ocr`, `V2_prilohy_dekod.txt` → `txt/V2_dekod.txt`). Nebo upravit cesty v promptu agentů.
3. `python3 build.py` – ověřit, že vzorek 25 otázek sestaví bez chyby.
4. Spustit dávky 26–275 (např. 26–38, 39–51, … po 13), 4–5 paralelně, model Opus.
5. Po každé vlně `build.py` + republish artifactu + kopie do složky, průběžně Todoist.
6. Nakonec ověřovací průchod a poslední republish.
