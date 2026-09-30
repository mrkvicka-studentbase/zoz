# Nahrávky hlasů pro simulaci posunu

Soubory **MP3** dej do `web/audio/posun/` a jejich názvy zapiš do `seznam.json`:

```json
{"soubory":["st_slysim_v1.mp3","st_souhlas.mp3"]}
```

Chybějící nahrávku simulace nahradí syntetickým hlasem telefonu, který řekne celé znění i s čísly kolejí. Když syntetický hlas není, zobrazí se jen titulek.
Nahrávky jsou **obecné**, tedy bez čísla vlaku a kolejí. Titulek na obrazovce ukazuje přesné znění pro zvolenou trasu.

Stanoviště: `v1` = Doprava Chomutov (výpravčí 1), `st1` = Stavidlo 1, `st2` = Stavidlo 2.
U hlášek stavědla (`st_…`) stačí jedna společná nahrávka bez přípony. Pokud má mít každé stavědlo jiný hlas, nahraj ji zvlášť s příponou `_v1`, `_st1` nebo `_st2`.

## Stavědlo / výpravčí (druhý hlas)
| soubor | text |
|---|---|
| `st_slysim_v1.mp3` | Doprava Chomutov, slyším. Příjem. |
| `st_slysim_st1.mp3` | Stavidlo jedna Chomutov, slyším. Příjem. |
| `st_slysim_st2.mp3` | Stavidlo dva Chomutov, slyším. Příjem. |
| `st_souhlas.mp3` | Souhlas k posunu dávám. Posun dovolen. Příjem. |
| `st_zastav.mp3` | Posunový díl, můžeš zastavit. Příjem. |
| `st_dovolen.mp3` | Posunový díl, posun dovolen, můžeš jet. Příjem. |

## Strojvedoucí (ty)
| soubor | text |
|---|---|
| `ty_ohlaseni_v1.mp3` | Doprava Chomutov, zde strojvedoucí posunového dílu. Příjem. |
| `ty_ohlaseni_st1.mp3` | Stavidlo jedna Chomutov, zde strojvedoucí posunového dílu. Příjem. |
| `ty_ohlaseni_st2.mp3` | Stavidlo dva Chomutov, zde strojvedoucí posunového dílu. Příjem. |
| `ty_zadost.mp3` | Žádám o souhlas k posunu. Příjem. |
| `ty_rozumim_souhlas.mp3` | Rozumím, souhlas k posunu. Konec. |
| `ty_zastavuji.mp3` | Rozumím, zastavuji. Konec. |
| `ty_rozumim_dovolen.mp3` | Rozumím, posun dovolen. Konec. |

Tipy: mluv normálně, jako do vysílačky. Na začátku a na konci nech co nejméně ticha. Šum a „cvaknutí“ vysílačky přidá aplikace sama.
