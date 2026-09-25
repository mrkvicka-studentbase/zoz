/* =====================================================================
   ZOZ Trenažér – nastavení připojení k databázi

   TENHLE SOUBOR PŘEJMENUJ NA  config.js  a nahraj ho na web vedle
   index.html. Vyplňuje se JEN JEDNOU – další aktualizace aplikace
   (index.html, sw.js) se ho už nedotknou.

   SUPABASE_URL = Supabase → Project Settings → Data API → Project URL
   SUPABASE_KEY = Supabase → Project Settings → API Keys → klíč
                  označený "publishable" (začíná sb_publishable_…)

   Klíč "secret" / "service_role" sem NIKDY nedávej – obchází všechna
   bezpečnostní pravidla a byl by veřejně čitelný.
   ===================================================================== */
window.ZOZ_CONFIG = {
  SUPABASE_URL: "https://srzrkcsuxdnobhmtezhe.supabase.co",
  SUPABASE_KEY: "sb_publishable_Ovzr1fc5Sr8QhUjUmAnWnQ_wMtQrTWP",

  // Odkaz na platební stránku v záložce Podpořit.
  // Když ho tu necháš zakomentovaný, použije se ten původní.
  // PODPORA_URL: "https://checkout.revolut.com/pay/..."
};
