-- =====================================================================
--  ZOZ Trenažér – databázové schéma pro Supabase
--  Spusť celé najednou v Supabase → SQL Editor → New query → Run.
--  Stačí jednou; opakované spuštění je bezpečné (IF NOT EXISTS / OR REPLACE).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. TABULKY
-- ---------------------------------------------------------------------

-- profil uživatele (1:1 k účtu v auth.users)
create table if not exists public.profiles (
  id           uuid primary key references auth.users(id) on delete cascade,
  email        text,
  display_name text,
  is_admin     boolean     not null default false,
  created_at   timestamptz not null default now(),
  last_seen_at timestamptz not null default now()
);

-- jedna zodpovězená otázka (v testu nebo na kartičce)
create table if not exists public.attempts (
  id         bigserial primary key,
  user_id    uuid        not null references auth.users(id) on delete cascade,
  question_n int         not null,
  tema       text,
  predpis    text,
  correct    boolean     not null,
  mode       text        not null default 'test',   -- 'test' | 'karta'
  created_at timestamptz not null default now()
);

create index if not exists attempts_user_idx     on public.attempts(user_id);
create index if not exists attempts_created_idx  on public.attempts(created_at);
create index if not exists attempts_question_idx on public.attempts(question_n);

-- dokončený test
create table if not exists public.test_runs (
  id             bigserial primary key,
  user_id        uuid        not null references auth.users(id) on delete cascade,
  total          int         not null,
  answered       int         not null,
  correct        int         not null,
  time_limit_min int         not null default 0,
  timed_out      boolean     not null default false,
  tema           text,
  predpis        text,
  created_at     timestamptz not null default now()
);

create index if not exists test_runs_user_idx    on public.test_runs(user_id);
create index if not exists test_runs_created_idx on public.test_runs(created_at);

-- ---------------------------------------------------------------------
-- 2. ZALOŽENÍ PROFILU PŘI REGISTRACI
-- ---------------------------------------------------------------------

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, display_name)
  values (new.id, new.email, coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- zabrání tomu, aby si uživatel sám nastavil is_admin
create or replace function public.protect_admin_flag()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_admin is distinct from old.is_admin then
    if not exists (select 1 from public.profiles p where p.id = auth.uid() and p.is_admin) then
      new.is_admin := old.is_admin;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists profiles_protect_admin on public.profiles;
create trigger profiles_protect_admin
  before update on public.profiles
  for each row execute function public.protect_admin_flag();

-- ---------------------------------------------------------------------
-- 3. POMOCNÁ FUNKCE „jsem admin?“
-- ---------------------------------------------------------------------

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select p.is_admin from public.profiles p where p.id = auth.uid()), false);
$$;

-- ---------------------------------------------------------------------
-- 4. ROW LEVEL SECURITY
-- ---------------------------------------------------------------------

alter table public.profiles  enable row level security;
alter table public.attempts  enable row level security;
alter table public.test_runs enable row level security;

drop policy if exists profiles_select on public.profiles;
create policy profiles_select on public.profiles
  for select using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_update on public.profiles;
create policy profiles_update on public.profiles
  for update using (id = auth.uid() or public.is_admin());

drop policy if exists profiles_insert on public.profiles;
create policy profiles_insert on public.profiles
  for insert with check (id = auth.uid());

drop policy if exists attempts_select on public.attempts;
create policy attempts_select on public.attempts
  for select using (user_id = auth.uid() or public.is_admin());

drop policy if exists attempts_insert on public.attempts;
create policy attempts_insert on public.attempts
  for insert with check (user_id = auth.uid());

drop policy if exists attempts_delete on public.attempts;
create policy attempts_delete on public.attempts
  for delete using (user_id = auth.uid() or public.is_admin());

drop policy if exists test_runs_select on public.test_runs;
create policy test_runs_select on public.test_runs
  for select using (user_id = auth.uid() or public.is_admin());

drop policy if exists test_runs_insert on public.test_runs;
create policy test_runs_insert on public.test_runs
  for insert with check (user_id = auth.uid());

