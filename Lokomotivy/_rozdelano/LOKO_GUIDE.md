# Lokomotivy – průvodce dokumenty

Pracovní adresář: `/home/claude/zoz/loko/`
- `txt/<id>.txt` – text dokumentu (`pdftotext -layout`), čti Read s offset/limit nebo grep
- `img/<id>-NN.png` – každá stránka jako obrázek (90 dpi), NN = číslo strany dvojmístně (01, 02 …). **Když je text na stránce řídký nebo rozházený (dva sloupce, tabulky, fotky s popisky), otevři obrázek stránky.**
- `pdf/<id>.pdf` – originál (jen pro pdftotext s jinými parametry, obvykle není třeba)

## Řady a hodnota pole `rada` (přesně takto)
| `rada` | zobrazovaný název | poznámka |
|---|---|---|
| `Vectron` | Vectron (ř. 193/383) | Siemens Vectron ČD/ČD Cargo |
| `162/163` | 162/163 Peršing | Škoda 69E/71E |
| `362 WTB` | 362 WTB Eso | Škoda 69Er, s WTB a ETCS |
| `650` | 650 RegioPanter | jednotka Škoda, platí i pro 640/660 tam, kde to dokument říká |
| `810` | 810 | motorový vůz |

## Dokumenty (id → co to je, stran, verze)
| id | řada | dokument | stran | verze / účinnost | poznámka k textu |
|---|---|---|---|---|---|
| `vectron_zavady` | Vectron | **Závady v kostce HV Vectron** | 16 | verze 3, od 1. 4. 2026 | číslované kroky po panelech, fotky vedle kroků (v textu prázdná místa) |
| `vectron_provoz_poruchy` | Vectron | **Pokyn č. 3/2023 VECTRON – Provozní a poruchové stavy**, změna 5 | 54 | od 1. 12. 2025 | nejrozsáhlejší; kapitoly k obsluze, zobrazením displeje, poruchovým hlášením a postupům |
| `vectron_etcs` | Vectron | Pokyn č. 5/2024 ř. 193, 383, 384, 5 370 (Vectron), Afmpz 80-90 – provoz ETCS a uvedení ETCS do provozu, změna 8 | 28 | od 15. 6. 2026 | |
| `163_zavady` | 162/163 | **Závady vozidel v kostce ř. 162, 163** | 36 | verze 2, od 23. 1. 2023 | obsahuje „RYCHLÁ ORIENTACE“ = rozhodovací strom (nelze odzemnit / nelze zapnout HV / …) a číslované kapitoly 1–12 |
| `163_prevzeti` | 162/163 | Technologické postupy pro převzetí/odstavení HV ř. 162, 163 (dle ČD V2, změna 2, od 14. 12. 2025) | 10 | | tabulka úkonů se sloupci druhů odstavení (P1, 2a…9) – co se kontroluje při převzetí úplném, zkráceném atd. |
| `163_pripomenuti` | 162/163 | Lokomotiva řady 163 – KRÁTKÉ PŘIPOMENUTÍ (DKV Praha, 2015, M. Svoboda) | 10 | 2015 | **neoficiální pomůcka**, starší – vhodné na otázky „kde co je / jak se zprovozní“, u rozporů se Závadami v kostce má přednost Závady v kostce |
| `362_zavady` | 362 WTB | **Závady vozidel v kostce ř. 362 WTB (MSV)** | 16 | verze 2, od 23. 1. 2022/2023 | |
| `362_prevzeti` | 362 WTB | Technologické postupy pro převzetí HV ř. 362 WTB s ETCS (dle ČD V2) | 10 | od 14. 12. 2025 | |
| `362_prevzeti_souprava` | 362 WTB | Technologické postupy převzetí HV+ŘV – souprava 362 WTB s ETCS + osobní vozy + ŘV 80-30 s ETCS | 16 | od 14. 12. 2025 | |
| `362_etcs` | 362 WTB | Pokyn č. 17/2024 ř. 162WTB/362/362WTB – provoz ETCS a uvedení ETCS do provozu | 6 | od 1. 2. 2024 | |
| `650_zavady` | 650 | **Závady vozidel v kostce ř. 650 RegioPanter** | 12 | verze 2, od 23. 1. 2023 | **POZOR: str. 2 a další mají DVA SLOUPCE (dva souběžné postupy) – text je prokládaný, vždy se podívej na obrázek stránky** |
| `650_odtah` | 650 | Brzděný odtah el. jednotek Panter | 12 | | hodně fotek, málo textu – používej obrázky stránek |
| `650_etcs` | 650 | Pokyn č. 19/2024 ř. 650 RegioPanter – provoz ETCS a uvedení ETCS do provozu | 9 | od 1. 12. 2024 | str. 2–8 jsou fotky umístění zařízení s krátkými popisky – používej obrázky stránek |
| `650_prevzeti` | 650 | Technologické postupy převzetí HV – souprava 640, 640.1, 640.2, 650, 650.2, 660, 661 (dle ČD V2) | 10 | od 14. 12. 2025 | |
| `810_prevzeti` | 810 | Technologické postupy převzetí HV ř. 809, 810 (dle ČD V2, změna 1) | 4 | od 14. 12. 2025 | jediný dokument k 810; Závady v kostce Pavel dodá později |

## Jak citovat zdroj (pole `zdroje` u otázky, `zdroj` u postupu)
`{"predpis": "<název dokumentu jak je v tabulce, zkráceně>", "clanek": "<kapitola / bod / strana>"}`
Příklady: `{"predpis":"Závady v kostce HV Vectron v3","clanek":"Bezpečný stav lokomotivy, body 1–6"}`,
`{"predpis":"Pokyn 3/2023 Vectron","clanek":"kap. 4.2, str. 17"}`, `{"predpis":"Převzetí HV 162/163 (ČD V2)","clanek":"úkon 12, sloupec P1"}`.
Vždy uveď stranu nebo kapitolu, kterou jsi opravdu viděl v textu / na obrázku.
