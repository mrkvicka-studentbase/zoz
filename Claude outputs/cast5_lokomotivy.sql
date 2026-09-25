-- =====================================================================
--  ZOZ Trenažér – část 5: LOKOMOTIVY + KRIZOVÉ POSTUPY
--  Spustit jednou v SQL editoru (opakované spuštění nevadí).
--  Pak v aplikaci: Admin → Obsah otázek → nahrát zoz_loko.json.
-- =====================================================================

-- 1) otázky: rozlišení předpisy / lokomotivy + řada
alter table public.questions add column if not exists kategorie text not null default 'predpisy';
alter table public.questions add column if not exists rada      text;
create index if not exists questions_kat_idx on public.questions(kategorie, rada);

-- 2) krizové postupy (checklisty ze Závad v kostce)
create table if not exists public.postupy (
  id             text primary key,
  rada           text not null,
  nazev          text not null,
  podnadpis      text,
  kategorie      text,
  uvod           text,
  zavazne_poradi boolean not null default false,
  zdroj          jsonb default '{}'::jsonb,
  kroky          jsonb not null default '[]'::jsonb,
  updated_at     timestamptz not null default now()
);

alter table public.postupy enable row level security;

-- Krizové postupy zatím vidí JEN ADMIN. Běžnému uživateli je databáze vůbec nevydá.
-- Zveřejnění pro všechny = soubor zverejnit_krizove_postupy.sql (přepne app_meta 'krize_verejne').
drop policy if exists postupy_select on public.postupy;
create policy postupy_select on public.postupy
  for select using (
    public.is_admin()
    or exists (select 1 from public.app_meta m where m.key = 'krize_verejne' and m.value = 'true')
  );

drop policy if exists postupy_write on public.postupy;
create policy postupy_write on public.postupy
  for all using (public.is_admin()) with check (public.is_admin());

-- 3) přehled obsahu pro admina (počet postupů navíc)
create or replace function public.content_info()
returns json
language sql
stable
security invoker
set search_path = public
as $$
  select json_build_object(
    'questions',  (select count(*) from public.questions where kategorie = 'predpisy'),
    'loko',       (select count(*) from public.questions where kategorie = 'lokomotivy'),
    'postupy',    (select count(*) from public.postupy),
    'images',     (select count(*) from public.question_images),
    'version',    (select value from public.app_meta where key = 'content_version')
  );
$$;

grant execute on function public.content_info() to authenticated;

-- kontrola
select 'ok' as stav,
       (select count(*) from public.questions) as otazek_celkem,
       (select count(*) from public.postupy)   as postupu;
