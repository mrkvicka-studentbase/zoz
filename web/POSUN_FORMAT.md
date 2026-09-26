# Posunová pomůcka – formát plánku stanice (`web/posun.json`)

Pomůcka je obecná: nový plánek = nový záznam v poli `stanice`. Kód se nemění.
Plánek je **schéma**, ne měřítko – stačí, aby seděla topologie (co s čím je spojené přes jakou výhybku) a pořadí návěstidel.

## Záznam stanice
| pole | význam |
|---|---|
| `id`, `nazev` | identifikátor a název („Chomutov“) |
| `v` | 6. pád s předložkou pro větu („v Chomutově“) |
| `vypravci` | jak se volá výpravčí, když stanice nemá `pracoviste` („Výpravčí Lhota“) |
| `pracoviste` | u více výpravčích/signalistů: `{"v1":{"nazev":"Výpravčí 1 Chomutov","volaci":"Doprava Chomutov","gsmr":"7 53 489 02","tel":"972 062 431"},…}` – `nazev` je oficiální název ze SŘ, `volaci` jak se v praxi volá (použije se ve větě, oficiální název se ukáže v závorce) |
| `vychozi` | id pracoviště, které se volá, když cílová kolej nemá obvod (`"v1"`) |
| `obvody` | posunovací obvody ze SŘ: `[{"c":0,"prideleno":"posunovač ČD (vlečka)","souhlas":"výpravčí 1","volat":"v1","pozn":"…"},…]` – komu volat se určí podle obvodu **cílové** koleje |
| `posunPozn` | obecné poznámky k posunu ze SŘ (zobrazí se pod „Voláš“) |
| `pohled` | x-souřadnice, na kterou se široký plánek po otevření vycentruje (osobní nádraží) |
| `meritko` | min. šířka plánku v px = šířka schématu × `meritko` (velké stanice se posouvají do stran; výchozí 0,68) |
| `elektrizovana` | `true` → v žádosti se uvádí závislá / nezávislá trakce (D1 čl. 229 odst. 5 f) |
| `rozmer` | `[šířka, výška]` souřadnic schématu (např. `[1000, 380]`) |
| `zdroj` | odkud plánek je a k jakému datu (zobrazí se pod plánkem) |
| `ukazka` | `true` jen u vymyšlené ukázkové stanice |

## Uzly (`uzly`) – body, kde se úseky potkávají
- `{"x":…, "y":…}` – obyčejný spoj dvou úseků (konec koleje, zlom)
- `"typ":"vyhybka", "c":"12", "kmen":"<id úseku>"` – výhybka číslo 12; **kmen** je úsek, ze kterého se do výhybky jede „špičkou“. Výhybkou se jede jen kmen ↔ větev, nikdy větev ↔ větev.
- `"typ":"zarazedlo"` – kusá kolej; `"typ":"trat", "popis":"trať do Březenců"` – odchod na trať; `"typ":"konec"` – konec kreslené koleje (vlečka pokračuje mimo plánek).
- `"typ":"krizeni"` – kolejové křížení (4 úseky, projíždí se rovně, bez přestavení).

## Úseky (`useky`) – kusy kolejí mezi uzly
`{"id":"K4", "a":"J4W", "b":"J4E", "body":[[x,y],…], "kolej":"4"}`
- `a` → `b` určuje směr „ab“ (používá se u návěstidel), `body` je lomená čára pro kreslení.
- `kolej` – jen u úseků, na které se dá klepnout jako „stojím / cíl“ (staniční, manipulační, kusé koleje, vlečky). Spojovací úseky v zhlaví kolej nemají.
- `"trat": true` – traťová kolej za vjezdovým návěstidlem. Posun se na ni nevede, ale smí se na ní změnit směr **před označníkem** (pomůcka to v trase i větě uvede: „posun jen k označníku, za něj ne“).
- `"zakaz": true` – v plánku SŘ červeně (zákaz jízdy drážních vozidel) – pomůcka přes úsek nevede trasu.
- `"carkovane": true` – kreslí se čárkovaně (např. kolej jiného provozovatele).

## Koleje (`koleje`) – tvary pro větu
`"4": {"nazev":"4. kolej", "gen":"čtvrté koleje", "acc":"čtvrtou kolej", "loc":"na čtvrté koleji", "uvrat": true}`
- `gen` („ze čtvrté koleje“), `acc` („na čtvrtou kolej“), `loc` („na čtvrté koleji“); předložku z/ze pomůcka odhadne, jinak `"z":"ze"`.
- `uvrat` – smí se na koleji změnit směr (úvrať), výchozí ano. `false` u účelových kolejí (OSPD) a vleček. Na kolejích, jejichž `pozn` obsahuje „výtažn“, pomůcka úvrať volí přednostně.
- `typ`, `pozn`, `uzitecna` (m) – z tabulky kolejí SŘ, zobrazí se u vybrané koleje.
- `zakaz: true` – kolej nejde vybrat ani projet (zákaz jízdy drážních vozidel).
- `obvod` – číslo posunovacího obvodu (viz `obvody`).

## Návěstidla (`navestidla`)
`{"id":"Se8", "typ":"seradovaci", "usek":"s3_5", "smer":"ba", "pos":0.5}`
- `typ`: `seradovaci`, `odjezdove`, `vjezdove`, `cestove`
- `usek` + `pos` (0 = u uzlu `a`, 1 = u uzlu `b`) = kde stojí; `smer` = pro který směr jízdy platí (`ab` nebo `ba`).

## Chomutov – jak vznikl
Plánek Chomutova (`id: chomutov`) je převedený automaticky z vektorového schématu v SŘ ŽST Chomutov (str. 1): čáry kolejí → graf,
čísla výhybek a kmen výhybky podle geometrie, návěstidla podle symbolů a popisků (12 dosazeno ručně), koleje a jejich údaje
z tabulky kolejí SŘ (str. 15–17), pracoviště a telefony ze str. 42–43, obvody a pravidla posunu ze str. 56–58, vlečka NTM z jejího PŘ.
Kontrolováno, že každá nezakázaná kolej je dosažitelná z každé jiné.

## Co potřebuju pro další stanici
1. SŘ stanice jako PDF (ne sken) – schéma kolejiště, tabulka kolejí, sdělovací zařízení, posun (posunovací obvody).
2. PŘ vleček, na které se tam posunuje.
3. Volací jména, pokud se volá jinak, než je uvedeno v SŘ.
