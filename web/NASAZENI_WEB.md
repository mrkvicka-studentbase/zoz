# ZOZ Trenažér – nasazení na zozstroj.eu

## ⬆ Aktualizace – Posun: 3D simulace a úvrať za izolovaným stykem

Nahraj `index.html`, `sw.js` a `posun.json` z `na_web.zip`. Databáze se nemění. Offline režim `shell-zoz-v28`.

- **▶ Simulace 3D** (u vypočtené trasy): plánek se „sklopí“ z pohledu shora do 3D, posunovací lokomotiva projede trasu. Před návěstidly na trase čeká na **Posun dovolen** (seřaďovací modré → bílé, hlavní červené + bílé), na úvrati zastaví a pohled se otočí o 180° – přechod na druhé stanoviště. Pohled z kabiny, zvenku a shora, rychlost 1×–8×, pauza (mezerník), Esc zavře.
- **Rádio jako v praxi:** před úvratí tě stavědlo zastaví („Posunový díl 6802, můžeš zastavit.“), Posun dovolen dá rádiem („…, posun dovolen na desátou kolej.“) – hned při zastavení, nebo až po přechodu na druhé stanoviště; u návěstidla (např. Se1) bílé světlo + potvrzení rádiem. Oslovení bere číslo z údajů do hlášení.
- **Úvrať za izolovaným stykem i v zhlaví St.2** (výhybky 49–72 kromě 53, 55, 58, 60, 62, 68 – přístup na NTM a 4b/6b), souhlas Stavidlo 2 (PS5–PS8). Např. 2 → 9: L2 → 56, 59, 63, 64, 66 → úvrať za výhybkou 66 → 66, 61, 57, 54 → 9.
- **Jednotka ř. 844 RegioShark** (Pesa Link) v barvách ČD bez log: dvě skříně na společném podvozku (44 m), žraločí čelo, kabina s pultem. Jednotka dojede čelem ke kusé koleji, za izolovaný styk zajede celá, před návěstidlem zastaví čelem; přechod na druhé stanoviště = zatmění a pohled z kabiny na druhém konci.
- **Kusé koleje v 3D v užitečné délce ze SŘ** (schéma je u nich zkrácené), měřeno od návěstidla u koleje k zarážedlu; na koncích zarážedla. Na výtah 4c (102 m) se vejde 844 i 814 – po úvrati je Se1 dobře vidět z kabiny.
- **Budovy podle fotek:** výpravní budova (vysoká střední budova se štítem, přízemní křídla s oblouky, koncové pavilony, červené valbové střechy, přístřešek na sloupech), St. 1 (bílé, vystouplý prosklený velín, cedule CHOMUTOV), St. 2 (žlutá věž s velínem).
- **3D okolí stanice:** nástupiště s přístřešky a osvětlením (polohy a délky 115–300 m podle schématu SŘ), přechod v km 64,693, výpravní budova s DK, stavědla St. 1 a St. 2, trakční vedení se stožáry. Plánek je v podélném směru zkrácený na polovinu – odpovídá skutečným délkám nástupišť, posun je tak 2× kratší.
- 3D knihovna (three.js, ~600 kB) se stáhne až při prvním spuštění simulace z cdn.jsdelivr.net; potom ji service worker drží a simulace jde i bez signálu.
- **Chomutov – úvrať v zhlaví St.1:** v zhlaví St.1 (výhybky 3–27, bez seřaďovacích návěstidel) se už nejezdí zbytečně do výtahu 4c. Stačí zajet celým posunovým dílem za izolovaný styk za výhybkou a počkat na Posun dovolen od Stavidla 1 (souhlasy PS1–PS4). Např. 4 → 10: S4 → výhybka 21 → úvrať → 21, 24, 26, 28 → 10. U styků, které podle SŘ nekontrolují volnost námezníku (např. 21–24), pomůcka upozorní, ať se zajede i za námezník. Výhybky 1 a 2 (směr Černovice) dál vedou do výtahu 4c (SŘ čl. 54) – 4 → NTM: S4 → 4c → Se1 → NTM.

## ⬆ Aktualizace – Posunová pomůcka: skutečný plánek ŽST Chomutov

Nahraj `index.html`, `sw.js` a `posun.json` z `na_web.zip`. Databáze se nemění. Offline režim `shell-zoz-v27`.

- **Chomutov** podle SŘ ŽST Chomutov: 64 kolejí, 105 výhybek, 56 návěstidel, vlečka NTM a Průmyslová kolej. Na velkém plánku se posouvá do stran.
- **Komu voláš** se řídí posunovacím obvodem cílové koleje (SŘ čl. 52–53): volá se, jak je zvykem – **Doprava Chomutov**, **Stavidlo 2 Chomutov**, **Stavidlo 1 Chomutov** (oficiální název ze SŘ v závorce) – s GSM-R číslem a telefonem ze SŘ. U vlečky NTM i posunovač ČD (tel. 725 817 925, rádio STE 4 kanál 19).
- U vybrané koleje se ukáže typ, užitečná délka a poznámka ze SŘ. Koleje se zákazem jízdy (v SŘ červeně) nejdou vybrat a trasa přes ně nevede.
- Úvrať: přednostně na výtažné koleji („výtah“, např. 4c) – dojede se až ke kusé koleji, takže trasa ukáže i seřaďovací návěstidlo pro jízdu zpět (4 → NTM: S4 a Se1, dvakrát Posun dovolen); nikdy na účelových kolejích OSPD. Když jinak nejde, pomůcka změní směr na traťové koleji **před označníkem** a výslovně to napíše („posun jen k označníku, za něj ne“).
- Ukázková Lhota zůstává jako druhá stanice.

