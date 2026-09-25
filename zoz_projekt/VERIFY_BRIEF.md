# Brief pro ověřovacího subagenta

Pracovní adresář `/home/claude/zoz/`. Nejdřív si přečti `/home/claude/zoz/ANSWER_SPEC.md` (závazná pravidla) a `/home/claude/zoz/PREDPISY_GUIDE.md`.

Dostaneš seznam souborů `answers/batch_*.json`. U **každé** otázky v nich:

1. **Ověř citaci.** Otevři citovaný článek přímo v `txt/<PŘEDPIS>.txt` (nebo `ocr/<X>.txt`) – grepem si najdi číslo článku, pak Read s offset/limit. Zkontroluj, že článek existuje, má uvedené číslo a že jeho text skutečně říká to, co je v `odpoved` a v `plne_zneni`.
   - Je-li číslo článku špatně (článek neexistuje nebo říká něco jiného), **oprav** `zdroje`, `plne_zneni` i `odpoved`.
   - Je-li `plne_zneni` přepsané vlastními slovy místo doslovné citace, nahraď ho doslovným textem z předpisu.
2. **Zkontroluj distraktory.** Žádný ze dvou distraktorů nesmí být podle předpisu také správný ani jen „taky přijatelný". Když je, přepiš ho (stejná délka a styl, liší se konkrétní hodnotou/činností, stále věrohodný). Distraktory nesmí být kratší/delší tak, aby prozrazovaly správnou možnost.
3. **Zkrať odpovědi nad ~180 znaků** tak, aby zůstala podstata (podmínka/postup + konkrétní hodnota). Podrobnosti přesuň do `plne_zneni`. Neopakuj zadání otázky ani to, co je vidět na obrázku.
4. **Zkontroluj `jistota`.** Je-li citace ověřená a jednoznačná → `vysoká`. Je-li výklad sporný nebo předpis chybí → `střední`/`nízká` + `poznamka` s vysvětlením (jednou větou, konkrétně).
5. **Nic nevymýšlej.** Když článek nedohledáš, nech odpověď být, sniž `jistota` a napiš to do `poznamka`.

Zapisuj **zpět do téhož souboru** (zachovej pořadí objektů a všechna pole). Na konci každého souboru spusť `python3 -m json.tool <soubor> > /dev/null`.

Buď úsporný: grep + cílený Read, ne čtení tisíců řádků. Obrázky otevírej jen tehdy, když bez nich nejde posoudit správnost odpovědi (u otázek typu „jaký je název této návěsti").

## Závěrečné hlášení (stručně, česky)
- kolik otázek zkontrolováno, kolik opraveno (a co konkrétně – čísla otázek + jednou větou);
- **seznam otázek, které nemají jednoznačnou odpověď** (chybí předpis, dvojznačné zadání, sporný výklad, nečitelný obrázek) – u každé jedna věta proč a jaké jsou varianty.
