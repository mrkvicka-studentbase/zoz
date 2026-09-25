# Chybějící / nejisté zdroje k otázkám ZOZ (275 otázek)

Zpracováno: analýza všech 275 otázek z `questions_list.txt`, mapování na dostupné texty
v `/home/claude/zoz/txt/` a `/home/claude/zoz/ocr/`. Ověřeno gripem (viz sloupec „Ověření“).

**Souhrn: 275 otázek, z toho 269 (98 %) má zdroj ve složce. Skutečně chybí podklad k 6 otázkám.**

---

## 1. Otázky, jejichž zdroj ve složce CHYBÍ nebo je nejistý

| Ot. | Téma | Chybějící / potřebný dokument | Ověření gripem |
|---|---|---|---|
| **12** | Jízda přes ASDEK (DZJV), nutnost použití průběžné brzdy; postup po hlášení „indikována horká obruč stupně K, zastavte ve stanici“ | **SŽ V65/1** – Předpis pro provozování diagnostiky závad jedoucích vozidel (+ závazná slovní znění pro DZJV) | `grep -ri 'ASDEK'` → **0 výskytů** v txt/ i ocr/. `grep -ri 'DZJV'` → 0. Jediná stopa: `txt/D1.txt:38678` v seznamu souvisejících předpisů uvádí „SŽDC (ČD) V65/1 Předpis pro provozování diagnostiky závad jedoucích vozidel“ – samotný předpis chybí. |
| **18** | Postup po hlášení „indikováno horké ložisko stupně STOP, okamžitě zastavte!“ | **SŽ V65/1** + příloha se závaznými zněními DZJV | `grep -ri 'indikováno hork\|stupně STOP'` → 0. `grep -i 'diagnostick' txt/Z11.txt` → **0** (Z11 hlášení DZJV neobsahuje). V62 čl. 312–323 řeší jen technické posouzení vozidla po indikaci IHL/IHO, ne dopravní postup. |
| **79** | Závazné slovní znění při diagnostické zprávě IHL stupně STOP | **SŽ V65/1** / příloha SŽ Z11 se zněními DZJV | tamtéž; Z11 obsahuje závazná znění jen pro G-STOP / „Stůj, zastavte všemi prostředky“ (ř. 812–823), nikoli pro IHL. |
| **268** | Kdy musí strojvedoucí provést synchronizaci dat ve služebním tabletu | **Opatření ředitele O18 k služebním tabletům** (příp. MPBP / metodický pokyn ČD), nebo novější příloha ČD V2 | `grep -ri 'synchroniz'` → **0 výskytů** mimo samotné zadání otázky. V2 zmiňuje tablet jen obecně (čl. ř. 410, 727, 765–767 – „dostatečně nabitý služební tablet“, „povolená aktualizace času ze sítě“), synchronizaci dat neřeší. |
| **182** | Symbol rutinního příkazu na displeji radiostanice po dálkovém zastavení vlaku v SRD | **Provozní řád SRD (PŘ SRD)** / návod k obsluze vozidlové radiostanice (TRS/MRS) | `grep -ri 'rutinní'` → **0 výskytů**. Z11 ř. 727 sám odkazuje: „Podrobnosti pro příslušnou trať jsou uvedeny v **PŘ SRD**.“ Z11 přílohy E/F (ř. 7258, 7313) pokrývají kódovaná hlášení a automatickou zkoušku spojení, ne symboliku displeje. |
| **174** | Kontrola sběrače a trolejového vedení po výpadku napětí u vlaku řízeného z řídicího vozu | nejisté – **ČD V2** (postupy pro řídicí vůz) nebo návod k obsluze konkrétní řady / MPBP | D1 čl. ř. 31285–31311 řeší obecně postup při poškození sběrače (pokrývá ot. 173), specifikum „řízeno z řídicího vozu“ v žádném dostupném textu není. |

### Nejisté, ale prakticky pokryté (podklad postačuje, dokument by odpověď jen zpřesnil)

| Ot. | Téma | Doplňkový dokument | Stav |
|---|---|---|---|
| 106, 111 | Ze kterého dokumentu zjistí strojvedoucí číslo na ohlašovací pracoviště | **TTP** (Tabulky traťových poměrů) | Odpověď („z TTP“) je dohledatelná v D1/1D17; samotné TTP ve složce nejsou – pro odpověď nejsou nutné. |
| 98, 139, 270 | Objízdná trasa ve stanici / kdo je vedoucím posunové čety / informování o změnách TTP a ZDD | **ZDD**, **TTP** | D1 ř. 17463–17473 a 21951 dávají principiální odpověď; konkrétní ZDD/TTP jsou dokumenty pro konkrétní trať, do přípravy nejsou třeba. |
| 230 | Porucha pískovacího zařízení s neúmyslným pískováním a ovlivnění kolejových obvodů | – | V2 čl. ř. 1319–1344 (pískování) + D1 čl. 496–497 (obnovení šuntovací schopnosti) dohromady odpověď dají. |

---

## 2. Předpisy, které by Pavel měl dodat (podle počtu otázek)