## ⬆ Aktualizace – Posunová pomůcka (BETA, zatím jen ukázková stanice)

Nahraj `index.html`, `sw.js` a **nový soubor `posun.json`** (plánky stanic) z `na_web.zip`. Databáze se nemění. Offline režim `shell-zoz-v26`.

- **Posunová pomůcka** (záložka Posun, na mobilu pod „Více“): vybereš stanici, v plánku klepneš na kolej, kde stojíš, a na kolej, kam chceš. Pomůcka:
  - sestaví, **co řekneš výpravčímu** – ohlášení („Výpravčí …, zde je strojvedoucí posunového dílu od vlaku … na čtvrté koleji v …“) a žádost o souhlas k posunu s náležitostmi podle **D1 čl. 229 odst. (5)** (dopravce, příjmení, s/bez posunové čety, závislá trakce, odstavení na cílové koleji), navazování spojení podle **Z11**; umí to i přečíst nahlas;
  - ukáže **trasu**: kolem kterých návěstidel pojedeš (a že potřebuješ Posun dovolen – bílé světlo, s obrázkem z návěstního atlasu), přes které výhybky a **kde je úvrať**.
- Údaje (číslo vlaku, dopravce, příjmení) si pamatuje.
- Zatím je v ní jen **vymyšlená „Ukázková Lhota“**. Skutečné stanice se doplňují do `posun.json` podle `web/POSUN_FORMAT.md` – kód se nemění.

---

## ⬆ Aktualizace – Návěstní atlas a trenažér závazných slovních znění

Nahraj `index.html`, `sw.js` a **nový soubor `navesti.json`** (1,8 MB, obrázky návěstí) z `na_web.zip` – všechny tři vedle sebe do kořene webu. Databáze se nemění. Offline režim je `shell-zoz-v25`.

- **Návěstní atlas** (záložka Návěsti, na mobilu pod „Více“): 275 návěstí z SŽ D1 s obrázkem, vzhledem (kurzívou z předpisu), významem a odkazem na článek a stranu. Hledání („přerušované bílé“, „rychlostník“), filtr podle skupin (hlavní návěstidla, předvěsti, posun, elektrický provoz, přejezdy…), detail s listováním a odkazem na otázky, kde se návěst objevuje.
- **Kvíz návěstí**: 10 otázek – obrázek → název, nebo název → vyber obrázek; možnosti ze stejné skupiny, po odpovědi vzhled a význam. Přednostně dává návěsti, ve kterých chybuješ; filtr „Chybuji“.
- **Závazná slovní znění** (záložka Znění): 16 znění ze Z11, D1, D2 a ObŘ (G-STOP, horké ložisko STOP/K, nouzové hlášení, informace o návěsti telefonem, odvolání výpravy a tvoje potvrzení, souhlas k posunu, sunutý vlak, ohlášení a zkouška spojení) + 10 výrazů terminologie Z11 přílohy O. Aplikace zadá situaci s konkrétním číslem vlaku a stanicí, ty znění napíšeš nebo **nadiktuješ** (🎤, česky – diktování potřebuje připojení) a uvidíš, která slova chyběla. Režim Kartičky a Přehled všech znění. Znění, která předpis uvádí jen jako příklad, jsou označená „vzor“.
- Hledání „Co teď?“ nabídne odkaz do atlasu, když dotaz odpovídá názvu návěsti.
- Atlas se po přihlášení stáhne na pozadí a uloží do telefonu – funguje i bez signálu. Nová verze D1: vyměň `D1.pdf` a spusť `python3 web/tools/navesti.py` (vyžaduje `pip install pymupdf`).

---

## ⬆ Aktualizace – GSM-R zkrácené volby s vyhledáváním

Stačí nahrát `index.html` a `sw.js` z `na_web.zip`. Databáze se nemění.

- **Nová záložka GSM-R** (na mobilu pod „Více“): napíšeš stanici, trať nebo pracoviště (např. „Ústí“, „Chomutov“, „504A“, „Brno hl. n.“) a hned vidíš **adresné zkrácené volby** výpravčích a dispečerů z **PŘ GSM-R CZ, Příloha B** (229 voleb), seskupené po tratích, uzlech a oblastech CDP. Hledaná stanice je v rámci trati nahoře.
- Rozumí zkratkám předpisu („Ústí nad Labem“ najde „Ústí n.L.“, „Karlovy Vary“ najde „K. Vary“), nevadí chybějící diakritika.
- Když pro stanici platí **místní opatření z Přílohy C** (např. „v ŽST Protivín nelze využít 1300 – použij 1335“), ukáže se nahoře žlutě.
- Pracoviště PPV (platí jen při poruše DOZ a zpravování písemným rozkazem) jsou označená a řazená až za tratěmi.
- Dole vždy obecné volby: ZV1 1200, ZV2 1300, ZV3 1400, SKP 200 (SŽ Z11, tab. K.1).
- Hledání „Co teď?“ nabídne odkaz na zkrácené volby, když dotaz odpovídá stanici.
- Data jsou přímo v aplikaci, takže fungují i bez signálu. Při nové verzi PŘ GSM-R stačí vyměnit `GSMR.pdf` a spustit `python3 web/tools/gsmr_zv.py` (vyžaduje `pip install pdfplumber`) – data se vytáhnou do `web/gsmr_zv.json` a vloží do aplikace.

