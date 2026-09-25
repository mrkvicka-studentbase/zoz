# Specifikace výstupu – Lokomotivy

Dva druhy výstupu: **otázky** (stejná logika jako otázky z předpisů) a **krizové postupy** (checklisty ze Závad v kostce).
Vždy platí: **uzavřený systém** – jen to, co je v dokumentech ve složce. Nic z obecných znalostí, nic z internetu, nic „jak to asi bude“. Když v dokumentu něco není, otázku nedělej.

---

## A) OTÁZKY → `/home/claude/zoz/loko/answers/<id_dokumentu>.json` (JSON pole)

```json
{
  "n": 1001,
  "kategorie": "lokomotivy",
  "rada": "Vectron",
  "otazka": "Nejde zapnout hlavní vypínač Vectronu, na displeji hlášení o poruše ASG. Co uděláš?",
  "obrazky": [],
  "tema": "Poruchy",
  "predpis": "Závady v kostce HV Vectron v3",
  "zdroje": [ {"predpis": "Závady v kostce HV Vectron v3", "clanek": "Porucha ASG – nejde zapnout SS HV, str. 13"} ],
  "odpoved": "Krátká správná odpověď, 1–2 řádky, max ~180 znaků, konkrétní: co, kde (panel/stanoviště/strojovna), jakou polohu, jaké číslo kohoutu.",
  "plne_zneni": "Doslovný přepis kroků / odstavce z dokumentu (klidně 5–15 řádků). Na začátku 'Závady v kostce HV Vectron v3, Porucha ASG:'. Vynechávky označ […].",
  "distraktory": ["nesprávná možnost 1", "nesprávná možnost 2"],
  "jistota": "vysoká | střední | nízká",
  "poznamka": "jen když je něco nejasné (text rozházený, sloupce, rozpor mezi dokumenty, starý dokument)"
}
```

### Číslování `n`
Každý dokument má přidělený rozsah (viz brief). Čísluj postupně od začátku rozsahu, nic nepřeskakuj.

### `tema` – přesně jedna z hodnot
`Bezpečný stav` | `Poruchy` | `Přeprava a odtah` | `Brzdy` | `Převzetí a odstavení` | `ETCS` | `Obsluha a ovládání` | `Ostatní`

### `rada` – přesně jedna z hodnot
`Vectron` | `162/163` | `362 WTB` | `650` | `810`

### Jaké otázky dělat (ústní zkouška – zkoušející se ptá „co uděláš, když…“)
Pořadí důležitosti:
1. **Co uděláš, když… (porucha)** – z každé kapitoly Závad v kostce aspoň jedna otázka na první krok / klíčový krok / co se nesmí. U delších postupů 2–4 otázky (např. „co zkontroluješ na panelu X“, „jakou polohu má kohout Y“, „co musí být splněno před…“).
2. **Kde se nachází…** – umístění panelu, kohoutu, klíče, spínače, tlačítka (jen když to dokument říká: „ve strojovně na panelu…“, „na stanovišti vlevo…“).
3. **Co znamená / co znamená, když svítí…** – kontrolky, hlášení displeje, symboly.
4. **Jaká hodnota / jaké omezení** – rychlost při vlečení/odtahu, tlak, čas, počet.
5. **Pořadí úkonů** – „co uděláš jako první při…“, „co následuje po…“.
6. **Převzetí HV** – co se kontroluje vně/uvnitř, při kterém druhu odstavení, co se zapisuje.
7. **ETCS** – uvedení do provozu, umístění zařízení, co udělat při hlášení X.

**Nedělej** otázky na čísla stran, čísla verzí dokumentu, jména zpracovatelů, ani triviální „jak se jmenuje kapitola“. Nedělej dvě otázky na totéž.

### Formulace otázky
- Situačně, jak by se ptal zkoušející: „Jsi na Vectronu, vypadl displej. Co uděláš?“ / „Na 362 nejde zapnout střídavý hlavní vypínač – kde začneš?“
- Vždy uveď řadu v otázce, když by bez ní nebyla jednoznačná (v aplikaci se otázky z více řad míchají).
- Otázka je jedna věta až dvě, bez nápovědy odpovědi.

### Odpověď a distraktory – stejná pravidla jako u předpisů
- Odpověď KRÁTKÁ (max ~180 znaků), konkrétní, jako by to byla možnost A/B/C v testu.
- 2 distraktory: stejná délka a styl, liší se konkrétní hodnotou / činností / místem / polohou; z reálných pojmů daného dokumentu (jiný panel, jiný kohout, opačná poloha, jiné pořadí); nikdy zjevný nesmysl; nikdy náhodou také správné. Čísla kohoutů, panelů a klíčů ber z dokumentu (např. místo B08/2 dej jiný kohout, který v dokumentu existuje).
- `plne_zneni`: doslovný přepis, aby si to člověk mohl ověřit.

### `jistota`
- `vysoká` – text jasný, ověřeno v dokumentu.
- `střední` – text rozházený (sloupce/obrázky), dokument starý (2015), nebo dvě možné interpretace.
- `nízká` – odvozeno z obrázku bez textu, nebo jen z popisku; do `poznamka` napiš proč.