| # | Předpis / dokument | Proč | Otázky |
|---|---|---|---|
| 1 | **SŽ V65/1** – Předpis pro provozování diagnostiky závad jedoucích vozidel (ASDEK/DZJV), včetně přílohy se závaznými slovními zněními (IHL, IHO, INJ – stupně K a STOP) | Ve složce zcela chybí; 3 otázky nelze zodpovědět z ničeho dostupného | **12, 18, 79** |
| 2 | **Provozní řád SRD (PŘ SRD)** / návod k obsluze vozidlové radiostanice v SRD | Z11 na něj přímo odkazuje; chybí symbolika displeje (rutinní příkaz) | **182** (a upřesnění k 2, 176, 180, 181, 183) |
| 3 | **Opatření ředitele O18 k služebním tabletům** (nebo aktuální MPBP ČD) | Synchronizace dat v tabletu nikde | **268** |
| 4 | **ČD V2 – příloha/postupy pro řídicí vůz** nebo návod k obsluze dotčené řady | Kontrola sběrače z řídicího vozu | **174** |
| 5 | *(volitelné)* **TTP** a **ZDD** vzorové ukázky | Jen ilustrace, odpovědi lze odvodit z D1 | 98, 106, 111, 139, 270 |

**Priorita: bez položky 1 (SŽ V65/1) zůstanou 3 otázky nezodpověditelné. Zbytek je doplňkový.**

---

## 3. Přehled: kolik otázek připadá na který dostupný předpis

| Předpis | Soubor | Počet otázek | Podíl |
|---|---|---:|---:|
| **SŽ D1** (+ změna 1) | `txt/D1.txt` | **130** | 47,3 % |
| **ČD D2** | `txt/D2.txt` | **38** | 13,8 % |
| **ČD V15/I** (brzdy) | `txt/V15.txt` | **27** | 9,8 % |
| **SŽ Z11** (rádio, GSM-R/SRD) | `txt/Z11.txt` | **26** | 9,5 % |
| **ČD V2** (lok. čety, Kniha předávky) | `txt/V2.txt`, `V2_dekod.txt` | **13** | 4,7 % |
| **SŽ Provozní řád GSM-R** | `txt/GSMR.txt` | **11** | 4,0 % |
| **ČD V8/I** (rychloměry) | `txt/V08.txt` | **6** | 2,2 % |
| **ČD T108 + doplňující ustanovení** (VZ/LS) | `ocr/T108*.txt`, `txt/T108-dopl_ustanoveni.txt` | **6** | 2,2 % |
| **ČD D17 / 1-D17** (mimořádné události) | `txt/1D17.txt`, `txt/D17.txt` | **4** | 1,5 % |
| **SŽ D1/1** (kniha písemných rozkazů) | `txt/D1-1.txt` | **3** | 1,1 % |
| **SR 15 (V)** (popis brzd) | `ocr/SR15.txt` | **2** | 0,7 % |
| **SŽ PPD-01/2025** (nová el. návěstidla) | `txt/nove_el_navestidla.txt` | **2** | 0,7 % |
| **ČD V62** (interiérová vozidla) | `txt/V62.txt` | **1** | 0,4 % |
| *CHYBÍ / nejisté* | – | **6** | 2,2 % |
| **Celkem** | | **275** | 100 % |

### Předpisy ve složce, na které nepřipadá žádná otázka (kontext / okrajové)

`BP1` (SŽ Bp1), `Op16` (BOZP ČD), `ok3` (stejnokroj), `V32` (nouzové svěšování), `Z1` (SZZ),
`Z2` (PZZ), `SR49` (el. topení), `Navazování_komunikace` – slouží jako doplňkový kontext,
přímý dotaz v testu na ně nesměřuje (Z1/Z2 pouze nepřímo přes otázky 27, 28, 57, 109, 147).

---

## Poznámky k ověření

- Kniha předávky HV (ot. 205, 232, rubrika 8 „informace o průběhu směny“) **je** k dispozici –
  `txt/V2_dekod.txt` příloha 1 (ř. ~2160–2180); v `txt/V2.txt` je tato část porušená kódováním,
  použít `V2_dekod.txt`.
- Videopoznání / fotopoznání (ot. 266, 267) je v `txt/D2.txt` ř. 1110–1147 – **není chybějící**.
- Barevné označení brzdových součástí (ot. 187, 191) je v `ocr/SR15.txt` ř. 1387, 3156, 3435.
- ETCS / EOA / rozkaz PsD1 (ot. 48) pokrývá `txt/D1-1.txt` (čl. 29, 33, 46) a příloha 5 ČD V2.
- `txt/V2.txt` je od cca ř. 2400 dál poškozený kódováním – pro přílohy vždy použít `V2_dekod.txt`.

---
## Stav po doplnění 19. 9. 2026 odpoledne (Pavel dodal 6 PDF)