---

## ⬆ Aktualizace – kabinový režim, hledání „Co teď?“, plán přípravy do ZOZ

1. **SQL editor → `cast7_plan.sql` → Run** (přidá k profilu sloupec pro plán – ať platí na mobilu i na počítači; bez něj plán funguje jen v zařízení).
2. Nahraj `index.html` a `sw.js` z `na_web.zip` (offline režim `shell-zoz-v24`).

- **Kabinový režim krizových postupů:** v postupu tlačítko **☾ Kabinový režim** – jeden úkon přes celou obrazovku, velké **✓ HOTOVO** / **ANO** / **NE**, noční červené barvy (☀/☾ přepne na denní), **A− / A+** velikost písma, **🔊** předčítání česky, displej nezhasíná, **↶ Zpět** vrátí poslední úkon. V seznamu poruch jde zaškrtnout „Otevírat postupy rovnou v kabinovém režimu“.
- **Bez signálu:** u výběru řady je vidět „Připraveno na jízdu bez signálu“ – postupy i fotky k nim se uloží do telefonu (fotky se stáhnou samy). Aplikace se bez signálu už **nepřepne na přihlášení** – jede z uloženého účtu, profilu a statistik a po návratu signálu je obnoví.
- **Hledat „Co teď?“** (lupa v hlavičce, na počítači klávesa `/`): napíšeš, co se děje, a hned vidíš otázky, zkrácené odpovědi, články předpisů i krizové postupy tvých řad. Nevadí chybějící háčky, jiný pád ani překlep; zkratky HV, PN, VZ, MU, GSM-R. Funguje i bez signálu.
- **Příprava do ZOZ** (nahoře v záložce ZOZ): nastavíš datum ZOZ a kolik minut denně. Aplikace každý den připraví **denní dávku** – otázky, které je potřeba zopakovat (správně → vrátí se za 1, 3, 7, 14, 30 dní; chyba → zítra znovu) a k nim nové tak, aby bylo všechno probrané týden před ZOZ. Ukazuje odpočet, **připravenost v %** (předpisy / lokomotivy), dny v řadě a co tě čeká zítra. Co už kdo procvičoval, se do plánu převezme. Odpovědi se počítají i do Statistik.
- Nadpis a upozornění těsně před bodem, na který rozhodnutí v krizovém postupu skočí (např. „Vstupuješ-li do strojovny, zavři kohoutky…“), se už neschovávají.

---

## ⬆ Aktualizace – krizové postupy pro všechny (BETA)

1. Nahraj `index.html`, `sw.js` a `.htaccess` z `na_web.zip`.
2. **SQL editor → `zverejnit_krizove_postupy.sql` → Run.** Od té chvíle je databáze vydá všem přihlášeným a záložka Krizové postupy se jim objeví při dalším otevření aplikace.

- V menu má záložka štítek **BETA**.
- Před prvním otevřením musí každý přečíst červené upozornění a zaškrtnout **„Rozumím: je to jen nezávazné doporučení a za své úkony odpovídám sám“** (jednou na zařízení).
- Červené upozornění **„Jen doporučený postup ze Závad v kostce – nezávazný. Za manipulace odpovídá strojvedoucí…“** je na každé obrazovce krizových postupů: celé znění (i s příkladem s hasicím přístrojem) jen jednou při potvrzení, zkrácené u výběru řady, u seznamu poruch a nad i pod každou myšlenkovou mapou.
- Zpátky jen pro admina: postup je v komentáři `zverejnit_krizove_postupy.sql`.

---

## ⬆ Aktualizace – 6 nových řad + krizové postupy jako myšlenková mapa

1. Nahraj `index.html`, `sw.js` a `.htaccess` z `na_web.zip`.
2. **Admin → Obsah otázek → nahraj nový `zoz_loko.json`** (878 otázek k lokomotivám, 230 krizových postupů). SQL se nemění.

- **Nové řady:** 162/163 WTB, 362 (Eso bez WTB), 471 Slon, 814 Regionova, 840/841 Stadler, 844 Žralok – jen ze Závad v kostce, takže jsou v rozsahu „Závady v kostce“, v Komplexním i v Simulaci ZOZ, a mají krizové postupy.
- **Krizové postupy jako myšlenková mapa shora dolů:** nahoře název poruchy, pod ním úkony spojené čarou. U otázky se mapa rozvětví – **ANO vlevo (zeleně), NE vpravo (červeně)**, u každé větve je vidět, kam vede. Po volbě se vybraná větev rozsvítí, druhá zešedne a mapa pokračuje dolů zvolenou cestou. Volbu jde změnit kliknutím na druhou větev.

---

## ⬆ Aktualizace – řady u účtu, Závady v kostce / Komplexní, pauza na kafe

