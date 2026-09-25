-- =====================================================================
--  ZOZ Trenažér – oprava statistik, druhé kolo
--
--  Obsahuje všechno z `oprava_statistik.sql` (opakované spuštění nevadí)
--  a navíc POJISTKU PŘÍMO V DATABÁZI: i kdyby někde běžela stará verze
--  aplikace, databáze druhou kopii téže odpovědi tiše zahodí.
--
--  Spustit celé najednou v SQL editoru.
-- =====================================================================

-- ---------- 0) DIAGNOSTIKA: která verze aplikace zapisuje? ----------
-- client_id a chosen umí vyplnit jen nová verze. Když jsou samé NULL,
-- v prohlížeči pořád běží ta stará.
select 'kdo zapisuje' as kontrola,
       count(*)                                        as odpovedi_celkem,
       count(*) filter (where client_id is null)       as zapsala_stara_verze,
       count(*) filter (where client_id is not null)   as zapsala_nova_verze,
       count(*) filter (where chosen is not null)      as ma_rozpad_moznosti,
       max(created_at)                                 as posledni_zapis
from public.attempts;


-- ---------- 1) sloupce a indexy (když už jsou, nic se nestane) ----------
alter table public.attempts  add column if not exists client_id uuid;
alter table public.test_runs add column if not exists client_id uuid;
alter table public.attempts  add column if not exists chosen smallint;

create unique index if not exists attempts_client_idx  on public.attempts(client_id);
create unique index if not exists test_runs_client_idx on public.test_runs(client_id);

drop policy if exists attempts_update on public.attempts;
create policy attempts_update on public.attempts
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists test_runs_update on public.test_runs;
create policy test_runs_update on public.test_runs
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());


-- ---------- 2) POJISTKA V DATABÁZI ----------
-- Každá odpověď nese čas vzniku z prohlížeče. Kopie jedné odpovědi mají
-- tenhle čas shodný na milisekundu, takže druhý a další pokus o uložení
-- téhož se dá bezpečně zahodit. Tichý návrat NULL znamená „tenhle řádek
-- neukládej" – celá dávka přitom projde, nic se neztratí.

create or replace function public.attempts_bez_kopii()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if exists (select 1 from public.attempts a
              where a.user_id    = new.user_id
                and a.question_n = new.question_n
                and a.created_at = new.created_at) then
    return null;
  end if;
  return new;
end;
$$;

drop trigger if exists attempts_bez_kopii_trg on public.attempts;
create trigger attempts_bez_kopii_trg
  before insert on public.attempts
  for each row execute function public.attempts_bez_kopii();

create or replace function public.test_runs_bez_kopii()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if exists (select 1 from public.test_runs t
              where t.user_id = new.user_id and t.created_at = new.created_at) then
    return null;
  end if;
  return new;
end;
$$;

drop trigger if exists test_runs_bez_kopii_trg on public.test_runs;
create trigger test_runs_bez_kopii_trg
  before insert on public.test_runs
  for each row execute function public.test_runs_bez_kopii();


-- ---------- 3) úklid toho, co už v databázi je ----------
delete from public.attempts a
using public.attempts b
where a.user_id = b.user_id and a.question_n = b.question_n
  and a.created_at = b.created_at and a.id > b.id;

delete from public.test_runs a
using public.test_runs b
where a.user_id = b.user_id and a.created_at = b.created_at and a.id > b.id;


-- ---------- 4) statistiky s rozpadem možností ----------
drop function if exists public.my_question_stats();
create or replace function public.my_question_stats()
returns table (question_n int, ok int, bad int, c0 int, c1 int, c2 int)
language sql stable security invoker set search_path = public as $$
  select a.question_n,
         count(*) filter (where a.correct)::int,
         count(*) filter (where not a.correct)::int,
         count(*) filter (where a.chosen = 0)::int,
         count(*) filter (where a.chosen = 1)::int,
         count(*) filter (where a.chosen = 2)::int
  from public.attempts a
  where a.user_id = auth.uid()
  group by a.question_n;
$$;

drop function if exists public.admin_worst_questions(int,int);
create or replace function public.admin_worst_questions(lim int default 20, min_answers int default 5)
returns table (question_n int, tema text, predpis text, answers int, ok int, c0 int, c1 int, c2 int)
language sql stable security definer set search_path = public as $$
  select a.question_n,
         max(a.tema), max(a.predpis),
         count(*)::int,
         count(*) filter (where a.correct)::int,
         count(*) filter (where a.chosen = 0)::int,
         count(*) filter (where a.chosen = 1)::int,
         count(*) filter (where a.chosen = 2)::int
  from public.attempts a
  where public.is_admin()
  group by a.question_n
  having count(*) >= min_answers
  order by (count(*) filter (where a.correct))::numeric / count(*) asc, count(*) desc
  limit lim;
$$;

grant execute on function public.my_question_stats()            to authenticated;
grant execute on function public.admin_worst_questions(int,int) to authenticated;


-- ---------- 5) VYNULOVÁNÍ STATISTIK ----------
-- Data z doby před opravou jsou nafouknutá a nemají zaznamenané možnosti.
-- Doporučuju začít načisto – účty, otázky ani hlášení to nesmaže.
-- Odkomentuj (smaž dvě pomlčky na začátku řádku) a spusť:

-- delete from public.attempts;
-- delete from public.test_runs;


-- ---------- 6) kontrola ----------
select 'po opravě' as stav,
       (select count(*) from public.attempts)  as odpovedi,
       (select count(*) from public.test_runs) as testy;

-- musí vrátit prázdno
select user_id, question_n, created_at, count(*)
from public.attempts group by user_id, question_n, created_at having count(*) > 1;