| Nový soubor | Co je | Pokrývá otázky | Poznámka |
|---|---|---|---|
| `SŽDC V 65 1.pdf` → `md/V65-1.txt` | SŽDC (ČD) V65/1 Předpis pro provozování diagnostiky závad jedoucích vozidel (ve znění PPD 4/2017) | 12, 18, 79 **částečně** | Definuje IHL/IHO/IPK, stupně K a STOP, obsah vyrozumění (čl. 51 b–c, ř. 504–520), povinnost seznámit strojvedoucí (čl. 55). **Neobsahuje samotný text PPD č. 4/2017** s postupem strojvedoucího (čl. 1.3, 2.1, 2.4, 2.8–2.13, 3.1–3.2, 4.1–4.5), na který se odkazuje OP36 kap. 11A–11C. |
| `403D5F9B….pdf` → `md/OP36-25-O18_prakticka_aplikace.txt` | ČD Opatření ředitele O18 č. 36/2025 „Praktická aplikace předpisových ustanovení v praxi" | desítky otázek jako sekundární zdroj (postupy u návěstidel, zkoušky brzd, MU, ETCS, ASDEK kap. 11A–C ř. 1077–1125) | Mapa: `prehled/OP36-25-O18.md`. U ASDEK odkazuje na PPD 4/2017, ČD V2 příl. 8 a 9, **OŘ O18 32/2025** (chybí). |
| `20D3B09E….pdf` → `md/OP38-2020-O18_provozni_aplikace_tablet.txt` | ČD Opatření ředitele O18 č. 38/2020 (zm. 9) Provozní aplikace pro strojvedoucí | **268** (synchronizace dat – kap. A, ř. 859–880; MAPSIS čl. 42, ř. 575), 16 (porucha tabletu/SPO) | mapa zatím nevytvořena (Opus limit) |
| `SŽ D5-3 ….pdf` → `md/D5-3.txt` | SŽ D5-3 Prováděcí pokyny k doplňujícím ustanovením předpisů pro telekomunikační zařízení a PŘ rádiových sítí | 182 **ne** – jen říká, že PŘ SRD je na PPD ve složce „RÁDIOVÝ PROVOZ" (ř. 1005) | rutinní příkazy SRD tu nejsou; mapa zatím nevytvořena |
| `00652F96… 1 až 6.pdf` → `md/PPD6-2008_ES64U4.txt` | SŽDC PPD 6/2008 zm. 1–6 – provozní opatření k vozidlům ES64U4 (Taurus) | žádnou | okrajové |
| `500F5A93….pdf` → `ocr/OP34-22-O18.txt` (452 str., OCR) | ČD Opatření ředitele O18 č. 34/22 zm. 4 – vlakový zabezpečovač / mobilní část, ETCS (rozsah znalostí strojvedoucí) | T108 otázky (185, 204, 205, 225–227 ověřit), možná 174 | text PDF má rozbité kódování → OCR; mapa zatím nevytvořena |

### Stále chybí (aktualizovaný seznam)
1. **SŽDC PPD č. 4/2017** (Pokyn provozovatele dráhy č. 4/2017 – provozování diagnostiky závad jedoucích vozidel; čj. S 6735/2017-SŽDC-O14) – postup strojvedoucího při hlášení IHL/IHO stupně K/STOP, nestandardní průjezd (použití brzdy) → **ot. 12, 18, 79**. Nejvyšší priorita.
2. **ČD Opatření ředitele O18 č. 32/2025** (diagnostika závad jedoucích vozidel – čl. 20–24 IHL, 30–32 IHO, 40–42 INJ) → ot. 12, 18, 79.
3. **Provozní řád SRD (PŘ SRD)** – na Portálu provozování dráhy, složka „RÁDIOVÝ PROVOZ" → ot. 182 (symbol rutinního příkazu při dálkovém zastavení).
4. Ot. 174 (kontrola sběrače z řídicího vozu) – ověřit v OCR OP34-22-O18 / V2 čl. o sběračích; jinak návod k obsluze řady.

---
## Stav po doplnění 20. 9. 2026

Pavel dodal **Pokyny pro obsluhu vyhodnocovacích zařízení (ASDEK)** – příloha ObŘ Ústí nad Labem (`md/ObR_priloha23_PO.txt`, v kontejneru `txt/ASDEK_ObR_priloha24.txt`) a **SŽ T100** (`md/T100.txt`).

- **Vyřešeno:** otázky **12, 18, 79** – příloha obsahuje přehled druhů a stupňů poplachů (IHL/IHO/INJ, K a STOP) i závazná slovní znění vyrozumění strojvedoucího (čl. 4.1–4.5). SŽDC PPD 4/2017 ani ČD OŘ O18 32/2025 už nejsou potřeba.
- **T100** (Předpis pro provozování zabezpečovacích zařízení) nepokrývá žádnou otázku přímo – slouží jako kontext k Z1/Z2.

**Stále chybí:** Provozní řád SRD (ot. 182 – symbol rutinního příkazu; symbol „! STOP !“ je ale doložen ze SŽ Z11 příl. F), TTP (ot. 106, 111 – tab. 3b), starší znění ČD V15/I (ot. 201).