1. **SQL editor → `cast6_rady_ucet.sql` → Run** (přidá k profilu sloupec pro výběr řad).
2. Nahraj `index.html`, `sw.js` a `.htaccess` z `na_web.zip`.

- **Výběr řad se ukládá k účtu** – naklikáš jednou a platí na počítači i mobilu. Totéž pro řady s autorizací v Simulaci ZOZ a pro volbu Závady v kostce / Komplexní. Při prvním spuštění se na účet uloží výběr z toho zařízení, kde ho už máš.
- **Výběr řad přestavěný pro libovolný počet řad:** v hlavičce Lokomotiv je jen řádek „Moje řady“ se zelenými štítky a tlačítkem **Změnit**. To otevře seznam se zaškrtávátky (na mobilu panel zespodu), s „Vybrat vše / Zrušit vše“ a počtem otázek u každé řady. **Nová řada se objeví sama**, jakmile k ní nahraješ otázky – v kódu se nic nemění. (Popisek pod názvem, např. „Peršing“, doplním, až budou řady známé.)
- **Zvolené tlačítko je zřetelně označené** – zelený rámeček, zelená fajfka v rohu, nevybrané jsou tlumené.
- **Lokomotivy mají dva rozsahy:** **Závady v kostce** (290 otázek – „co uděláš, když…“) a **Komplexní** (všech 606: navíc převzetí HV, ETCS, pokyny, pomůcky). Přepínač je v hlavičce Lokomotiv pod řadami.
- **Simulace ZOZ** bere v ústní části otázky na lokomotivy **jen ze Závad v kostce**.
- **Pauza na kafe 5 minut** mezi písemnou a ústní částí – odpočítává se, ústní část pak začne sama, nebo se dá pauza přeskočit.
- Při nesplnění písemné i ústní části: **„Zavolej strojmistrovi a domluv si neplacené volno a uč se!“**

---

## ⬆ Mobil ukazuje starou verzi – oprava

Otázky a statistiky jsou v databázi na serveru, **ne v počítači** – všechna zařízení je stahují ze stejného místa. Když je mobil nevidí, běží na něm stará verze aplikace z cache.

**Trvalá oprava (nová verze):**
1. Nahraj na web `index.html`, `sw.js` a **nový soubor `.htaccess`** (je v `na_web.zip`; začíná tečkou, takže ho některé FTP klienty skrývají – zapni zobrazování skrytých souborů). Říká hostingu i prohlížeči, že aplikaci nesmí brát ze staré cache.
2. Nový `sw.js` si HTML stahuje vždy čerstvé ze serveru.

**Jednorázově na mobilu:**
- Když v aplikaci vidíš **Více → Admin → Verze aplikace**, klikni **Vynutit aktualizaci**.
- Když tam tahle sekce není (hodně stará verze): zavři aplikaci, v prohlížeči otevři zozstroj.eu a obnov stránku. Pokud ani to nepomůže, v nastavení prohlížeče smaž data webu zozstroj.eu (Android Chrome: ⋮ → Nastavení → Nastavení webu → Všechny weby → zozstroj.eu → Vymazat a resetovat) a přihlas se znovu.

**Ověření:** na mobilu v Admin → Verze aplikace musí být stejné „Sestavení aplikace“ jako na počítači a offline režim `shell-zoz-v13`.

> Výběr řad se od verze se `cast6_rady_ucet.sql` ukládá k účtu, takže platí na všech zařízeních.

---

## ⬆ Aktualizace – Simulace ZOZ a rozdělené statistiky

Stačí nahrát `index.html` a `sw.js` z nového `na_web.zip`. Databáze se nemění.

- **Simulace ZOZ** (nová záložka, na mobilu „ZOZ“): nejdřív výběr řad, na které má člověk autorizaci. **Písemná část** má 50 otázek z předpisů a 30 minut. Mezi otázkami se dá volně přeskakovat (mřížka čísel) a odpovědi jde měnit až do odevzdání. Správnost se ukáže až na konci a projde se s 40 správnými (80 %). Když čas vyprší, test se odevzdá sám. Po úspěchu následuje **ústní část**: znovu otázky, které byly v písemné špatně, a k tomu 10 otázek na lokomotivy vybraných řad. Odpovídá se A/B/C, vyhodnocení je opět až na konci a i tady je hranice 80 %. Na konci je verdikt **ZOZ splněna / nesplněna** a rozpis chyb se správnými odpověďmi. Rozdělaná simulace přežije zavření aplikace a časovač běží dál podle skutečného času.
- **Statistiky** mají přepínač **Předpisy / Lokomotivy**, výchozí jsou Předpisy. Simulace ZOZ se zapisují do historie předpisů.
- **Rozbor chyb** po každém testu i simulaci: nahoře souhrn, pod ním jen chybné odpovědi a tlačítko **Projít chyby postupně**. Každá chyba se ukáže jako karta se všemi třemi možnostmi (tvoje odpověď červeně, správná zeleně), zdrojem a plným zněním článku. Správně zodpovězené otázky jsou sbalené dole. Tlačítko „Zopakovat chybné v testu“ zůstává.
- **Běžný test** už ve výchozím stavu neukazuje správnou odpověď hned. Vyhodnocení je až na konci, a kdo chce, zapne si okamžitou odpověď zaškrtávátkem.

