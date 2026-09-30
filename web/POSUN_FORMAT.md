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
| `zhlavi` | zhlaví bez seřaďovacích návěstidel, kde se smí otočit hned za výhybkou (celým dílem za izolovaný styk): `[{"id":"st1","vyhybky":["3",…,"27"],"komu":"st1","radio":["1",…,"28"],"souhlas":"PS1 …"}]` – úvrať se smí na spojovacím úseku mezi dvěma výhybkami z `vyhybky`; `radio` = výhybky, jejichž stavědlo (`komu`) tě na trase zastavuje a potvrzuje Posun dovolen rádiem (i u návěstidel) |
| `neprofilove` | izolované styky, které nekontrolují volnost námezníku (SŘ čl. 19): `{"21":"mezi výhybkami č. 21 a 24"}` – u úvratě za touto výhybkou pomůcka upozorní, ať se zajede i za námezník |
| `nastupiste` | nástupiště pro 3D: `[{"x0","y0","x1","y1","delka"}]` – obdélník ze schématu SŘ (souřadnice plánku); šířka se v 3D dopočítá z mezery mezi kolejemi |
| `prechody` | přechody přes koleje: `[{"x","y0","y1","popis"}]` |
| `budovy` | `[{"typ":"vb"|"stavedlo","nazev","x","y","dk":true}]` – výpravní budova / stavědlo; v 3D se posune mimo koleje, pokud by v nich stála |
| `okoli` | stavby pro orientaci ve 3D (souřadnice plánku, rozměry v m: d podél kolejí, s napříč, v výška): `typ` `obchod` (kostka s nápisem; `barva`, `pozadi`, `pismo`, `pruh`, `bok`), `parkoviste`, `posta`, `muzeum` (`haly`), `lavka` (`x`, `y0`, `y1` – přes kolejiště; brány trakčního vedení se jí vyhnou) |
| `zkraceni3d` | zkrácení natažené části schématu jen ve 3D: `[{"pred":880,"k":0.5}]` – vše západně od x = 880 se k tomuto bodu přiblíží na polovinu |
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

## 3D simulace
Tlačítko **▶ Simulace 3D** u trasy vykreslí stejný plánek ve 3D (knihovna three.js se stáhne při prvním spuštění, pak ji drží service worker offline).
Posunovací lokomotiva projede vypočtenou trasu: před návěstidly na trase čeká na Posun dovolen (seřaďovací: modré → bílé; hlavní: červené + bílé),
na úvrati zastaví, pohled se otočí o 180° (přechod na druhé stanoviště) a u úvratě v zhlaví čeká na souhlas pracoviště. Pohledy Kabina / Zvenku / Shora, rychlost 1×–8×.
Kusé koleje se ve 3D prodlouží na `uzitecna` (od návěstidla u koleje k zarážedlu), protože schéma je u nich zkrácené. Plánek není v měřítku – souřadnice se natahují (`P3S` v kódu: podélně ×0,75 – odpovídá délkám nástupišť v SŘ, napříč ×0,3).

## Chomutov – jak vznikl
Plánek Chomutova (`id: chomutov`) je převedený automaticky z vektorového schématu v SŘ ŽST Chomutov (str. 1): čáry kolejí → graf,
čísla výhybek a kmen výhybky podle geometrie, návěstidla podle symbolů a popisků (12 dosazeno ručně), koleje a jejich údaje
z tabulky kolejí SŘ (str. 15–17), pracoviště a telefony ze str. 42–43, obvody a pravidla posunu ze str. 56–58, vlečka NTM z jejího PŘ.
Kontrolováno, že každá nezakázaná kolej je dosažitelná z každé jiné.

## Co potřebuju pro další stanici
1. SŘ stanice jako PDF (ne sken) – schéma kolejiště, tabulka kolejí, sdělovací zařízení, posun (posunovací obvody).
2. PŘ vleček, na které se tam posunuje.
3. Volací jména, pokud se volá jinak, než je uvedeno v SŘ.
