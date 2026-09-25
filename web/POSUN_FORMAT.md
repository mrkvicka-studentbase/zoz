# Posunová pomůcka – formát plánku stanice (`web/posun.json`)

Pomůcka je obecná: nový plánek = nový záznam v poli `stanice`. Kód se nemění.
Plánek je **schéma**, ne měřítko – stačí, aby seděla topologie (co s čím je spojené přes jakou výhybku) a pořadí návěstidel.

## Záznam stanice
| pole | význam |
|---|---|
| `id`, `nazev` | identifikátor a název („Chomutov“) |
| `v` | 6. pád s předložkou pro větu („v Chomutově“) |
| `vypravci` | jak se volá výpravčí („Výpravčí Chomutov“; u více výpravčích lze později rozšířit na obvody) |
| `elektrizovana` | `true` → v žádosti se uvádí závislá / nezávislá trakce (D1 čl. 229 odst. 5 f) |
| `rozmer` | `[šířka, výška]` souřadnic schématu (např. `[1000, 380]`) |
| `zdroj` | odkud plánek je a k jakému datu (zobrazí se pod plánkem) |
| `ukazka` | `true` jen u vymyšlené ukázkové stanice |

## Uzly (`uzly`) – body, kde se úseky potkávají
- `{"x":…, "y":…}` – obyčejný spoj dvou úseků (konec koleje, zlom)
- `"typ":"vyhybka", "c":"12", "kmen":"<id úseku>"` – výhybka číslo 12; **kmen** je úsek, ze kterého se do výhybky jede „špičkou“. Výhybkou se jede jen kmen ↔ větev, nikdy větev ↔ větev.
- `"typ":"zarazedlo"` – kusá kolej; `"typ":"trat", "popis":"trať do Březenců"` – odchod na trať (na trať se posun nevede).

## Úseky (`useky`) – kusy kolejí mezi uzly
`{"id":"K4", "a":"J4W", "b":"J4E", "body":[[x,y],…], "kolej":"4"}`
- `a` → `b` určuje směr „ab“ (používá se u návěstidel), `body` je lomená čára pro kreslení.
- `kolej` – jen u úseků, na které se dá klepnout jako „stojím / cíl“ (staniční, manipulační, kusé koleje, vlečky). Spojovací úseky v zhlaví kolej nemají.
- `"trat": true` – úsek tratě za vjezdovým návěstidlem.

## Koleje (`koleje`) – tvary pro větu
`"4": {"nazev":"4. kolej", "gen":"čtvrté koleje", "acc":"čtvrtou kolej", "loc":"na čtvrté koleji", "uvrat": true}`
- `gen` („ze čtvrté koleje“), `acc` („na čtvrtou kolej“), `loc` („na čtvrté koleji“); předložku z/ze pomůcka odhadne, jinak `"z":"ze"`.
- `uvrat` – smí se na koleji změnit směr (úvrať). Na výtažných, kusých a staničních kolejích obvykle ano.

## Návěstidla (`navestidla`)
`{"id":"Se8", "typ":"seradovaci", "usek":"s3_5", "smer":"ba", "pos":0.5}`
- `typ`: `seradovaci`, `odjezdove`, `vjezdove`, `cestove`
- `usek` + `pos` (0 = u uzlu `a`, 1 = u uzlu `b`) = kde stojí; `smer` = pro který směr jízdy platí (`ab` nebo `ba`).

## Co potřebuju z plánku Chomutova
1. Schematický plánek kolejiště (ZDD / SŘ, příloha plánek) – čitelná **čísla kolejí, výhybek a návěstidel**.
2. Které koleje jsou kusé, výtažné, manipulační, a názvy vleček (např. vlečka NTM).
3. U každého návěstidla, na kterou stranu platí (šipka / strana koleje stačí).
4. Obvody výpravčích (kdo řídí které zhlaví) a jejich volací jména, pokud se volá jinak než „Výpravčí Chomutov“.
5. Datum platnosti plánku.

Ze zaslané fotky/skenu převedu plánek do tohoto formátu ručně; pomůcka pak spočítá trasy sama.