---

## ⬆ Aktualizace – Lokomotivy a Krizový postup

Tři kroky, v tomhle pořadí:

1. **SQL editor → New query → celý `cast5_lokomotivy.sql` → Run.** Přidá k otázkám sloupce `kategorie` a `rada` a novou tabulku `postupy`.
2. **Nahraj `index.html` a `sw.js`** z nového `na_web.zip` (`config.js` zůstává).
3. **Admin → Obsah otázek → vyber `zoz_loko.json` → Nahrát do databáze.** 606 otázek k lokomotivám + 146 krizových postupů. Otázky z předpisů to nepřepíše. `zoz_loko.json` stejně jako `zoz_questions.json` **nenahrávej na web**.

> **Když u řad svítí „0 otázek“** a v Předpisech je víc než 275 otázek: otázky k lokomotivám se nahrály bez označení řady (nahrávalo se ve starší verzi aplikace, nebo před `cast5_lokomotivy.sql`). Oprava: spusť `cast5_lokomotivy.sql`, nahraj nový `index.html` + `sw.js`, pak v Admin → Obsah otázek nahraj `zoz_loko.json` **znovu**. Admin na tuhle situaci sám upozorní červeným rámečkem.

Ověření: Admin → Obsah otázek musí ukázat „… 606 k lokomotivám, 146 krizových postupů“ a v Admin → Verze aplikace mezi opravami `lokomotivy · krizovy-postup`.

### Co je nového

Aplikace má teď tři samostatné sekce vedle sebe:

- **Předpisy** – původní otázky, vlastní Kartičky a Test (přepínač nahoře pod nadpisem).
- **Lokomotivy** – řady se vybírají přímo v hlavičce (pamatuje se), vlastní Kartičky a Test jen z vybraných řad.
- **Krizové postupy** – vlastní záložka: řada → „Jakou máš poruchu?“ → checklist.

Každá sekce si drží rozpracovaný test i kartičky zvlášť – odskočíš do Lokomotiv a po návratu do Předpisů test pokračuje tam, kde jsi byl. Statistiky mají předpisy a lokomotivy v oddělených blocích, Přehled (admin) má filtr „Jen předpisy / Jen lokomotivy“.

- **Krizový postup – zatím jen pro tebe (admina).** Běžní uživatelé tlačítko nevidí a databáze jim postupy ani nevydá (hlídá to pravidlo v `cast5_lokomotivy.sql`, ne jen aplikace). V záložce Lokomotivy ti pod tlačítky svítí, jestli je to „jen ty“, nebo „všichni“. **Až budeš spokojený, spusť `zverejnit_krizove_postupy.sql`** – postupy se objeví všem, aplikaci měnit nemusíš. Návrat zpět je v komentáři téhož souboru.
  > Pokud jsi `cast5_lokomotivy.sql` spustil už dřív (verzi bez omezení), spusť ho znovu – přepíše pravidlo na „jen admin“.
- **Krizový postup** – jak funguje (červené tlačítko v záložce Lokomotivy): řada → „Jakou máš poruchu?“ (seznam + hledání) → checklist. Úkony se odklikávají, aktuální krok je zvýrazněný, u „Pořadí úkonů je závazné“ nejde přeskočit dopředu. Rozhodnutí (Ano/Ne) přeskočí na správný bod nebo otevřou navazující postup s tlačítkem zpět. Rozpracovaný postup přežije i zavření aplikace.
- **Statistiky** mají sekci Lokomotivy po řadách; doporučení „Na co se zaměřit“ umí i lokomotivní oblasti (např. „Vectron · Poruchy“).

---

## ⬆ Aktualizace – oprava statistik

Ve statistikách se odpovědi násobily. Oprava je hotová. Pořadí je důležité:

**1. SQL editor → New query → celý obsah `oprava_statistik_2.sql` → Run.**

Nahoře ti to hned vypíše, **která verze aplikace zapisuje**:

| sloupec | co znamená |
|---|---|
| `zapsala_stara_verze` | odpovědi bez identifikátoru – pochází ze staré verze |
| `zapsala_nova_verze` | odpovědi z opravené verze |
| `ma_rozpad_moznosti` | odpovědi, u kterých se ví, na co se kliklo |

Když po nahrání nové verze a jednom testu `zapsala_nova_verze` pořád roste jen `zapsala_stara_verze`, v prohlížeči běží stará verze — viz níž.

Skript navíc přidá **pojistku přímo do databáze**: i kdyby někde stará verze zůstala, druhou kopii téže odpovědi databáze tiše zahodí. Na konci je (zakomentované) vynulování statistik — doporučuju ho použít, stará data jsou nafouknutá a nemají zaznamenané možnosti.

**2. Nahrát nový `index.html` a `sw.js`** — obojí je v novém `na_web.zip`. **Oba, ne jen HTML.**

Od téhle verze se do nich **nic nevyplňuje**. Adresa databáze a klíč se přestěhovaly do vlastního souboru `config.js`, který leží na webu vedle nich a aktualizace se ho nedotkne. Poprvé ho vyrobíš podle bodu 5 níž, pak už jen přepisuješ `index.html` a `sw.js`.

**3. Ověřit v aplikaci: Admin → Verze aplikace.** Je tam datum a čas sestavení a řádek „Obsahuje opravy". Když tahle sekce vůbec není vidět, běží stará verze.