drop policy if exists test_runs_delete on public.test_runs;
create policy test_runs_delete on public.test_runs
  for delete using (user_id = auth.uid() or public.is_admin());

-- ---------------------------------------------------------------------
-- 5. FUNKCE PRO UŽIVATELE
-- ---------------------------------------------------------------------

-- statistika po otázkách (pro „slabá místa“ a filtr „jen chybované“)
create or replace function public.my_question_stats()
returns table (question_n int, ok int, bad int)
language sql
stable
security invoker
set search_path = public
as $$
  select a.question_n,
         count(*) filter (where a.correct)::int      as ok,
         count(*) filter (where not a.correct)::int  as bad
  from public.attempts a
  where a.user_id = auth.uid()
  group by a.question_n;
$$;

-- úspěšnost po tématech a předpisech (pro doporučení, na co se zaměřit)
create or replace function public.my_area_stats()
returns table (kind text, name text, ok int, bad int)
language sql
stable
security invoker
set search_path = public
as $$
  select 'tema'::text, a.tema,
         count(*) filter (where a.correct)::int,
         count(*) filter (where not a.correct)::int
  from public.attempts a
  where a.user_id = auth.uid() and a.tema is not null
  group by a.tema
  union all
  select 'predpis'::text, a.predpis,
         count(*) filter (where a.correct)::int,
         count(*) filter (where not a.correct)::int
  from public.attempts a
  where a.user_id = auth.uid() and a.predpis is not null
  group by a.predpis;
$$;

-- zaznamená, že uživatel byl aktivní
create or replace function public.touch_me()
returns void
language sql
volatile
security invoker
set search_path = public
as $$
  update public.profiles set last_seen_at = now() where id = auth.uid();
$$;

-- smaže vlastní historii
create or replace function public.reset_my_stats()
returns void
language sql
volatile
security invoker
set search_path = public
as $$
  delete from public.attempts  where user_id = auth.uid();
  delete from public.test_runs where user_id = auth.uid();
$$;

-- ---------------------------------------------------------------------
-- 6. FUNKCE PRO ADMINA
-- ---------------------------------------------------------------------

create or replace function public.admin_overview()
returns json
language sql
stable
security definer
set search_path = public
as $$
  select case when not public.is_admin() then null else json_build_object(
    'users_total',    (select count(*) from public.profiles),
    'users_7d',       (select count(*) from public.profiles where created_at > now() - interval '7 days'),
    'users_30d',      (select count(*) from public.profiles where created_at > now() - interval '30 days'),
    'active_7d',      (select count(*) from public.profiles where last_seen_at > now() - interval '7 days'),
    'active_30d',     (select count(*) from public.profiles where last_seen_at > now() - interval '30 days'),
    'tests_total',    (select count(*) from public.test_runs),
    'answers_total',  (select count(*) from public.attempts),
    'success_pct',    (select coalesce(round(100.0 * count(*) filter (where correct) / nullif(count(*),0)), 0) from public.attempts)
  ) end;
$$;

create or replace function public.admin_users()
returns table (
  email text, display_name text, is_admin boolean,
  created_at timestamptz, last_seen_at timestamptz,
  answers int, ok int, tests int
)
language sql
stable
security definer
set search_path = public
as $$
  select p.email, p.display_name, p.is_admin, p.created_at, p.last_seen_at,
         coalesce(a.cnt,0)::int, coalesce(a.ok,0)::int, coalesce(t.cnt,0)::int
  from public.profiles p
  left join (select user_id, count(*) cnt, count(*) filter (where correct) ok
             from public.attempts group by user_id) a on a.user_id = p.id
  left join (select user_id, count(*) cnt from public.test_runs group by user_id) t on t.user_id = p.id
  where public.is_admin()
  order by p.last_seen_at desc;
$$;

create or replace function public.admin_worst_questions(min_answers int default 5, lim int default 30)
returns table (question_n int, tema text, predpis text, answers int, ok int)
language sql
stable
security definer
set search_path = public
as $$
  select a.question_n,
         max(a.tema), max(a.predpis),
         count(*)::int,
         count(*) filter (where a.correct)::int
  from public.attempts a
  where public.is_admin()
  group by a.question_n
  having count(*) >= min_answers
  order by (count(*) filter (where a.correct))::numeric / count(*) asc, count(*) desc
  limit lim;