### Kolik otázek
Tolik, kolik materiál unese bez opakování. Orientačně: Závady v kostce 3–5 na kapitolu; Převzetí HV 15–25 na dokument; ETCS pokyn 12–25; Provozní a poruchové stavy Vectron 50–80; Krátké připomenutí 163 15–25; Odtah Panter 8–15. Radši méně a přesně než hodně a vágně.

---

## B) KRIZOVÉ POSTUPY → `/home/claude/zoz/loko/postupy/<id_dokumentu>.json` (JSON pole)

Dělají se **jen ze Závad v kostce** (a z těch kapitol Pokynu 3/2023 Vectron, které jsou postupem „co dělat při poruše“). Jeden objekt = jedna kapitola (jedna závada / jeden postup).

```json
{
  "id": "vectron-vleceni",
  "rada": "Vectron",
  "nazev": "Vlečení lokomotivy",
  "podnadpis": "vypnutá baterie, pneumatická brzda zapnutá",
  "kategorie": "Přeprava a odtah",
  "uvod": "VLEČENÍ – přeprava lokomotivy jako brzděného vozidla cizí tažnou silou. Pokud lokomotiva nemůže … musí být vlečena.",
  "zavazne_poradi": true,
  "zdroj": {"predpis": "Závady v kostce HV Vectron v3", "clanek": "Vlečení lokomotivy, str. 4", "verze": "3", "ucinnost": "1. 4. 2026"},
  "kroky": [
    {"typ": "misto",  "text": "Na stanovišti"},
    {"typ": "krok",   "c": 1, "text": "Výchozí stav – lokomotiva standardně odstavená z provozu."},
    {"typ": "pozor",  "text": "Při odstavení lokomotivy musí dojít k úplnému odvětrání hlavního potrubí! …"},
    {"typ": "misto",  "text": "Panel brzdových zařízení ve strojovně"},
    {"typ": "krok",   "c": 2, "text": "Zkontroluj uzavření kohoutu B08/2 „ETCS“ (žlutý) – poloha „0“."},
    {"typ": "info",   "text": "Doplňující poznámka z dokumentu, která není úkonem."},
    {"typ": "rozhodnuti", "text": "Svítí LED 13?", "moznosti": [
        {"text": "Ano", "dale": "163-hv-led13"},
        {"text": "Ne",  "dale": "#7"}
    ]},
    {"typ": "krok",   "c": 7, "text": "…"},
    {"typ": "konec",  "text": "Lokomotiva je připravena k vlečení."}
  ]
}
```

### Pravidla pro postupy
- `id`: `<rada-slug>-<nazev-slug>` malými písmeny bez diakritiky, pomlčky (`vectron-bezpecny-stav`, `163-nelze-odzemnit`, `362-porucha-kompresoru`, `650-porucha-dveri-7ev1`).
- `kategorie` – přesně jedna z: `Bezpečný stav` | `Oživení a rozjezd` | `Poruchy` | `Přeprava a odtah` | `Brzdy` | `Ostatní`
- `kroky[].typ`:
  - `misto` – nadpis, kde se úkony dějí („Na stanovišti“, „Panel přístrojů VN DC“). Bez čísla, nezaškrtává se.
  - `krok` – jeden úkon, **má `c`** (číslo z dokumentu). Zaškrtává se. Text doslova z dokumentu (můžeš vypustit odkazy na fotky „viz obrázek“).
  - `pozor` – varování z dokumentu (POZOR!, !!!, tučné výstrahy). Nezaškrtává se.
  - `info` – vysvětlující text, definice (např. co je VLEČENÍ), poznámka. Nezaškrtává se.
  - `rozhodnuti` – větvení, jen když je v dokumentu („pokud svítí… → bod 5; jinak → kapitola 4.2“). `moznosti[].dale` je buď `"#<c>"` (skok na krok s tímto číslem v témže postupu) nebo `"<id jiného postupu>"`.
  - `konec` – závěrečná věta („Je zaveden bezpečný stav lokomotivy.“). Nezaškrtává se.
- `zavazne_poradi`: `true`, když dokument říká „Pořadí úkonů je závazné!“ (nebo obdobně), jinak `false`.
- **Dvousloupcové postupy (650)**: každý sloupec je samostatný postup s vlastním `id` a `nazev` (např. „Přeprava neschopné jednotky – porucha řídícího systému / tažena jiným HV“ a „… – jiná porucha, tažena jednotkou 640/650“). Ověř rozdělení podle obrázku stránky.
- „RYCHLÁ ORIENTACE“ u 162/163: udělej z ní jeden postup kategorie `Oživení a rozjezd` s kroky typu `rozhodnuti`, jejichž `dale` ukazuje na id dílčích postupů (kapitol).
- Nevynechávej kroky. Nepřidávej kroky. Nepřeformulovávej – jen krátit odkazy na fotky.

---

## Kontrola na konci
`python3 -m json.tool <soubor> > /dev/null` pro každý výstup. Pak vrať stručné hlášení: počty, cesty, seznam položek s jistotou střední/nízká a proč, a cokoli, kde se dokumenty rozcházejí nebo jsou nečitelné.