### Když aplikace drží starou verzi

Prohlížeč (a hlavně nainstalovaná aplikace v telefonu) si stránku ukládá, aby fungovala bez signálu. Po nahrání nové verze proto:

- **Admin → Verze aplikace → Vynutit aktualizaci** — vyhodí celou uloženou kopii a načte web znovu. Tohle je ta spolehlivá cesta.
- Nebo ručně: Ctrl+F5 na počítači; v telefonu aplikaci zavřít a znovu otevřít.
- Od téhle verze se nová verze hlásí sama — aplikace si ji každou hodinu zkontroluje a sama se přepne.

---

**Hotovo:** nový projekt v Supabase · SQL schéma · vypnuté potvrzovací e-maily.

**Zbývá:** HTTPS → Site URL → klíče do souboru → doplnit SQL (hlášení) → nahrát na web → admin → nahrát otázky.

## Co kam patří

**Nejrychlejší cesta:** `na_web.zip` – je v něm rovnou všech osm souborů pro web, HTML už pojmenované `index.html`. Rozbal, v `index.html` vyplň klíče (bod 5) a celý obsah nahraj na FTP.

| Soubor | K čemu | Kam |
|---|---|---|
| `na_web.zip` | Balík všeho pro web pohromadě | rozbalit a nahrát celé |
| `ZOZ_trenazer_web.html` | Aplikace (**žádné otázky ani klíče uvnitř**) | na web jako `index.html` (v zipu už je) |
| `config.vzor.js` | Vzor nastavení – adresa databáze a klíč | přejmenovat na `config.js`, vyplnit, nahrát **jednou** |
| `.htaccess` | Zákaz staré cache (hosting Apache) | na web, vedle `index.html` |
| `manifest.webmanifest` | Aby šla nainstalovat do telefonu | na web, vedle `index.html` |
| `sw.js` | Aby běžela i bez signálu | na web, vedle `index.html` |
| `icon-192.png`, `icon-512.png`, `icon-512-maskable.png`, `apple-touch-icon.png`, `favicon.png` | Ikony aplikace | na web, vedle `index.html` |
| `cast3_hlaseni.sql` | Tabulka pro „Nahlásit chybu" | jednou v SQL editoru |
| `cast5_lokomotivy.sql` | Lokomotivy + krizové postupy (postupy zatím jen admin) | jednou v SQL editoru |
| `zverejnit_krizove_postupy.sql` | Zveřejní krizové postupy všem | až budeš chtít |
| `zoz_loko.json` | 878 otázek k lokomotivám + 230 postupů | **na web nenahrávat!** nahraješ z admin sekce |
| `cast6_rady_ucet.sql` | Výběr řad uložený k účtu | jednou v SQL editoru |
| `oprava_statistik_2.sql` | Oprava zdvojených odpovědí + pojistka v databázi + rozpad možností | jednou v SQL editoru |
| `oprava_admin.sql` | Oprava pojistky + nastavení admina | jednou v SQL editoru |
| `zoz_questions.json` | 275 otázek + 128 obrázků (2,4 MB) | **na web nenahrávat!** necháš u sebe, nahraješ z admin sekce |
| `zoz_supabase.sql` | Celé schéma pohromadě – už jsi spustil část 1 a 2 | – |

Všech **devět** souborů (HTML + manifest + sw.js + pět ikon + favicon) musí ležet ve **stejné složce** v kořeni webu. Kdyby ikony chyběly, aplikace pojede, ale nepůjde nainstalovat do telefonu.

---

## ⚠ Nejdřív HTTPS

Na `http://` se přihlašovací heslo posílá nešifrovaně, prohlížeč stránku označí jako nezabezpečenou **a instalace do telefonu vůbec nebude nabídnuta** – bez HTTPS se aplikace jako aplikace chovat neumí. U většiny hostingů se certifikát (Let's Encrypt) zapíná jedním přepínačem v administraci a je zdarma – zapni ho a zapni i přesměrování z `http` na `https`.

Dál v návodu proto všude počítám s **`https://zozstroj.eu`**.

---

## 3. Site URL

**Authentication → URL Configuration**

- **Site URL**: `https://zozstroj.eu`
- **Redirect URLs**: přidej `https://zozstroj.eu/**`

(Bez tohoto by nefungovaly odkazy v e-mailech – teď je sice nepoužíváš, ale až zapneš obnovu hesla nebo potvrzování, bude to potřeba.)

## 4. Doplnit SQL pro hlášení chyb

**SQL Editor → New query** → vlož celý obsah souboru **`cast3_hlaseni.sql`** → **Run**.

Přidá tabulku `reports` (kdo, u které otázky, co hlásí) a funkce pro adminský seznam. Bez toho by tlačítko „Nahlásit chybu" v testu skončilo chybou.

> Pokud bys někdy zakládal projekt úplně znovu, stačí spustit `zoz_supabase.sql` – tohle už je v něm.

## 5. Klíče do aplikace (jen jednou)

Potřebuješ dvě hodnoty. V Supabase klikni vlevo dole na **ozubené kolo (Project Settings)**.

**a) Project URL** — *Project Settings → **Data API*** → nahoře sekce **Project URL**:

