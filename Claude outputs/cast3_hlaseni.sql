-- =====================================================================
--  ČÁST 3 – HLÁŠENÍ CHYB V OTÁZKÁCH  (spusť v SQL Editoru → Run)
--  Přidává tabulku hlášení + admin funkce. Nic stávajícího nemaže.
-- =====================================================================

create table if not exists public.reports (
  id          bigserial primary key,
  user_id     uuid references auth.users(id) on delete set null,
  question_n  int,
  kind        text        not null default 'jine',   -- odpoved | otazka | zdroj | obrazek | jine
  message     text,
  context     text,                                   -- test | karta | prehled
  status      text        not null default 'nove',    -- nove | vyreseno
  admin_note  text,
  created_at  timestamptz not null default now(),
  resolved_at timestamptz
);

create index if not exists reports_status_idx   on public.reports(status, created_at desc);
create index if not exists reports_question_idx on public.reports(question_n);

alter table public.reports enable row level security;

drop policy if exists reports_insert on public.reports;
create policy reports_insert on public.reports
  for insert with check (user_id = auth.uid());

drop policy if exists reports_select on public.reports;
create policy reports_select on public.reports
  for select using (user_id = auth.uid() or public.is_admin());

drop policy if exists reports_update on public.reports;
create policy reports_update on public.reports
  for update using (public.is_admin()) with check (public.is_admin());

drop policy if exists reports_delete on public.reports;
create policy reports_delete on public.reports
  for delete using (public.is_admin());

-- seznam hlášení pro admina (včetně e-mailu autora)
create or replace function public.admin_reports(only_new boolean default false)
returns table (
  id bigint, created_at timestamptz, email text, question_n int,
  kind text, message text, context text, status text, admin_note text
)
language sql
stable
security definer
set search_path = public
as $$
  select r.id, r.created_at, p.email, r.question_n,
         r.kind, r.message, r.context, r.status, r.admin_note
  from public.reports r
  left join public.profiles p on p.id = r.user_id
  where public.is_admin()
    and (not only_new or r.status = 'nove')
  order by (r.status = 'nove') desc, r.created_at desc
  limit 300;
$$;

-- označení hlášení za vyřešené / znovu otevřené
create or replace function public.admin_set_report_status(rid bigint, new_status text)
returns void
language sql
volatile
security definer
set search_path = public
as $$
  update public.reports
  set status = new_status,
      resolved_at = case when new_status = 'vyreseno' then now() else null end
  where id = rid and public.is_admin();
$$;

-- přehled pro admina (doplněn počet nových hlášení)
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
    'success_pct',    (select coalesce(round(100.0 * count(*) filter (where correct) / nullif(count(*),0)), 0) from public.attempts),
    'reports_new',    (select count(*) from public.reports where status = 'nove')
  ) end;
$$;
