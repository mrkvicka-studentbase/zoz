-- =====================================================================
--  ZOZ trenažér – část 7: Směnář → kalendář
--  Spusť v Supabase → SQL Editor v projektu ZOZ trenažéru (ne StudentBase!).
--  Dá se spustit opakovaně.
-- =====================================================================

-- pojistka: jen v databázi ZOZ trenažéru
do $$ begin
  if to_regclass('public.app_meta') is null or to_regclass('public.profiles') is null then
    raise exception 'Tohle není databáze ZOZ trenažéru (chybí app_meta/profiles). Přepni projekt vlevo nahoře.';
  end if;
end $$;

-- 1) záznam o každém čtení směnáře (kvůli limitu a přehledu nákladů). Fotky se NEUKLÁDAJÍ.
create table if not exists public.smenar_pouziti (
  id            bigserial primary key,
  user_id       uuid not null references auth.users(id) on delete cascade,
  created_at    timestamptz not null default now(),
  ok            boolean not null default false,
  model         text,
  input_tokens  int,
  output_tokens int,
  chyba         text
);
create index if not exists smenar_pouziti_user_idx on public.smenar_pouziti(user_id, created_at);

alter table public.smenar_pouziti enable row level security;
drop policy if exists smenar_pouziti_select on public.smenar_pouziti;
create policy smenar_pouziti_select on public.smenar_pouziti
  for select using (user_id = auth.uid() or public.is_admin());
-- zápis dělá jen serverová funkce (service role), uživatel sám zapisovat nemůže

-- 2) nastavení: limit čtení za kalendářní měsíc a zveřejnění záložky
insert into public.app_meta(key, value) values ('smenar_limit', '2') on conflict (key) do nothing;
insert into public.app_meta(key, value) values ('smenar_verejne', 'false') on conflict (key) do nothing;

-- 3) kolik čtení mi tento měsíc zbývá
create or replace function public.smenar_stav()
returns json language sql stable security definer set search_path = public as $$
  select json_build_object(
    'pouzito', (select count(*) from smenar_pouziti
                where user_id = auth.uid() and created_at >= date_trunc('month', now() at time zone 'Europe/Prague') at time zone 'Europe/Prague'),
    'limit',   coalesce((select value::int from app_meta where key = 'smenar_limit'), 2),
    'admin',   public.is_admin()
  );
$$;
grant execute on function public.smenar_stav() to authenticated;

-- 4) přehled pro admina: použití a tokeny po měsících
create or replace function public.admin_smenar_prehled()
returns json language plpgsql stable security definer set search_path = public as $$
begin
  if not public.is_admin() then raise exception 'jen pro admina'; end if;
  return (select coalesce(json_agg(r order by r.mesic desc), '[]'::json) from (
    select to_char(date_trunc('month', created_at at time zone 'Europe/Prague'), 'YYYY-MM') as mesic,
           count(*) as cteni, count(*) filter (where ok) as uspesnych,
           count(distinct user_id) as uzivatelu,
           coalesce(sum(input_tokens),0) as input_tokens, coalesce(sum(output_tokens),0) as output_tokens
    from smenar_pouziti group by 1) r);
end $$;
grant execute on function public.admin_smenar_prehled() to authenticated;

-- ZVEŘEJNĚNÍ pro všechny uživatele (až budeš spokojený s testem), spusť zvlášť:
--   update public.app_meta set value = 'true' where key = 'smenar_verejne';
-- ZMĚNA LIMITU (např. na 3 za měsíc):
--   update public.app_meta set value = '3' where key = 'smenar_limit';
