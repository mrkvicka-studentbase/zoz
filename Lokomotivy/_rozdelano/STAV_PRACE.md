# Lokomotivy – stav rozdělané práce (22. 9. 2026, 17:50)

**AKTUALIZACE 22. 9. večer: HOTOVO** – 3. a 4. vlna doběhla, obsah sloučen do `zoz_loko.json` (566 otázek, 133 postupů, 0 chyb), aplikace má záložku Lokomotivy + Krizový postup, SQL `cast5_lokomotivy.sql`. Zbývá: Pavlova kontrola `LOKO_K_POSOUZENI.md`, 810 závady v kostce (dodá Pavel), obrázkové otázky (2. kolo), 62 otázek s délkovou nápovědou.


Pavel řekl: „ulož si rozdělanou práci a pustím tě k večeru, strašně žereš limity.“ → práce zastavena po 2. vlně agentů, pokračovat večer.

## Rozhodnutí Pavla (AskUserQuestion, 22. 9.)
- 810: Pavel **dodá Závady v kostce** – zatím zpracovat jen převzetí HV, po dodání doplnit.
- Zdroje: **ze všeho ve složce** (závady v kostce těžiště + převzetí HV + ETCS pokyny + brzděný odtah + připomenutí 163).
- Umístění: **nová záložka Lokomotivy** (uživatel si zaškrtne své řady, pamatuje se; uvnitř kartičky, test, Krizový postup; statistiky rozšířit o řady).
- Obrázkové otázky: **druhé kolo**, až po Pavlově kontrole textových.

## Hotovo (soubory validní JSON, v `/home/claude/zoz/loko/`)
| dokument | otázky | rozsah n | postupy |
|---|---|---|---|
| vectron_zavady (Závady v kostce v3) | 56 | 1001–1056 | 18 postupů / 95 kroků |
| vectron_provoz_A (Pokyn 3/2023, str. 1–27) | 40 | 1061–1100 | 29 postupů / 569 kroků (id `vectron-p3-*`) |
| vectron_provoz_B (Pokyn 3/2023, str. 28–54) | 40 | 1101–1140 | 19 postupů / 151 kroků (id `vectron-p3-*`) |
| vectron_etcs (Pokyn 5/2024) | 37 | 1141–1177 | – (nedělají se) |
| 163_zavady (Závady v kostce v2) | 88 | 1201–1288 | 34 postupů / 484 kroků |
| **celkem** | **261** | | **100 postupů** |

## Zbývá – 3. vlna agentů (4 agenti, každý s "zapisuj průběžně")
| agent | dokumenty | rozsah n | postupy |
|---|---|---|---|
| A | `362_zavady` (16 str.) | 1401–1480 | ano, id `362-<slug>` |
| B | `650_zavady` (12 str., DVA SLOUPCE – každý sloupec = vlastní postup) + `650_odtah` (12 str., fotky) | 1601–1700 | ano z 650_zavady, id `650-<slug>`; z odtahu jen otázky |
| C | `163_prevzeti` + `163_pripomenuti` (2015, neoficiální → jistota max střední) | 1291–1360 | ne |
| D | `362_prevzeti` + `362_prevzeti_souprava` + `362_etcs` | 1481–1560 | ne |
| E (malý) | `650_etcs` (fotky) + `650_prevzeti` + `810_prevzeti` | 1701–1760 (650), 1801–1830 (810) | ne |
Brief: `AGENT_BRIEF_LOKO.md` (+ LOKO_SPEC.md, LOKO_GUIDE.md). Vzor promptu = prompty 2. vlny (viz transkript). Limit session: pouštět max 4 agenty najednou.