$$;

create or replace function public.admin_area_stats()
returns table (kind text, name text, answers int, ok int)
language sql
stable
security definer
set search_path = public
as $$
  select 'tema'::text, a.tema, count(*)::int, count(*) filter (where a.correct)::int
  from public.attempts a where public.is_admin() and a.tema is not null group by a.tema
  union all
  select 'predpis'::text, a.predpis, count(*)::int, count(*) filter (where a.correct)::int
  from public.attempts a where public.is_admin() and a.predpis is not null group by a.predpis;
$$;

-- denní registrace a aktivita za posledních 60 dní (graf v adminu)
create or replace function public.admin_daily(days int default 60)
returns table (den date, registrace int, odpovedi int, testy int)
language sql
stable
security definer
set search_path = public
as $$
  with d as (select generate_series(current_date - (days-1), current_date, '1 day')::date as den)
  select d.den,
    (select count(*) from public.profiles  p where p.created_at::date = d.den)::int,
    (select count(*) from public.attempts  a where a.created_at::date = d.den)::int,
    (select count(*) from public.test_runs t where t.created_at::date = d.den)::int
  from d
  where public.is_admin()
  order by d.den;
$$;

-- ---------------------------------------------------------------------
-- 7. NASTAVENÍ ADMINA
--    Zaregistruj se v aplikaci svým e-mailem a pak spusť tento řádek
--    (uprav e-mail):
-- ---------------------------------------------------------------------
-- update public.profiles set is_admin = true where email = 'tvuj@email.cz';

-- =====================================================================
--  ČÁST 2 – OBSAH OTÁZEK V DATABÁZI
--  (aby otázky nebyly přímo v HTML souboru a byly dostupné až po přihlášení)
--  Spusť stejně jako část 1: SQL Editor → New query → Run.
-- =====================================================================

create table if not exists public.questions (
  n           int primary key,
  otazka      text not null,
  tema        text,
  predpis     text,
  jistota     text,
  odpoved     text,
  plne_zneni  text,
  poznamka    text,
  zdroje      jsonb default '[]'::jsonb,
  distraktory jsonb default '[]'::jsonb,
  obrazky     jsonb default '[]'::jsonb,
  updated_at  timestamptz not null default now()
);

create table if not exists public.question_images (
  path       text primary key,
  data       text not null,           -- data:image/webp;base64,...
  updated_at timestamptz not null default now()
);

create table if not exists public.app_meta (
  key   text primary key,
  value text
);

alter table public.questions       enable row level security;
alter table public.question_images enable row level security;
alter table public.app_meta        enable row level security;

-- číst smí jen přihlášený uživatel
drop policy if exists questions_select on public.questions;
create policy questions_select on public.questions
  for select using (auth.uid() is not null);

drop policy if exists question_images_select on public.question_images;
create policy question_images_select on public.question_images
  for select using (auth.uid() is not null);

drop policy if exists app_meta_select on public.app_meta;
create policy app_meta_select on public.app_meta
  for select using (auth.uid() is not null);

-- zapisovat smí jen admin
drop policy if exists questions_write on public.questions;
create policy questions_write on public.questions
  for all using (public.is_admin()) with check (public.is_admin());

drop policy if exists question_images_write on public.question_images;
create policy question_images_write on public.question_images
  for all using (public.is_admin()) with check (public.is_admin());

drop policy if exists app_meta_write on public.app_meta;
create policy app_meta_write on public.app_meta
  for all using (public.is_admin()) with check (public.is_admin());

-- kolik je v databázi otázek a obrázků (pro admin sekci)
create or replace function public.content_info()
returns json
language sql
stable
security invoker
set search_path = public
as $$
  select json_build_object(
    'questions', (select count(*) from public.questions),
    'images',    (select count(*) from public.question_images),
    'version',   (select value from public.app_meta where key = 'content_version')
  );
$$;