```
https://xxxxxxxxxxxxxxxx.supabase.co
```

**b) Klíč** — *Project Settings → **API Keys*** → klíč označený **`publishable`** (začíná `sb_publishable_…`). Klikni na kopírování.

> Supabase klíče nedávno přejmenoval: **`publishable`** je to, čemu se dřív říkalo `anon / public` — patří do kódu stránky a sám o sobě nic neodemkne, data chrání RLS pravidla ze SQL.
> **`secret`** (dřív `service_role`) **obchází všechna pravidla** a umí číst i měnit cizí data. Nikdy ho nedávej do souboru, do prohlížeče ani nikomu neposílej.

Zkratka: zelené tlačítko **Connect** nahoře v projektu → záložka **App Frameworks** → obě hodnoty jsou tam vedle sebe připravené ke zkopírování.

**Vlož je do `config.js`.** V zipu je soubor **`config.vzor.js`** — přejmenuj ho na **`config.js`**, otevři v textovém editoru a vyplň:

```js
window.ZOZ_CONFIG = {
  SUPABASE_URL: "https://abcdefghijklmnop.supabase.co",
  SUPABASE_KEY: "sb_publishable_AbCdEf123..."
};
```

Ulož a nahraj na web vedle `index.html`.

**Tohle se dělá jednou.** `config.js` není v žádném dalším balíčku, takže když příště rozbalíš nový `na_web.zip` a nahraješ ho, tvoje nastavení zůstane netknuté. Kdyby přesto někdy zmizelo, aplikace to rovnou napíše na přihlašovací obrazovce a v **Admin → Verze aplikace** je řádek **Nastavení připojení**.

## 6. Nahrát na web

Nahraj **celý obsah `na_web.zip`** (tedy `index.html`, manifest, `sw.js` a všechny ikony) plus svůj **`config.js`** do kořenového adresáře webu (přes FTP většinou `www/`, `public_html/` nebo `htdocs/`).

Pak otevři `https://zozstroj.eu` – měla by se objevit přihlašovací obrazovka. Pokud se místo ní ukáže červená hláška o chybějícím připojení, špatně se vyplnil `CONFIG` v bodě 5.

## 7. Udělej ze sebe admina

1. Na `https://zozstroj.eu` klikni **Registrovat** a založ si účet svým e-mailem (potvrzovací e-mail nechodí, máš to vypnuté – účet je rovnou aktivní).
2. V Supabase **SQL Editor → New query** vlož celý obsah souboru **`oprava_admin.sql`**, na řádku s `UPDATE` uprav e-mail na svůj a dej **Run**.
3. Dole se vypíše tabulka profilů – u tvého e-mailu musí být `is_admin = true`. Když je tam `false` nebo tvůj e-mail chybí, zkontroluj, jestli sedí přesně (velká/malá písmena nevadí, překlep ano).
4. V aplikaci se **odhlas a přihlas znovu**. Objeví se záložky **Přehled** a **Admin**.

> Proč zvláštní soubor: v původním schématu byla pojistka proti tomu, aby si uživatel sám nastavil `is_admin`, napsaná moc přísně – blokovala i SQL editor, takže update proběhl „úspěšně", ale nic nezměnil. `oprava_admin.sql` pojistku opraví (na přihlášené uživatele platí dál) a rovnou nastaví admina.

## 8. Nahrát otázky

**Admin → Obsah otázek** → vyber `zoz_questions.json` ze svého disku → **Nahrát do databáze**.

Trvá to zhruba minutu (nahrává se po dávkách, ukazuje se průběh). Po dokončení se obsah rovnou načte a v podtitulku nahoře uvidíš „275 otázek".

**Hotovo.** Od téhle chvíle to funguje každému, kdo se zaregistruje.

---

## Co která část umí

**Běžný uživatel vidí čtyři záložky:**

- **Kartičky** – otázka, otočení na odpověď, „věděl / nevěděl". Filtry podle tématu a předpisu, režim „jen chybované".
- **Test** – 10 / 20 / 30 / 50 / všechny otázky, volitelný časový limit, filtr na téma nebo předpis, možnosti A/B/C. Po testu rozpis chyb se správnou odpovědí a odkazem na článek předpisu.
- **Statistiky** – dlaždice, **„Na co se zaměřit"**, úspěšnost po tématech a předpisech, nejhorší otázky (rozkliknou se i s odpovědí) a historie testů.
- **Podpořit** – návod na instalaci do telefonu + prosba o příspěvek s tlačítkem na tvůj Revolut odkaz.

**„Na co se zaměřit"**: jakmile má člověk v nějakém tématu nebo předpisu aspoň 5 odpovědí a úspěšnost pod 75 %, objeví se mu

> **31 %** — Téma **GSM-R a rádio** — 4 z 13 správně.
> *Zaměř se na SŽ Z11 a Provozní řád GSM-R.*
> [Trénovat testem] [Kartičky]

Tlačítka rovnou spustí test nebo kartičky filtrované na tu oblast.

**Ty navíc:**

