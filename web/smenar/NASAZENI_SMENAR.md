# Směnář do kalendáře – nasazení

Všechno je ve složce `předpisy\web\smenar`. Postup zabere asi 15 minut a dělá se jen jednou.

## 1. Databáze

Supabase → projekt **ZOZ trenažéru** (ne StudentBase) → **SQL Editor** → vlož celý obsah `cast7_smenar.sql` → **Run**.

Vytvoří se záznam čtení (kvůli limitu), limit 2 čtení měsíčně a přepínač zveřejnění. Záložku zatím uvidíš jen ty jako admin.

## 2. API klíč Anthropic

1. Otevři **console.anthropic.com** → **API Keys** → **Create Key**, pojmenuj ho `zozstroj-smenar` a zkopíruj ho. Ukáže se jen jednou.
2. Doporučuju: **Settings → Limits** a nastav měsíční strop útraty (např. 5 $). Víc pak nikdy neutratíš, ani kdyby se něco pokazilo.
3. Klíč nikam neposílej a nedávej ho do žádného souboru na webu.

## 3. Klíč do Supabase

Supabase → **Edge Functions** → **Secrets** (případně Project Settings → Edge Functions) → **Add new secret**:

- Name: `ANTHROPIC_API_KEY`
- Value: klíč z kroku 2

→ **Save**.

## 4. Serverová funkce

Supabase → **Edge Functions** → **Deploy a new function** → **Via Editor**:

1. Název funkce: přesně `smenar` (malými písmeny).
2. Smaž ukázkový kód a vlož celý obsah souboru `smenar_funkce\index.ts`.
3. **Deploy function**.

## 5. Web

Na hosting nahraj z `na_web.zip` soubory **`index.html`** a **`sw.js`** (verze zoz-v23).

## 6. Test

Přihlas se jako admin → záložka **Směnář** (na mobilu pod „Více“) → vyfoť směnář → **Přečíst směnář**.

Admin nemá limit. V záložce Admin → „Směnář do kalendáře“ uvidíš počet čtení a odhad ceny.

## 7. Zveřejnění pro všechny

Až budeš spokojený, spusť v SQL Editoru:

```sql
update public.app_meta set value = 'true' where key = 'smenar_verejne';
```

Změna limitu (např. na 3 za měsíc):

```sql
update public.app_meta set value = '3' where key = 'smenar_limit';
```

## Když něco nejde

| Hláška v aplikaci | Co s tím |
|---|---|
| „Na serveru chybí API klíč“ | Krok 3 – zkontroluj název `ANTHROPIC_API_KEY`. |
| „Na serveru chybí service role klíč“ | Supabase → Project Settings → API Keys → zkopíruj **service_role / secret** klíč a přidej ho v Secrets jako `SERVICE_ROLE_KEY`. Nikam jinam ho nedávej. |
| „Nejsi přihlášený“ nebo „Invalid JWT“ | Edge Functions → `smenar` → Details → vypni **Enforce JWT verification** a ulož. Funkce si přihlášení ověřuje sama. |
| „Funkce zatím není zveřejněná“ | Běžný uživatel před krokem 7 – správně. |
| „Čtení se nepovedlo: …“ | Pošli mi text hlášky. Nejčastěji je to vyčerpaný kredit nebo strop útraty v Anthropic Console. |
