# ZOZ Trenažér – nasazení na zozstroj.eu

**Hotovo:** nový projekt v Supabase · SQL schéma · vypnuté potvrzovací e-maily.

**Zbývá:** HTTPS → Site URL → klíče do souboru → doplnit SQL (hlášení) → nahrát na web → admin → nahrát otázky.

## Co kam patří

**Nejrychlejší cesta:** `na_web.zip` – je v něm rovnou všech osm souborů pro web, HTML už pojmenované `index.html`. Rozbal, v `index.html` vyplň klíče (bod 5) a celý obsah nahraj na FTP.

| Soubor | K čemu | Kam |
|---|---|---|
| `na_web.zip` | Balík všeho pro web pohromadě | rozbalit a nahrát celé |
| `ZOZ_trenazer_web.html` | Aplikace (70 kB, **žádné otázky uvnitř**) | na web jako `index.html` (v zipu už je) |
| `manifest.webmanifest` | Aby šla nainstalovat do telefonu | na web, vedle `index.html` |
| `sw.js` | Aby běžela i bez signálu | na web, vedle `index.html` |
| `icon-192.png`, `icon-512.png`, `icon-512-maskable.png`, `apple-touch-icon.png`, `favicon.png` | Ikony aplikace | na web, vedle `index.html` |
| `cast3_hlaseni.sql` | Tabulka pro „Nahlásit chybu" | jednou v SQL editoru |
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

## 5. Klíče do aplikace

Potřebuješ dvě hodnoty. V Supabase klikni vlevo dole na **ozubené kolo (Project Settings)**.

**a) Project URL** — *Project Settings → **Data API*** → nahoře sekce **Project URL**:

```
https://xxxxxxxxxxxxxxxx.supabase.co
```

**b) Klíč** — *Project Settings → **API Keys*** → klíč označený **`publishable`** (začíná `sb_publishable_…`). Klikni na kopírování.

> Supabase klíče nedávno přejmenoval: **`publishable`** je to, čemu se dřív říkalo `anon / public` — patří do kódu stránky a sám o sobě nic neodemkne, data chrání RLS pravidla ze SQL.
> **`secret`** (dřív `service_role`) **obchází všechna pravidla** a umí číst i měnit cizí data. Nikdy ho nedávej do souboru, do prohlížeče ani nikomu neposílej.

Zkratka: zelené tlačítko **Connect** nahoře v projektu → záložka **App Frameworks** → obě hodnoty jsou tam vedle sebe připravené ke zkopírování.

**Vlož je do souboru.** Otevři `index.html` (nebo `ZOZ_trenazer_web.html`, podle toho, co máš) v textovém editoru (Poznámkový blok, VS Code), hned na začátku skriptu je:

```js
const CONFIG = {
  SUPABASE_URL: "__SUPABASE_URL__",
  SUPABASE_KEY: "__SUPABASE_ANON_KEY__",
  PODPORA_URL:  "https://checkout.revolut.com/pay/daf4dcd2-e66a-460b-8fe0-0c2fb23d9bef"
};
```

Nahraď první dvě hodnoty, uvozovky nech (třetí je tvůj platební odkaz, ten je vyplněný):

```js
const CONFIG = {
  SUPABASE_URL: "https://abcdefghijklmnop.supabase.co",
  SUPABASE_KEY: "sb_publishable_AbCdEf123...",
  PODPORA_URL:  "https://checkout.revolut.com/pay/daf4dcd2-e66a-460b-8fe0-0c2fb23d9bef"
};
```

Ulož.

## 6. Nahrát na web

Nahraj **celý obsah `na_web.zip`** (tedy `index.html`, manifest, `sw.js` a všechny ikony) do kořenového adresáře webu (přes FTP většinou `www/`, `public_html/` nebo `htdocs/`).

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
- **Admin** – **Hlášení od uživatelů** (nová nahoře, dají se odbavit); stav obsahu a nahrání nové verze; počet účtů, noví a aktivní za 7 dní, počet testů a odpovědí, průměrná úspěšnost; tabulka všech uživatelů (e-mail, registrace, poslední aktivita, odpovědi, úspěšnost); graf aktivity za 60 dní; **nejhůř zodpovídané otázky napříč všemi** a úspěšnost po oblastech.

## Instalace do telefonu

Když někdo otevře `https://zozstroj.eu` v mobilu, na záložce **Podpořit** (a hned po prvním přihlášení) uvidí návod podle svého telefonu:

- **Android / Chrome** – vyskočí tlačítko **Nainstalovat aplikaci**, jedno kliknutí a ikona je na ploše.
- **iPhone / Safari** – Android tlačítko nemá, takže se ukáže postup: tlačítko **Sdílet** → **Přidat na plochu**.
- Kdo už to nainstalované má, vidí jen potvrzení.

Po instalaci se to chová jako appka: vlastní ikona, žádný adresní řádek, a **spustí se i bez signálu** – otázky jsou uložené v telefonu, odpovědi se schovají a odešlou, až je signál zpátky.

## Hlášení chyb

Tlačítko **⚑ Nahlásit chybu** je **přímo v testu** (u každé otázky i v rozpisu chyb po testu) a taky na kartičkách. Člověk vybere, o co jde – špatná správná odpověď / špatná otázka nebo obrázek / špatný odkaz na předpis / jiné – může připsat pár slov a odeslat. Otázka se k hlášení připojí automaticky, nemusí opisovat čísla.

Tobě to naskočí v **Admin → Hlášení**: kdo, kdy, která otázka, co píše. Každé se dá označit jako **vyřešeno** nebo **zamítnuto**, ať víš, co jsi už probral. Počet nových se ukazuje i v souhrnu nahoře.

## Dobré vědět

- **Obsah se po prvním načtení uloží v prohlížeči** (IndexedDB), další spuštění je okamžité. Když nahraješ novou verzi otázek, změní se verze obsahu a všem se stáhne nová sama.
- **Pokrok se ukládá průběžně.** Při výpadku spojení se odpovědi schovají v prohlížeči a odešlou se, až je spojení zpátky (tečka vedle jména: zelená = synchronizováno, oranžová = čeká).
- **Aktualizace otázek**: dám ti nový `zoz_questions.json`, nahraješ ho v Admin → Obsah otázek. HTML na hostingu měnit nemusíš a statistiky se nesmažou.
- **Aktualizace samotné aplikace**: až ti pošlu nové `index.html`, nahraj s ním i nový `sw.js`. Uvnitř `sw.js` je řádek `const VERSION = 'zoz-v1';` – při každé nové verzi tam zvýším číslo, jinak by lidem s nainstalovanou aplikací zůstala viset ta stará z paměti telefonu.
- **Zapomenuté heslo** zatím v aplikaci není. Až ho budeš chtít, musí se zapnout odesílání e-mailů – napojíme na to Resend (**Authentication → Emails → SMTP**) a doplním do aplikace odkaz „Zapomněl jsem heslo".
- **Smazání účtu**: Supabase → **Authentication → Users** → smazat uživatele; jeho odpovědi i testy zmizí s ním.
- **Kolik to unese**: free tarif Supabase má 500 MB databáze a 5 GB přenosu měsíčně. Obsah zabere ~3 MB, jeden uživatel ročně pár set kB. Přenos vystačí zhruba na 2 000 prvních načtení; opakované návštěvy jedou z cache a nestojí skoro nic.
