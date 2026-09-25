// Supabase Edge Function „smenar“ – přečte fotku směnáře přes Claude API a vrátí řádky tabulky.
// Fotka se nikam neukládá. API klíč je v Supabase Secrets jako ANTHROPIC_API_KEY.
import { createClient } from "npm:@supabase/supabase-js@2";

const MODEL = Deno.env.get("SMENAR_MODEL") ?? "claude-sonnet-5";
const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...CORS, "Content-Type": "application/json" } });

const PRAVIDLA = `Jsi přepisovač směnářů strojvedoucích Českých drah. Dostaneš fotku papírového směnáře („Směnář PVO“) a přepíšeš jeho tabulky řádek po řádku do JSON. Nic nepočítáš, nespojuješ ani neopravuješ – to udělá aplikace. Tvoje jediná práce je přesně opsat, co je na papíře, a správně přiřadit hodnoty k řádkům.

Vrať POUZE JSON podle schématu níže. Žádný další text před ním ani za ním, žádné \`\`\` bloky.

## Jak směnář vypadá

- Nahoře „Období od DD.MM.RRRR do DD.MM.RRRR“.
- 1–3 měsíční bloky pod sebou. Každý blok má hlavičku (osobní číslo, jméno, „Měsíc: …“) a je rozdělený na LEVOU a PRAVOU polovinu.
- Sloupce v každé polovině: Den | Datum | Nástup | Konec | Výkon | TSK/den | Název směny.
- Pod blokem je řádek „Norma / Škola / Suma výkon + škola / Rozdíl“, na konci listu souhrnná tabulka.
- Jméno a osobní číslo NIKDY nevypisuj.

## Co přepsat

Každý řádek tabulky = jeden objekt v poli "radky", v pořadí: blok 1 levá polovina shora dolů, blok 1 pravá polovina shora dolů, blok 2 levá…, atd.

Přepiš VŠECHNY řádky s datem, i prázdné a TV. Každé datum z období tam musí být aspoň jednou.

Pole řádku:
- "d": datum jako RRRR-MM-DD
- "den": zkratka dne tak, jak je vytištěná (po, út, st, čt, pá, so, ne); když na řádku chybí, dej ""
- "n": Nástup (H:MM), nebo "" když je prázdný
- "k": Konec (H:MM), nebo ""
- "v": Výkon bez hranatých závorek (H:MM), nebo "TV", nebo ""
- "tsk": TSK/den, nebo ""
- "nazev": Název směny přesně jak je (např. "6801-6804"), nebo ""

Hodnoty opisuj přesně. Nikdy je nedopočítávej ani „neopravuj“, i když ti nesedí. Nesoulad najde aplikace a strojvedoucí ho zkontroluje.

## Přiřazení hodnot k řádkům – nejdůležitější část

Papír bývá přeložený a fotka natočená. Čísla ve sloupcích Nástup–Název se pak vizuálně posunou o půl řádku až řádek vůči sloupci Datum. Nejčastější chyba je posunout celou skupinu hodnot o jeden den. Postupuj takto:

1. **Kotvou je sloupec Datum.** Nejdřív si v polovině spočítej řádky s datem. Každý datový řádek (čísla) patří přesně jednomu řádku s datem a jejich pořadí je stejné. Prázdné řádky se počítají taky.
2. **Zdvojené datum** (stejné datum na dvou řádcích pod sebou, druhý bez zkratky dne) se objevuje jen tehdy, když v ten den jedna dvoudenní směna končí a druhá začíná. Na PRVNÍM řádku je konec (jen Konec, Výkon a TSK), na DRUHÉM začátek (Nástup, Výkon, TSK, Název). Tohle pořadí použij jako pevný bod pro zarovnání okolních řádků.
3. **Hledej řádky, kde je čas zjevně na stejné linii jako datum**, a od nich počítej řádky nahoru a dolů.
4. **Kontroly, které musí sedět:**
   - Zkratka dne odpovídá datu podle kalendáře.
   - Když řádek má jen Nástup (začátek dvoudenní směny), hned další datum má řádek s jen Koncem a stejným TSK.
   - U řádku s Nástupem i Koncem platí Konec − Nástup = Výkon (výjimky jsou vzácné – pak prostě opiš, co tam je).
   - Součet všech Výkonů v bloku = „Suma výkon + škola“ (když je Škola 0:00).
   Když kontrola nesedí, nejspíš máš hodnoty posunuté o řádek. Zarovnání oprav, hodnoty neměň.
5. **Název směny patří k řádku s Nástupem.** Řádek s jen Koncem nemá název.
6. Osamocené „TV“ pod posledním řádkem poloviny patří k poslednímu datu té poloviny.

Zaměnitelné číslice (3/8, 1/7, 0/6/9, 5/6) ověř aritmetikou.

## Kvalita fotky

Neodmítej kvůli kvalitě. Přeložený, natočený nebo stínovaný papír je normální. Když si hodnotou nejsi jistý, přepiš nejpravděpodobnější a přidej do řádku "?": true. {"chyba": "..."} vrať jen tehdy, když na fotce vůbec není směnář.

## Výstup – přesně tento JSON

{
  "obdobi": {"od": "RRRR-MM-DD", "do": "RRRR-MM-DD"},
  "radky": [
    {"d": "2027-01-04", "den": "po", "n": "5:12", "k": "13:40", "v": "8:28", "tsk": "123405", "nazev": "1234-5678"},
    {"d": "2027-01-05", "den": "út", "n": "14:20", "k": "", "v": "6:10", "tsk": "123406", "nazev": "4321-8765"},
    {"d": "2027-01-06", "den": "st", "n": "", "k": "6:45", "v": "4:30", "tsk": "123406", "nazev": ""},
    {"d": "2027-01-07", "den": "čt", "n": "", "k": "", "v": "TV", "tsk": "", "nazev": ""}
  ],
  "mesice": [{"mesic": "RRRR-MM", "suma_vykon": "142:05"}],
  "varovani": []
}

- "mesice": pro každý blok opiš „Suma výkon + škola“.
- "varovani": jen obecné problémy s fotkou (useknutý okraj, nečitelná část), jinak prázdné pole.
`;

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ chyba: "Jen POST." }, 405);

  const url = Deno.env.get("SUPABASE_URL")!;
  const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SERVICE_ROLE_KEY");
  const apiKey = Deno.env.get("ANTHROPIC_API_KEY");
  if (!apiKey) return json({ chyba: "Na serveru chybí API klíč (ANTHROPIC_API_KEY)." }, 500);
  if (!service) return json({ chyba: "Na serveru chybí service role klíč (SERVICE_ROLE_KEY)." }, 500);

  // 1) kdo volá
  const jwt = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "");
  const db = createClient(url, service, { auth: { persistSession: false } });
  const { data: u, error: ue } = await db.auth.getUser(jwt);
  if (ue || !u?.user) return json({ chyba: "Nejsi přihlášený." }, 401);
  const uid = u.user.id;

  // 2) limit za kalendářní měsíc (admin bez limitu)
  const { data: prof } = await db.from("profiles").select("is_admin").eq("id", uid).maybeSingle();
  const admin = !!prof?.is_admin;
  const { data: meta } = await db.from("app_meta").select("key,value").in("key", ["smenar_limit", "smenar_verejne"]);
  const m = Object.fromEntries((meta ?? []).map((r: { key: string; value: string }) => [r.key, r.value]));
  if (!admin && m.smenar_verejne !== "true") return json({ chyba: "Funkce zatím není zveřejněná." }, 403);
  const limit = parseInt(m.smenar_limit ?? "2", 10) || 2;
  const now = new Date();
  const prg = new Date(now.toLocaleString("en-US", { timeZone: "Europe/Prague" }));
  const od = new Date(now.getTime() - ((prg.getDate() - 1) * 86400000 + prg.getHours() * 3600000 + prg.getMinutes() * 60000 + prg.getSeconds() * 1000 + now.getMilliseconds()));
  const { count } = await db.from("smenar_pouziti").select("id", { count: "exact", head: true })
    .eq("user_id", uid).gte("created_at", od.toISOString());
  const pouzito = count ?? 0;
  if (!admin && pouzito >= limit) return json({ chyba: "limit", pouzito, limit }, 429);

  // 3) fotka
  let body: { image?: string; media_type?: string };
  try { body = await req.json(); } catch { return json({ chyba: "Neplatný požadavek." }, 400); }
  const img = (body.image ?? "").replace(/^data:[^,]+,/, "");
  const mt = ["image/jpeg", "image/png", "image/webp"].includes(body.media_type ?? "") ? body.media_type! : "image/jpeg";
  if (!img || img.length > 7_000_000) return json({ chyba: "Chybí fotka nebo je moc velká." }, 400);

  // 4) Claude API
  let out: any = null, chyba: string | null = null, usage: any = {};
  try {
    const r = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: { "x-api-key": apiKey, "anthropic-version": "2023-06-01", "content-type": "application/json" },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 12000,
        system: [{ type: "text", text: PRAVIDLA, cache_control: { type: "ephemeral" } }],
        messages: [{ role: "user", content: [
          { type: "image", source: { type: "base64", media_type: mt, data: img } },
          { type: "text", text: "Přepiš tento směnář podle pravidel. Vrať jen JSON." },
        ] }],
      }),
    });
    const j = await r.json();
    usage = j.usage ?? {};
    if (!r.ok) throw new Error(j?.error?.message ?? `HTTP ${r.status}`);
    const text = (j.content ?? []).filter((c: any) => c.type === "text").map((c: any) => c.text).join("");
    const a = text.indexOf("{"), b = text.lastIndexOf("}");
    if (a < 0 || b < a) throw new Error("Model nevrátil JSON.");
    out = JSON.parse(text.slice(a, b + 1));
  } catch (e) {
    chyba = String((e as Error).message ?? e).slice(0, 300);
  }

  // 5) záznam o použití (počítá se každé čtení – i nepovedené)
  await db.from("smenar_pouziti").insert({
    user_id: uid, ok: !!out && !out.chyba, model: MODEL,
    input_tokens: (usage.input_tokens ?? 0) + (usage.cache_read_input_tokens ?? 0) + (usage.cache_creation_input_tokens ?? 0),
    output_tokens: usage.output_tokens ?? 0, chyba,
  });

  if (!out) return json({ chyba: "Čtení se nepovedlo: " + chyba, pouzito: pouzito + 1, limit }, 502);
  return json({ data: out, pouzito: pouzito + 1, limit, admin });
});