## Pak
1. Verifikační průchod (agenti): namátkově 25 % otázek + všechny postupy proti txt/img; kontrola `dale` odkazů; sjednotit délku odpovědí >200 znaků.
2. Sloučit: `loko/zoz_loko.json` = {version, questions:[…], postupy:[…]} (obrázky zatím žádné).
3. Aplikace (`web/template_web.html`): záložka **Lokomotivy** – výběr řad (localStorage + profiles.rady), kartičky/test filtrované `kategorie='lokomotivy' and rada in (...)`, **Krizový postup** (řada → kategorie → seznam postupů → checklist: kroky `krok` zaškrtávací, `misto` nadpis, `pozor` červený box, `info` šedý, `rozhodnuti` tlačítka → skok `#c` / jiný postup, `konec`; progres jen v paměti; nahoře zdroj + verze + účinnost + věta „Přepis dokumentu – rozhodující je platný dokument v tabletu“). Statistiky: sekce Lokomotivy po řadách. Admin: nahrání `zoz_loko.json`.
4. SQL část 5: `alter table questions add kategorie text default 'predpisy', add rada text`; tabulka `postupy (id text pk, rada, nazev, podnadpis, kategorie, uvod, zavazne_poradi bool, zdroj jsonb, kroky jsonb, updated_at)` + RLS jako questions; `profiles.rady jsonb`. `content_info()` rozšířit o počet postupů.
5. Seznam k posouzení pro Pavla: `LOKO_K_POSOUZENI.md` – sesbírat body „k posouzení“ z hlášení agentů (níže) + položky s jistotou střední/nízká.

## Body k posouzení z hlášení agentů (zatím sesbírané)
### vectron_zavady
- 12 kapitol → 18 postupů (Nouzové odbrzdění rozděleno na odbrzdění + zpětnou aktivaci; Poškození na pojezdu na 6 dílčích) – lze sloučit, když Pavel chce 12.
- Kohout střadačové brzdy: „B03“ (Odtažení) vs. „B03.04“ (Nouzové odbrzdění) – tentýž kohout, ponecháno podle kapitoly (ot. 1016).
- Ot. 1048 (výpadek jednoho displeje): tlačítko jen ikonou ↔ – jistota střední.
- FC 252 neříká „na obou stanovištích“ (na rozdíl od FC 239/240 a 290/293) – ot. 1035.
### vectron_provoz_A (str. 1–27)
- Kap. 21.3/21.4 (přejezd hranic s ETCS/balízami) jsou v dokumentu fialově = „bude upřesněno“ – zvážit, zda zobrazovat.
- Kap. 12 (aktivní odstavení) je pro SW E; SW F v kap. 34/35 – ot. 1080–1082 mají „SW E“.
- Přehřátí transformátoru (str. 3) nemá číslované kroky – čísla 1–3 doplněna.
- Překlepy originálu ponechány („vobu potvrďte“, „CDD“).
- Zásoba dalších námětů na otázky (nevyužito kvůli limitu 40).
### vectron_provoz_B (str. 28–54)
- Kap. 27.27 FC 252: kroky v dokumentu číslované 1,3,5,8,6 – chyba dokumentu, ot. 1104 podle řádků.
- Kap. 27.5.x odkazují na odtažení „viz 20.2“, správně 26.2 (ot. 1111).
- Kap. 34 S e.: neúplná věta „…že jsou podvozky.“ (ot. 1139).
- Postupy 25.1 (vícenásobná trakce) a 26.3 (přeprava nečinné loko) jsou provozní checklisty, ne poruchy – ponechány.
- 7 odpovědí 190–199 znaků.
- Zásoba ~15–20 dalších námětů.
### vectron_etcs
- 4 varianty SW (E 3.4.0 / 2.3.0.d ELL / F1 / F2-F3), různé rozsahy brzdicích procent; F1 délka 20–750 m vypadá jako překlep (nedělána otázka).
- ŘV ComfortJet (Afmpz) jen jako distraktory.
- Distraktor „2 m“ u 1170 není z dokumentu.
### 163_zavady
- Kap. 4.5 má dvakrát bod 28; bod 27 odkazuje na bod 33, text je až v 35 (ot. 1247).
- Kap. 4.5 bod 7 odkazuje na 5.1 bod 20, věcně jde o 5.2.
- Kap. 12 řádek „Při propojeném / Bez propojeného napájecího potrubí“ = dva kroky c:10.
- Rychlá orientace: odkazy z „nejde do tahu“ / „nefungují pomocné pohony“ na kap. 6/7/8 a 5.1 jsou vazba agenta, ne text dokumentu.
- K116 vs. K106 u Led 13 – ponecháno podle kapitoly.
- Odpovědi 1246, 1283, 1288 mají 200–225 znaků.
- Dvousloupcové větve ANO/NE = samostatné postupy (11 větví), hlavní postup má `rozhodnuti` → větev.