- **Přehled** – prohlížení a hledání ve všech otázkách i s distraktory a poznámkami.
- **Admin** – **Hlášení od uživatelů** (nová nahoře, dají se odbavit); stav obsahu a nahrání nové verze; počet účtů, noví a aktivní za 7 dní, počet testů a odpovědí, průměrná úspěšnost; tabulka všech uživatelů (e-mail, registrace, poslední aktivita, odpovědi, úspěšnost); graf aktivity za 60 dní; **nejhůř zodpovídané otázky napříč všemi** (rozkliknou se – uvnitř je celá otázka, obrázek, správná odpověď a **rozpad, kolikrát se klikalo na kterou ze tří možností**) a úspěšnost po oblastech.

## Instalace do telefonu

Když někdo otevře `https://zozstroj.eu` v mobilu, na záložce **Podpořit** (a hned po prvním přihlášení) uvidí návod podle svého telefonu:

- **Android / Chrome** – vyskočí tlačítko **Nainstalovat aplikaci**, jedno kliknutí a ikona je na ploše.
- **iPhone / Safari** – Android tlačítko nemá, takže se ukáže postup: tlačítko **Sdílet** → **Přidat na plochu**.
- Kdo už to nainstalované má, vidí jen potvrzení.

Po instalaci se to chová jako appka: vlastní ikona, žádný adresní řádek, a **spustí se i bez signálu** – otázky jsou uložené v telefonu, odpovědi se schovají a odešlou, až je signál zpátky.

## Hlášení chyb

Tlačítko **⚑ Nahlásit chybu** je **přímo v testu** (u každé otázky i v rozpisu chyb po testu) a taky na kartičkách. Člověk vybere, o co jde – špatná správná odpověď / špatná otázka nebo obrázek / špatný odkaz na předpis / jiné – může připsat pár slov a odeslat. Otázka se k hlášení připojí automaticky, nemusí opisovat čísla.

Tobě to naskočí v **Admin → Hlášení**: kdo, kdy, která otázka, co píše. Každé se dá označit jako **vyřešeno** nebo **zamítnuto**, ať víš, co jsi už probral. Počet nových se ukazuje i v souhrnu nahoře.

## Rozpad tří možností

U každé otázky se teď zaznamenává nejen jestli byla odpověď správně, ale **která ze tří možností se klikla**. V adminu i ve vlastních statistikách se to ukáže po rozkliknutí otázky jako tři pruhy:

> ✓ Rychlostí nejvýše 40 km/h — ▓░░░░ 15 % — 3×
> ✗ Rychlostí nejvýše 30 km/h — ▓▓▓▓░ 70 % — 14×
> ✗ Traťovou rychlostí — ▓░░░░ 15 % — 3×

Když jeden distraktor takhle vyčnívá, něco to znamená: buď je formulace otázky zavádějící, nebo je to přesně to místo, kde se v předpisu chybuje. Obojí je užitečné vědět.

Poznámka: možnosti se v testu míchají, takže se neukládá „A/B/C", ale **která odpověď to byla** – správná, první nesprávná, druhá nesprávná. Pořadí odpovídá tomu, jak jsou vypsané v Přehledu.

## Obnovení čísel

Nahoře na **Statistikách** i v **Adminu** je tlačítko **↻ Načíst znovu** a vedle něj čas posledního načtení. V nainstalované aplikaci není adresní řádek, takže jinak by se čísla nedala přenačíst jinak než zavřením a otevřením aplikace.

Rozdíl proti tlačítku **Vynutit aktualizaci** (Admin → Verze aplikace): „Načíst znovu" jen stáhne aktuální čísla, „Vynutit aktualizaci" zahodí celou uloženou kopii aplikace a natáhne novou verzi z webu.

## Dobré vědět

- **Obsah se po prvním načtení uloží v prohlížeči** (IndexedDB), další spuštění je okamžité. Když nahraješ novou verzi otázek, změní se verze obsahu a všem se stáhne nová sama.
- **Pokrok se ukládá průběžně.** Při výpadku spojení se odpovědi schovají v prohlížeči a odešlou se, až je spojení zpátky (tečka vedle jména: zelená = synchronizováno, oranžová = čeká).
- **Aktualizace otázek**: dám ti nový `zoz_questions.json`, nahraješ ho v Admin → Obsah otázek. HTML na hostingu měnit nemusíš a statistiky se nesmažou.
- **Aktualizace samotné aplikace**: až ti pošlu nové `index.html`, nahraj s ním i nový `sw.js`. Do klíčů se nesahá – ty jsou v `config.js`, který v balíčku není a nepřepíše se. Uvnitř `sw.js` je řádek `const VERSION = 'zoz-v1';` – při každé nové verzi tam zvýším číslo, jinak by lidem s nainstalovanou aplikací zůstala viset ta stará z paměti telefonu.
- **Zapomenuté heslo** zatím v aplikaci není. Až ho budeš chtít, musí se zapnout odesílání e-mailů – napojíme na to Resend (**Authentication → Emails → SMTP**) a doplním do aplikace odkaz „Zapomněl jsem heslo".
- **Smazání účtu**: Supabase → **Authentication → Users** → smazat uživatele; jeho odpovědi i testy zmizí s ním.
- **Kolik to unese**: free tarif Supabase má 500 MB databáze a 5 GB přenosu měsíčně. Obsah zabere ~3 MB, jeden uživatel ročně pár set kB. Přenos vystačí zhruba na 2 000 prvních načtení; opakované návštěvy jedou z cache a nestojí skoro nic.
